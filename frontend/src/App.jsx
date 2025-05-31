/**
 * 主應用組件
 * 檔案名稱: App.jsx
 * 醫檢師考試系統前端主應用
 */

import React, { useState, useEffect, useCallback } from 'react';
import apiService from './ApiService';
import ExcelImport from './ExcelImport';

const App = () => {
    // 狀態管理
    const [currentUser, setCurrentUser] = useState(null);
    const [categories, setCategories] = useState([]);
    const [currentView, setCurrentView] = useState('home'); // home, exam, history, import
    const [selectedCategory, setSelectedCategory] = useState(null);
    const [questions, setQuestions] = useState([]);
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [answers, setAnswers] = useState({});
    const [examHistory, setExamHistory] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [examStartTime, setExamStartTime] = useState(null);
    const [examCompleted, setExamCompleted] = useState(false);
    const [examResult, setExamResult] = useState(null);

    // 初始化應用
    useEffect(() => {
        initializeApp();
    }, []);

    const initializeApp = async () => {
        try {
            setLoading(true);
            
            // 測試API連接
            const connectionTest = await apiService.testConnection();
            if (!connectionTest.success) {
                throw new Error('API連接失敗，請檢查網路連接或聯繫管理員');
            }

            // 載入科目列表
            await loadCategories();
            
            console.log('✅ 應用初始化完成');
        } catch (error) {
            console.error('❌ 應用初始化失敗:', error);
            setError('系統初始化失敗: ' + error.message);
        } finally {
            setLoading(false);
        }
    };

    // 載入科目列表
    const loadCategories = async () => {
        try {
            const result = await apiService.getCategories();
            if (result.success) {
                setCategories(result.data || []);
                console.log('✅ 科目載入成功:', result.data.length, '個科目');
            }
        } catch (error) {
            console.error('❌ 科目載入失敗:', error);
            throw error;
        }
    };

    // 登入功能
    const handleLogin = async (username = 'DEMO001', password = 'demo123') => {
        try {
            setLoading(true);
            setError('');

            const result = await apiService.login(username, password);
            if (result.success) {
                setCurrentUser(result.data.user);
                console.log('✅ 登入成功:', result.data.user);
                
                // 載入用戶歷史記錄
                await loadExamHistory(result.data.user.id);
            }
        } catch (error) {
            console.error('❌ 登入失敗:', error);
            setError('登入失敗: ' + error.message);
        } finally {
            setLoading(false);
        }
    };

    // 載入考試歷史
    const loadExamHistory = async (userId) => {
        try {
            const result = await apiService.getHistory(userId);
            if (result.success) {
                setExamHistory(result.data || []);
                console.log('✅ 歷史記錄載入成功:', result.data.length, '條記錄');
            }
        } catch (error) {
            console.error('❌ 歷史記錄載入失敗:', error);
        }
    };

    // 開始考試
    const startExam = async (categoryId) => {
        try {
            setLoading(true);
            setError('');
            
            if (!currentUser) {
                await handleLogin();
            }

            console.log('🎯 開始考試，科目ID:', categoryId);
            
            const result = await apiService.getQuestions(categoryId, 20);
            if (result.success && result.data.length > 0) {
                setSelectedCategory(categories.find(c => c.id === categoryId));
                setQuestions(result.data);
                setCurrentQuestionIndex(0);
                setAnswers({});
                setExamStartTime(new Date());
                setExamCompleted(false);
                setExamResult(null);
                setCurrentView('exam');
                
                console.log('✅ 考試開始，載入', result.data.length, '題');
            } else {
                throw new Error('無法載入題目，請稍後再試');
            }
        } catch (error) {
            console.error('❌ 開始考試失敗:', error);
            setError('開始考試失敗: ' + error.message);
        } finally {
            setLoading(false);
        }
    };

    // 回答題目
    const answerQuestion = (questionId, answer) => {
        setAnswers(prev => ({
            ...prev,
            [questionId]: answer
        }));
        
        console.log(`答題: 題目${questionId} = ${answer}`);
    };

    // 下一題
    const nextQuestion = () => {
        if (currentQuestionIndex < questions.length - 1) {
            setCurrentQuestionIndex(prev => prev + 1);
        }
    };

    // 上一題
    const previousQuestion = () => {
        if (currentQuestionIndex > 0) {
            setCurrentQuestionIndex(prev => prev - 1);
        }
    };

    // 跳轉到指定題目
    const goToQuestion = (index) => {
        if (index >= 0 && index < questions.length) {
            setCurrentQuestionIndex(index);
        }
    };

    // 提交考試
    const submitExam = async () => {
        try {
            setLoading(true);
            
            // 計算分數
            let correctCount = 0;
            questions.forEach(question => {
                const userAnswer = answers[question.id];
                if (userAnswer === question.correct_answer) {
                    correctCount++;
                }
            });
            
            const score = Math.round((correctCount / questions.length) * 100);
            const examTime = new Date() - examStartTime;
            
            console.log('📤 提交考試:', {
                totalQuestions: questions.length,
                answeredQuestions: Object.keys(answers).length,
                correctCount,
                score
            });

            // 提交到後端
            const result = await apiService.submitExam(
                currentUser.id,
                selectedCategory.id,
                answers,
                score,
                questions.length
            );

            if (result.success) {
                setExamResult({
                    score,
                    correctCount,
                    totalQuestions: questions.length,
                    examTime: Math.round(examTime / 1000 / 60), // 分鐘
                    examId: result.data.exam_id
                });
                setExamCompleted(true);
                
                // 重新載入歷史記錄
                await loadExamHistory(currentUser.id);
                
                console.log('✅ 考試提交成功');
            }
        } catch (error) {
            console.error('❌ 考試提交失敗:', error);
            setError('考試提交失敗: ' + error.message);
        } finally {
            setLoading(false);
        }
    };

    // 返回首頁
    const goHome = () => {
        setCurrentView('home');
        setSelectedCategory(null);
        setQuestions([]);
        setAnswers({});
        setExamCompleted(false);
        setExamResult(null);
        setError('');
    };

    // Excel匯入完成回調
    const handleImportComplete = async (importData) => {
        console.log('📥 匯入完成:', importData);
        
        // 重新載入科目列表（可能有新科目）
        await loadCategories();
        
        // 顯示成功消息
        alert(`🎉 匯入完成！\n成功: ${importData.success} 題\n失敗: ${importData.error} 題`);
        
        // 返回首頁
        setCurrentView('home');
    };

    // 渲染登入界面
    const renderLogin = () => (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
            <div className="bg-white rounded-lg shadow-xl p-8 w-full max-w-md">
                <div className="text-center mb-8">
                    <h1 className="text-3xl font-bold text-gray-800 mb-2">🏥 醫檢師考試系統</h1>
                    <p className="text-gray-600">國家考試線上練習平台</p>
                </div>
                
                <div className="space-y-4">
                    <button
                        onClick={() => handleLogin()}
                        disabled={loading}
                        className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 disabled:opacity-50 font-medium transition-colors"
                    >
                        {loading ? '登入中...' : '🚀 開始練習 (展示模式)'}
                    </button>
                    
                    {error && (
                        <div className="p-3 bg-red-50 border border-red-200 rounded text-red-700 text-sm">
                            {error}
                        </div>
                    )}
                </div>
                
                <div className="mt-6 text-center text-sm text-gray-500">
                    <p>展示帳號：DEMO001</p>
                    <p>密碼：demo123</p>
                </div>
            </div>
        </div>
    );

    // 渲染主頁
    const renderHome = () => (
        <div className="min-h-screen bg-gray-50">
            {/* 導航欄 */}
            <nav className="bg-white shadow-sm border-b">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center h-16">
                        <div className="flex items-center">
                            <h1 className="text-xl font-bold text-gray-800">🏥 醫檢師考試系統</h1>
                        </div>
                        <div className="flex items-center space-x-4">
                            <span className="text-gray-600">歡迎，{currentUser?.name}</span>
                            <button
                                onClick={() => setCurrentView('history')}
                                className="px-4 py-2 text-blue-600 hover:bg-blue-50 rounded"
                            >
                                📊 考試記錄
                            </button>
                            <button
                                onClick={() => setCurrentView('import')}
                                className="px-4 py-2 text-green-600 hover:bg-green-50 rounded"
                            >
                                📥 匯入題目
                            </button>
                            <button
                                onClick={() => {
                                    setCurrentUser(null);
                                    setExamHistory([]);
                                }}
                                className="px-4 py-2 text-gray-600 hover:bg-gray-50 rounded"
                            >
                                🚪 登出
                            </button>
                        </div>
                    </div>
                </div>
            </nav>

            {/* 主要內容 */}
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <div className="text-center mb-12">
                    <h2 className="text-3xl font-bold text-gray-800 mb-4">選擇考試科目</h2>
                    <p className="text-gray-600">選擇你要練習的醫檢師考試科目</p>
                </div>

                {/* 科目卡片 */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {categories.map(category => (
                        <div
                            key={category.id}
                            className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6 cursor-pointer"
                            onClick={() => startExam(category.id)}
                        >
                            <div className="text-center">
                                <div className="text-4xl mb-4">📚</div>
                                <h3 className="text-lg font-bold text-gray-800 mb-2">
                                    {category.name}
                                </h3>
                                <p className="text-gray-600 text-sm mb-4">
                                    {category.description}
                                </p>
                                <button className="w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition-colors">
                                    開始考試
                                </button>
                            </div>
                        </div>
                    ))}
                </div>

                {categories.length === 0 && !loading && (
                    <div className="text-center py-12">
                        <div className="text-6xl mb-4">📚</div>
                        <h3 className="text-xl font-bold text-gray-600 mb-2">暫無考試科目</h3>
                        <p className="text-gray-500">請聯繫管理員添加考試科目</p>
                    </div>
                )}
            </div>
        </div>
    );

    // 渲染考試界面
    const renderExam = () => {
        if (examCompleted && examResult) {
            return renderExamResult();
        }

        if (questions.length === 0) {
            return <div className="min-h-screen flex items-center justify-center">載入題目中...</div>;
        }

        const currentQuestion = questions[currentQuestionIndex];
        const userAnswer = answers[currentQuestion.id];
        const answeredCount = Object.keys(answers).length;

        return (
            <div className="min-h-screen bg-gray-50">
                {/* 考試頭部 */}
                <div className="bg-white shadow-sm border-b">
                    <div className="max-w-4xl mx-auto px-4 py-4">
                        <div className="flex justify-between items-center">
                            <div>
                                <h2 className="text-xl font-bold text-gray-800">
                                    {selectedCategory?.name}
                                </h2>
                                <p className="text-gray-600">
                                    第 {currentQuestionIndex + 1} 題 / 共 {questions.length} 題
                                </p>
                            </div>
                            <div className="text-right">
                                <div className="text-sm text-gray-600">
                                    已答題：{answeredCount} / {questions.length}
                                </div>
                                <div className="flex space-x-2 mt-2">
                                    <button
                                        onClick={goHome}
                                        className="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600"
                                    >
                                        返回首頁
                                    </button>
                                    <button
                                        onClick={() => {
                                            if (confirm('確定要提交考試嗎？未答題目將計為錯誤。')) {
                                                submitExam();
                                            }
                                        }}
                                        disabled={loading}
                                        className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 disabled:opacity-50"
                                    >
                                        {loading ? '提交中...' : '提交考試'}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="max-w-4xl mx-auto px-4 py-8">
                    <div className="bg-white rounded-lg shadow-md p-8">
                        {/* 題目內容 */}
                        <div className="mb-8">
                            <div className="text-lg font-medium text-gray-800 mb-6 leading-relaxed">
                                {currentQuestion.question}
                            </div>

                            {/* 選項 */}
                            <div className="space-y-4">
                                {['A', 'B', 'C', 'D'].map(option => (
                                    <label
                                        key={option}
                                        className={`block p-4 border-2 rounded-lg cursor-pointer transition-colors ${
                                            userAnswer === option
                                                ? 'border-blue-500 bg-blue-50'
                                                : 'border-gray-200 hover:border-gray-300'
                                        }`}
                                    >
                                        <div className="flex items-start">
                                            <input
                                                type="radio"
                                                name={`question-${currentQuestion.id}`}
                                                value={option}
                                                checked={userAnswer === option}
                                                onChange={() => answerQuestion(currentQuestion.id, option)}
                                                className="mt-1 mr-3"
                                            />
                                            <div>
                                                <span className="font-medium text-blue-600 mr-2">
                                                    {option}.
                                                </span>
                                                <span className="text-gray-800">
                                                    {currentQuestion[`option_${option.toLowerCase()}`]}
                                                </span>
                                            </div>
                                        </div>
                                    </label>
                                ))}
                            </div>
                        </div>

                        {/* 導航按鈕 */}
                        <div className="flex justify-between items-center">
                            <button
                                onClick={previousQuestion}
                                disabled={currentQuestionIndex === 0}
                                className="px-6 py-3 bg-gray-600 text-white rounded hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                                ← 上一題
                            </button>

                            <div className="text-center">
                                <div className="text-sm text-gray-600 mb-2">快速導航</div>
                                <div className="flex space-x-1">
                                    {questions.slice(0, 10).map((_, index) => (
                                        <button
                                            key={index}
                                            onClick={() => goToQuestion(index)}
                                            className={`w-8 h-8 text-xs rounded ${
                                                index === currentQuestionIndex
                                                    ? 'bg-blue-600 text-white'
                                                    : answers[questions[index].id]
                                                    ? 'bg-green-100 text-green-800'
                                                    : 'bg-gray-100 text-gray-600'
                                            } hover:bg-blue-100`}
                                        >
                                            {index + 1}
                                        </button>
                                    ))}
                                    {questions.length > 10 && (
                                        <span className="text-gray-500">...</span>
                                    )}
                                </div>
                            </div>

                            <button
                                onClick={nextQuestion}
                                disabled={currentQuestionIndex === questions.length - 1}
                                className="px-6 py-3 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                                下一題 →
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        );
    };

    // 渲染考試結果
    const renderExamResult = () => (
        <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-lg shadow-xl p-8 max-w-2xl w-full">
                <div className="text-center">
                    <div className="text-6xl mb-6">
                        {examResult.score >= 80 ? '🎉' : examResult.score >= 60 ? '👍' : '📚'}
                    </div>
                    <h2 className="text-3xl font-bold text-gray-800 mb-4">考試完成！</h2>
                    
                    <div className="grid grid-cols-2 gap-6 my-8">
                        <div className="bg-blue-50 p-4 rounded-lg">
                            <div className="text-3xl font-bold text-blue-600">{examResult.score}</div>
                            <div className="text-sm text-gray-600">分數</div>
                        </div>
                        <div className="bg-green-50 p-4 rounded-lg">
                            <div className="text-3xl font-bold text-green-600">
                                {examResult.correctCount}/{examResult.totalQuestions}
                            </div>
                            <div className="text-sm text-gray-600">正確題數</div>
                        </div>
                    </div>

                    <div className="mb-8">
                        <div className="text-gray-600">
                            考試科目：{selectedCategory?.name}
                        </div>
                        <div className="text-gray-600">
                            考試時間：{examResult.examTime} 分鐘
                        </div>
                    </div>

                    <div className="space-y-4">
                        <button
                            onClick={() => startExam(selectedCategory.id)}
                            className="w-full bg-blue-600 text-white py-3 px-6 rounded-lg hover:bg-blue-700"
                        >
                            🔄 重新考試
                        </button>
                        <button
                            onClick={goHome}
                            className="w-full bg-gray-600 text-white py-3 px-6 rounded-lg hover:bg-gray-700"
                        >
                            🏠 返回首頁
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );

    // 渲染歷史記錄
    const renderHistory = () => (
        <div className="min-h-screen bg-gray-50">
            <div className="max-w-6xl mx-auto px-4 py-8">
                <div className="flex justify-between items-center mb-8">
                    <h2 className="text-3xl font-bold text-gray-800">📊 考試歷史記錄</h2>
                    <button
                        onClick={goHome}
                        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                    >
                        返回首頁
                    </button>
                </div>

                {examHistory.length > 0 ? (
                    <div className="bg-white rounded-lg shadow-md overflow-hidden">
                        <table className="min-w-full">
                            <thead className="bg-gray-50">
                                <tr>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">日期</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">科目</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">分數</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">題數</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-gray-200">
                                {examHistory.map(record => (
                                    <tr key={record.id} className="hover:bg-gray-50">
                                        <td className="px-6 py-4 whitespace-nowrap text-gray-800">
                                            {new Date(record.exam_date).toLocaleString()}
                                        </td>
                                        <td className="px-6 py-4 text-gray-800">
                                            {record.category_name}
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap">
                                            <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                                                record.score >= 80 ? 'bg-green-100 text-green-800' :
                                                record.score >= 60 ? 'bg-yellow-100 text-yellow-800' :
                                                'bg-red-100 text-red-800'
                                            }`}>
                                                {record.score} 分
                                            </span>
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-gray-800">
                                            {record.total_questions || 20} 題
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                ) : (
                    <div className="text-center py-12">
                        <div className="text-6xl mb-4">📊</div>
                        <h3 className="text-xl font-bold text-gray-600 mb-2">暫無考試記錄</h3>
                        <p className="text-gray-500">開始你的第一次考試吧！</p>
                    </div>
                )}
            </div>
        </div>
    );

    // 渲染匯入界面
    const renderImport = () => (
        <div className="min-h-screen bg-gray-50">
            <div className="max-w-6xl mx-auto px-4 py-8">
                <ExcelImport
                    onImportComplete={handleImportComplete}
                    onClose={() => setCurrentView('home')}
                />
            </div>
        </div>
    );

    // 載入中界面
    if (loading && !currentUser) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="text-6xl mb-4">🔄</div>
                    <div className="text-xl font-medium text-gray-700">系統載入中...</div>
                    <div className="text-gray-500 mt-2">正在初始化考試系統</div>
                </div>
            </div>
        );
    }

    // 主要渲染邏輯
    if (!currentUser) {
        return renderLogin();
    }

    switch (currentView) {
        case 'exam':
            return renderExam();
        case 'history':
            return renderHistory();
        case 'import':
            return renderImport();
        default:
            return renderHome();
    }
};

export default App;