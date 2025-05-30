import React, { useState } from 'react'
import * as XLSX from 'xlsx'

const ExcelImport = ({ apiService, onClose, onSuccess }) => {
  const [file, setFile] = useState(null)
  const [uploading, setUploading] = useState(false)
  const [preview, setPreview] = useState([])
  const [validationErrors, setValidationErrors] = useState([])
  const [uploadProgress, setUploadProgress] = useState(0)
  const [uploadResults, setUploadResults] = useState(null)

  const expectedColumns = [
    '題號', '年份', '學期', '科目', '主題分類', '題目內容',
    '選項A', '選項B', '選項C', '選項D', '正確答案', '詳解'
  ]

  const subjectMapping = {
    '臨床生理學與病理學': 1,
    '臨床血液學與血庫學': 2,
    '醫學分子檢驗學與臨床鏡檢學': 3,
    '微生物學與臨床微生物學': 4,
    '生物化學與臨床生化學': 5,
    '臨床血清免疫學與臨床病毒學': 6
  }

  const handleFileSelect = (event) => {
    const selectedFile = event.target.files[0]
    if (selectedFile) {
      setFile(selectedFile)
      parseExcelFile(selectedFile)
    }
  }

  const parseExcelFile = (file) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target.result)
        const workbook = XLSX.read(data, { type: 'array' })
        const sheetName = workbook.SheetNames[0]
        const worksheet = workbook.Sheets[sheetName]
        const jsonData = XLSX.utils.sheet_to_json(worksheet)

        console.log('解析的Excel資料:', jsonData)
        
        if (jsonData.length === 0) {
          alert('Excel檔案是空的或格式不正確')
          return
        }

        // 驗證欄位
        const firstRow = jsonData[0]
        const actualColumns = Object.keys(firstRow)
        const missingColumns = expectedColumns.filter(col => !actualColumns.includes(col))
        
        if (missingColumns.length > 0) {
          alert(`缺少必要欄位: ${missingColumns.join(', ')}`)
          return
        }

        // 資料驗證和預處理
        const processedData = validateAndProcessData(jsonData)
        setPreview(processedData.slice(0, 10)) // 只顯示前10筆預覽
        
      } catch (error) {
        console.error('解析Excel失敗:', error)
        alert('Excel檔案格式錯誤')
      }
    }
    reader.readAsArrayBuffer(file)
  }

  const validateAndProcessData = (data) => {
    const errors = []
    const processedData = []

    data.forEach((row, index) => {
      const rowNumber = index + 2 // Excel從第2行開始(第1行是標題)
      const processedRow = {}
      
      // 驗證必要欄位
      if (!row['題號'] || !row['科目'] || !row['題目內容']) {
        errors.push(`第${rowNumber}行：缺少必要欄位`)
        return
      }

      // 驗證科目
      if (!subjectMapping[row['科目']]) {
        errors.push(`第${rowNumber}行：科目「${row['科目']}」不存在`)
        return
      }

      // 驗證正確答案
      if (!['A', 'B', 'C', 'D'].includes(row['正確答案'])) {
        errors.push(`第${rowNumber}行：正確答案必須是 A、B、C、D 其中之一`)
        return
      }

      // 處理資料
      processedRow.questionNumber = parseInt(row['題號'])
      processedRow.year = parseInt(row['年份']) || new Date().getFullYear()
      processedRow.semester = parseInt(row['學期']) || 1
      processedRow.categoryId = subjectMapping[row['科目']]
      processedRow.subCategory = row['主題分類'] || ''
      processedRow.question = row['題目內容'].trim()
      processedRow.optionA = row['選項A']?.trim() || ''
      processedRow.optionB = row['選項B']?.trim() || ''
      processedRow.optionC = row['選項C']?.trim() || ''
      processedRow.optionD = row['選項D']?.trim() || ''
      processedRow.correctAnswer = row['正確答案'].trim().toUpperCase()
      processedRow.explanation = row['詳解']?.trim() || ''
      processedRow.originalRow = rowNumber

      processedData.push(processedRow)
    })

    setValidationErrors(errors)
    return processedData
  }

  const uploadToDatabase = async () => {
    if (validationErrors.length > 0) {
      alert('請先修正驗證錯誤')
      return
    }

    setUploading(true)
    setUploadProgress(0)
    
    try {
      const allData = validateAndProcessData(
        XLSX.utils.sheet_to_json(
          XLSX.read(await file.arrayBuffer(), { type: 'array' }).Sheets[
            XLSX.read(await file.arrayBuffer(), { type: 'array' }).SheetNames[0]
          ]
        )
      )

      console.log('準備上傳的資料:', allData)

      const batchSize = 10 // 每次上傳10題
      let successCount = 0
      let errorCount = 0
      const errors = []

      for (let i = 0; i < allData.length; i += batchSize) {
        const batch = allData.slice(i, i + batchSize)
        
        try {
          const result = await apiService.importQuestions(batch)
          
          if (result.success) {
            successCount += batch.length
          } else {
            errorCount += batch.length
            errors.push(`批次 ${Math.floor(i/batchSize) + 1}: ${result.message}`)
          }
        } catch (error) {
          errorCount += batch.length
          errors.push(`批次 ${Math.floor(i/batchSize) + 1}: ${error.message}`)
        }

        // 更新進度
        setUploadProgress(Math.round(((i + batchSize) / allData.length) * 100))
        
        // 避免請求過快
        await new Promise(resolve => setTimeout(resolve, 500))
      }

      // 修正：正確設置上傳結果
      setUploadResults({
        total: allData.length,
        success: successCount,
        error: errorCount,
        errors: errors
      })

      // 修正：在設置結果後調用成功回調
      if (onSuccess && successCount > 0) {
        onSuccess() // 調用父組件的成功回調
      }

    } catch (error) {
      console.error('上傳失敗:', error)
      alert('上傳失敗：' + error.message)
    } finally {
      setUploading(false)
    }
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div className="p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-bold text-gray-900">Excel題目匯入</h2>
            <button
              onClick={onClose}
              className="text-gray-500 hover:text-gray-700"
            >
              ✕
            </button>
          </div>

          {/* 檔案上傳區域 */}
          <div className="mb-6">
            <div className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center">
              <input
                type="file"
                accept=".xlsx,.xls"
                onChange={handleFileSelect}
                className="hidden"
                id="excel-upload"
              />
              <label
                htmlFor="excel-upload"
                className="cursor-pointer flex flex-col items-center"
              >
                <div className="text-4xl mb-2">📊</div>
                <div className="text-lg font-semibold text-gray-700 mb-2">
                  點擊選擇Excel檔案
                </div>
                <div className="text-sm text-gray-500">
                  支援 .xlsx 和 .xls 格式
                </div>
              </label>
            </div>
            
            {file && (
              <div className="mt-3 text-sm text-gray-600">
                已選擇: {file.name} ({(file.size / 1024 / 1024).toFixed(2)} MB)
              </div>
            )}
          </div>

          {/* Excel格式說明 */}
          <div className="mb-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h3 className="font-semibold text-blue-900 mb-2">Excel格式要求：</h3>
            <div className="text-sm text-blue-800">
              <p className="mb-2">必須包含以下欄位（請確保欄位名稱完全相符）：</p>
              <div className="grid grid-cols-2 gap-2">
                {expectedColumns.map(col => (
                  <span key={col} className="bg-blue-100 px-2 py-1 rounded text-xs">
                    {col}
                  </span>
                ))}
              </div>
              <p className="mt-2 text-xs">
                • 正確答案必須是 A、B、C、D 其中之一<br/>
                • 科目必須是系統中已存在的科目名稱<br/>
                • 第一行必須是標題行，資料從第二行開始
              </p>
            </div>
          </div>

          {/* 驗證錯誤顯示 */}
          {validationErrors.length > 0 && (
            <div className="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
              <h3 className="font-semibold text-red-900 mb-2">
                發現 {validationErrors.length} 個錯誤：
              </h3>
              <div className="max-h-32 overflow-y-auto">
                {validationErrors.map((error, index) => (
                  <div key={index} className="text-sm text-red-700 mb-1">
                    • {error}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 資料預覽 */}
          {preview.length > 0 && (
            <div className="mb-6">
              <h3 className="font-semibold text-gray-900 mb-3">
                資料預覽 (前10筆)：
              </h3>
              <div className="overflow-x-auto">
                <table className="min-w-full bg-white border border-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">題號</th>
                      <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">科目</th>
                      <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">題目</th>
                      <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">答案</th>
                    </tr>
                  </thead>
                  <tbody>
                    {preview.map((row, index) => (
                      <tr key={index} className="border-b border-gray-200">
                        <td className="px-3 py-2 text-sm">{row.questionNumber}</td>
                        <td className="px-3 py-2 text-sm">
                          {Object.keys(subjectMapping).find(key => subjectMapping[key] === row.categoryId)}
                        </td>
                        <td className="px-3 py-2 text-sm max-w-xs truncate">
                          {row.question}
                        </td>
                        <td className="px-3 py-2 text-sm font-medium">{row.correctAnswer}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 上傳進度 */}
          {uploading && (
            <div className="mb-6">
              <div className="flex justify-between text-sm text-gray-600 mb-2">
                <span>上傳進度</span>
                <span>{uploadProgress}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                  style={{ width: `${uploadProgress}%` }}
                ></div>
              </div>
            </div>
          )}

          {/* 上傳結果 */}
          {uploadResults && (
            <div className="mb-6 bg-green-50 border border-green-200 rounded-lg p-4">
              <h3 className="font-semibold text-green-900 mb-2">上傳完成！</h3>
              <div className="text-sm text-green-800">
                <p>總計: {uploadResults.total} 題</p>
                <p>成功: {uploadResults.success} 題</p>
                <p>失敗: {uploadResults.error} 題</p>
                
                {uploadResults.errors.length > 0 && (
                  <div className="mt-2">
                    <p className="font-medium">錯誤詳情:</p>
                    {uploadResults.errors.map((error, index) => (
                      <div key={index} className="text-xs ml-2">• {error}</div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          )}

          {/* 操作按鈕 */}
          <div className="flex gap-3">
            <button
              onClick={onClose}
              className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"
            >
              關閉
            </button>
            
            {preview.length > 0 && validationErrors.length === 0 && (
              <button
                onClick={uploadToDatabase}
                disabled={uploading}
                className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
              >
                {uploading ? '上傳中...' : `上傳 ${preview.length > 10 ? '全部' : preview.length} 題到資料庫`}
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

export default ExcelImport