/**
 * Excel匯入組件
 * 檔案名稱: ExcelImport.jsx
 * 處理Excel文件上傳、解析和題目匯入
 */

import React, { useState, useCallback } from 'react';
import * as XLSX from 'xlsx';
import apiService from './ApiService';

const ExcelImport = ({ onImportComplete, onClose }) => {
    const [file, setFile] = useState(null);
    const [parsing, setParsing] = useState(false);
    const [importing, setImporting] = useState(false);
    const [previewData, setPreviewData] = useState([]);
    const [importResult, setImportResult] = useState(null);
    const [error, setError] = useState('');

    /**
     * 處理文件選擇
     */
    const handleFileSelect = useCallback((event) => {
        const selectedFile = event.target.files[0];
        if (!selectedFile) return;

        if (!selectedFile.name.match(/\.(xlsx|xls)$/)) {
            setError('請選擇有效的Excel文件 (.xlsx 或 .xls)');
            return;
        }

        setFile(selectedFile);
        setError('');
        setPreviewData([]);
        setImportResult(null);
    }, []);

    /**
     * 解析Excel文件
     */
    const parseExcelFile = useCallback(async () => {
        if (!file) return;

        setParsing(true);
        setError('');

        try {
            const buffer = await file.arrayBuffer();
            const workbook = XLSX.read(buffer, { 
                type: 'buffer',
                cellText: false,
                cellDates: true
            });

            const sheetName = workbook.SheetNames[0];
            const worksheet = workbook.Sheets[sheetName];
            
            // 轉換為JSON，保留原始格式
            const rawData = XLSX.utils.sheet_to_json(worksheet, { 
                header: 1,
                defval: '',
                blankrows: false
            });

            if (rawData.length < 2) {
                throw new Error('Excel文件必須包含標題行和至少一行數據');
            }

            // 獲取標題行
            const headers = rawData[0];
            console.log('Excel標題行:', headers);

            // 處理數據行
            const dataRows = rawData.slice(1).filter(row => 
                row.some(cell => cell !== null && cell !== undefined && cell !== '')
            );

            // 智能映射欄位
            const mappedData = dataRows.map((row, index) => {
                const mappedRow = mapExcelRowToQuestion(headers, row, index);
                return mappedRow;
            }).filter(row => row !== null);

            if (mappedData.length === 0) {
                throw new Error('沒有找到有效的題目數據');
            }

            console.log('解析成功，題目數量:', mappedData.length);
            console.log('第一題範例:', mappedData[0]);

            setPreviewData(mappedData);

        } catch (error) {
            console.error('Excel解析錯誤:', error);
            setError(`Excel解析失敗: ${error.message}`);
        } finally {
            setParsing(false);
        }
    }, [file]);

    /**
     * 智能映射Excel行到題目格式
     */
    const mapExcelRowToQuestion = (headers, row, index) => {
        try {
            // 創建標題到索引的映射
            const headerMap = {};
            headers.forEach((header, idx) => {
                if (header) {
                    const normalizedHeader = header.toString().toLowerCase().trim();
                    headerMap[normalizedHeader] = idx;
                }
            });

            // 輔助函數：根據多個可能的欄位名稱查找值
            const findValue = (possibleNames) => {
                for (const name of possibleNames) {
                    const idx = headerMap[name.toLowerCase()];
                    if (idx !== undefined && row[idx] !== undefined && row[idx] !== '') {
                        return row[idx].toString().trim();
                    }
                }
                return '';
            };

            // 映射基本信息
            const questionNumber = findValue(['題號', '序號', '編號', 'number', 'no']) || (index + 1);
            const year = findValue(['年份', 'year', '年度']) || 2015;
            const semester = findValue(['學期', 'semester']) || 1;
            
            // 映射科目ID（預設為6 - 臨床血清免疫學）
            let categoryId = 6;
            const categoryName = findValue(['科目', 'category', '類別', '分類']);
            if (categoryName) {
                // 根據科目名稱推測ID
                if (categoryName.includes('生理') || categoryName.includes('病理')) categoryId = 1;
                else if (categoryName.includes('血液') || categoryName.includes('血庫')) categoryId = 2;
                else if (categoryName.includes('分子') || categoryName.includes('鏡檢')) categoryId = 3;
                else if (categoryName.includes('微生物')) categoryId = 4;
                else if (categoryName.includes('生化')) categoryId = 5;
                else if (categoryName.includes('血清') || categoryName.includes('免疫') || categoryName.includes('病毒')) categoryId = 6;
            }

            // 映射題目內容
            const question = findValue(['題目', 'question', '問題', '內容', '題幹']);
            if (!question) {
                console.warn(`第${index + 1}行缺少題目內容`);
                return null;
            }

            // 映射選項
            const optionA = findValue(['選項a', 'option a', 'a', '(a)', 'a.', '選項1']) || '';
            const optionB = findValue(['選項b', 'option b', 'b', '(b)', 'b.', '選項2']) || '';
            const optionC = findValue(['選項c', 'option c', 'c', '(c)', 'c.', '選項3']) || '';
            const optionD = findValue(['選項d', 'option d', 'd', '(d)', 'd.', '選項4']) || '';

            // 映射正確答案
            let correctAnswer = findValue(['答案', 'answer', '正確答案', '解答']).toUpperCase();
            if (!['A', 'B', 'C', 'D'].includes(correctAnswer)) {
                console.warn(`第${index + 1}行答案格式錯誤: ${correctAnswer}，使用預設值A`);
                correctAnswer = 'A';
            }

            // 映射解釋
            const explanation = findValue(['解釋', 'explanation', '說明', '解析']) || '';

            return {
                questionNumber: parseInt(questionNumber) || (index + 1),
                year: parseInt(year) || 2015,
                semester: parseInt(semester) || 1,
                categoryId: categoryId,
                subCategory: categoryName || '臨床血清免疫學與臨床病毒學',
                question: question,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                correctAnswer: correctAnswer,
                explanation: explanation,
                difficulty: 'medium'
            };

        } catch (error) {
            console.error(`處理第${index + 1}行時發生錯誤:`, error);
            return null;
        }
    };

    /**
     * 執行匯入
     */
    const handleImport = useCallback(async () => {
        if (previewData.length === 0) {
            setError('沒有可匯入的數據，請先解析Excel文件');
            return;
        }

        setImporting(true);
        setError('');

        try {
            console.log('開始匯入題目...', previewData.length, '題');
            
            const result = await apiService.importQuestions(previewData, 'excel');
            
            console.log('匯入結果:', result);
            setImportResult(result.data);
            
            // 通知父組件匯入完成
            if (onImportComplete) {
                onImportComplete(result.data);
            }

        } catch (error) {
            console.error('匯入失敗:', error);
            setError(`匯入失敗: ${error.message}`);
        } finally {
            setImporting(false);
        }
    }, [previewData, onImportComplete]);

    /**
     * 重置狀態
     */
    const resetState = useCallback(() => {
        setFile(null);
        setPreviewData([]);
        setImportResult(null);
        setError('');
        if (document.querySelector('input[type="file"]')) {
            document.querySelector('input[type="file"]').value = '';
        }
    }, []);

    return (
        <div className="excel-import-container max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-lg">
            <div className="flex justify-between items-center mb-6">
                <h2 className="text-2xl font-bold text-gray-800">📊 Excel題目匯入</h2>
                {onClose && (
                    <button
                        onClick={onClose}
                        className="text-gray-500 hover:text-gray-700 text-xl"
                    >
                        ✕
                    </button>
                )}
            </div>

            {/* 文件選擇區域 */}
            <div className="mb-6">
                <div className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center">
                    <input
                        type="file"
                        accept=".xlsx,.xls"
                        onChange={handleFileSelect}
                        className="hidden"
                        id="excel-file-input"
                    />
                    <label
                        htmlFor="excel-file-input"
                        className="cursor-pointer block"
                    >
                        <div className="mb-4">
                            <span className="text-4xl">📁</span>
                        </div>
                        <div className="text-lg font-medium text-gray-700 mb-2">
                            選擇Excel文件
                        </div>
                        <div className="text-sm text-gray-500">
                            支援 .xlsx 和 .xls 格式
                        </div>
                    </label>
                </div>

                {file && (
                    <div className="mt-4 p-4 bg-blue-50 rounded-lg">
                        <div className="flex items-center justify-between">
                            <div>
                                <span className="font-medium">已選擇文件：</span>
                                <span className="text-blue-600">{file.name}</span>
                                <span className="text-gray-500 ml-2">
                                    ({(file.size / 1024).toFixed(1)} KB)
                                </span>
                            </div>
                            <div className="space-x-2">
                                <button
                                    onClick={parseExcelFile}
                                    disabled={parsing}
                                    className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
                                >
                                    {parsing ? '解析中...' : '解析文件'}
                                </button>
                                <button
                                    onClick={resetState}
                                    className="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700"
                                >
                                    重新選擇
                                </button>
                            </div>
                        </div>
                    </div>
                )}
            </div>

            {/* 錯誤顯示 */}
            {error && (
                <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                    <div className="text-red-700">
                        <span className="font-medium">❌ 錯誤：</span>
                        {error}
                    </div>
                </div>
            )}

            {/* 預覽數據 */}
            {previewData.length > 0 && (
                <div className="mb-6">
                    <div className="flex justify-between items-center mb-4">
                        <h3 className="text-xl font-bold text-gray-800">
                            📋 資料預覽 ({previewData.length} 題)
                        </h3>
                        <button
                            onClick={handleImport}
                            disabled={importing}
                            className="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:opacity-50 font-medium"
                        >
                            {importing ? '匯入中...' : `匯入 ${previewData.length} 題`}
                        </button>
                    </div>

                    <div className="overflow-x-auto">
                        <table className="min-w-full border border-gray-300 rounded-lg">
                            <thead className="bg-gray-50">
                                <tr>
                                    <th className="px-4 py-2 border text-left">題號</th>
                                    <th className="px-4 py-2 border text-left">年份</th>
                                    <th className="px-4 py-2 border text-left">科目</th>
                                    <th className="px-4 py-2 border text-left">題目</th>
                                    <th className="px-4 py-2 border text-left">答案</th>
                                </tr>
                            </thead>
                            <tbody>
                                {previewData.slice(0, 10).map((item, index) => (
                                    <tr key={index} className="hover:bg-gray-50">
                                        <td className="px-4 py-2 border">{item.questionNumber}</td>
                                        <td className="px-4 py-2 border">{item.year}</td>
                                        <td className="px-4 py-2 border">{item.subCategory}</td>
                                        <td className="px-4 py-2 border">
                                            <div className="max-w-md truncate" title={item.question}>
                                                {item.question}
                                            </div>
                                        </td>
                                        <td className="px-4 py-2 border text-center">
                                            <span className="inline-block w-6 h-6 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">
                                                {item.correctAnswer}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                        {previewData.length > 10 && (
                            <div className="text-center py-2 text-gray-500">
                                顯示前10題，共{previewData.length}題
                            </div>
                        )}
                    </div>
                </div>
            )}

            {/* 匯入結果 */}
            {importResult && (
                <div className="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                    <h3 className="text-lg font-bold text-green-800 mb-3">🎉 匯入完成</h3>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                        <div className="bg-white p-3 rounded">
                            <div className="text-2xl font-bold text-blue-600">{importResult.total}</div>
                            <div className="text-sm text-gray-600">總題目</div>
                        </div>
                        <div className="bg-white p-3 rounded">
                            <div className="text-2xl font-bold text-green-600">{importResult.success}</div>
                            <div className="text-sm text-gray-600">成功</div>
                        </div>
                        <div className="bg-white p-3 rounded">
                            <div className="text-2xl font-bold text-orange-600">{importResult.duplicate || 0}</div>
                            <div className="text-sm text-gray-600">重複跳過</div>
                        </div>
                        <div className="bg-white p-3 rounded">
                            <div className="text-2xl font-bold text-red-600">{importResult.error}</div>
                            <div className="text-sm text-gray-600">失敗</div>
                        </div>
                    </div>
                    {importResult.errors && importResult.errors.length > 0 && (
                        <div className="mt-4">
                            <h4 className="font-medium text-red-700 mb-2">錯誤詳情：</h4>
                            <ul className="text-sm text-red-600 space-y-1">
                                {importResult.errors.slice(0, 5).map((error, index) => (
                                    <li key={index}>• {error}</li>
                                ))}
                                {importResult.errors.length > 5 && (
                                    <li>... 還有 {importResult.errors.length - 5} 個錯誤</li>
                                )}
                            </ul>
                        </div>
                    )}
                </div>
            )}

            {/* 使用說明 */}
            <div className="bg-gray-50 p-4 rounded-lg">
                <h3 className="font-bold text-gray-800 mb-2">📋 Excel格式說明</h3>
                <div className="text-sm text-gray-600 space-y-1">
                    <p>• 第一行必須是標題行（欄位名稱）</p>
                    <p>• 必要欄位：題目、選項A、選項B、選項C、選項D、答案</p>
                    <p>• 可選欄位：題號、年份、科目、解釋</p>
                    <p>• 答案格式：A、B、C、D（不區分大小寫）</p>
                    <p>• 支援的欄位名稱變體：question/題目、option a/選項a、answer/答案等</p>
                </div>
            </div>
        </div>
    );
};

export default ExcelImport;