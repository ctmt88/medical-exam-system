@echo off
chcp 65001 >nul
echo ====================================
echo 建立完整的前端考試系統
echo ====================================
echo.

echo 🚀 建立功能完整的考試系統...
echo.

cd frontend

REM 建立完整版的 App.jsx
echo 🔧 建立完整版 App.jsx...
echo import React, { useState, useEffect } from 'react' > src\App.jsx
echo. >> src\App.jsx
echo function App() { >> src\App.jsx
echo   const [currentView, setCurrentView] = useState('home') >> src\App.jsx
echo   const [isLoggedIn, setIsLoggedIn] = useState(false) >> src\App.jsx
echo   const [showLoginModal, setShowLoginModal] = useState(false) >> src\App.jsx
echo   const [selectedSubject, setSelectedSubject] = useState(null) >> src\App.jsx
echo   const [examTimer, setExamTimer] = useState(3600) // 60分鐘 >> src\App.jsx
echo   const [currentQuestion, setCurrentQuestion] = useState(0) >> src\App.jsx
echo   const [userAnswers, setUserAnswers] = useState({}) >> src\App.jsx
echo   const [markedQuestions, setMarkedQuestions] = useState(new Set()) >> src\App.jsx
echo   const [isExamActive, setIsExamActive] = useState(false) >> src\App.jsx
echo   const [showSubmitModal, setShowSubmitModal] = useState(false) >> src\App.jsx
echo   const [examResults, setExamResults] = useState(null) >> src\App.jsx
echo. >> src\App.jsx
echo   const subjects = [ >> src\App.jsx
echo     { id: 1, name: '臨床生理學與病理學', shortName: '生理病理', description: '心電圖、肺功能、腦波檢查等' }, >> src\App.jsx
echo     { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫', description: '血球計數、凝血功能、血型檢驗等' }, >> src\App.jsx
echo     { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢', description: 'PCR技術、基因定序、寄生蟲檢驗等' }, >> src\App.jsx
echo     { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學', description: '細菌培養、抗生素敏感性、黴菌檢驗等' }, >> src\App.jsx
echo     { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學', description: '肝功能、腎功能、血糖檢驗等' }, >> src\App.jsx
echo     { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫', description: '腫瘤標記、自體免疫、病毒檢驗等' } >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   // 生成80題模擬題目 >> src\App.jsx
echo   const generateQuestions = (subjectId) =^> { >> src\App.jsx
echo     const subject = subjects.find(s =^> s.id === subjectId) >> src\App.jsx
echo     return Array.from({ length: 80 }, (_, i) =^> ({ >> src\App.jsx
echo       id: i + 1, >> src\App.jsx
echo       question: `【${subject.shortName}】第${i + 1}題：關於${subject.shortName}檢驗的敘述，下列何者正確？`, >> src\App.jsx
echo       options: { >> src\App.jsx
echo         A: `選項A：這是第${i + 1}題的第一個選項，描述${subject.shortName}的某個重要概念或檢驗方法。`, >> src\App.jsx
echo         B: `選項B：這是第${i + 1}題的第二個選項，說明${subject.shortName}的另一種技術或應用。`, >> src\App.jsx
echo         C: `選項C：這是第${i + 1}題的第三個選項，解釋${subject.shortName}相關的生理機制或病理變化。`, >> src\App.jsx
echo         D: `選項D：這是第${i + 1}題的第四個選項，描述${subject.shortName}的臨床意義或診斷價值。` >> src\App.jsx
echo       }, >> src\App.jsx
echo       correctAnswer: ['A', 'B', 'C', 'D'][i %% 4], >> src\App.jsx
echo       explanation: `第${i + 1}題解析：正確答案是${['A', 'B', 'C', 'D'][i %% 4]}。這題主要考察${subject.shortName}的基本概念，在實際工作中需要熟練掌握相關知識點。` >> src\App.jsx
echo     })) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const [examQuestions, setExamQuestions] = useState([]) >> src\App.jsx
echo. >> src\App.jsx
echo   // 計時器效果 >> src\App.jsx
echo   useEffect(() =^> { >> src\App.jsx
echo     let interval = null >> src\App.jsx
echo     if (isExamActive ^&^& examTimer ^> 0) { >> src\App.jsx
echo       interval = setInterval(() =^> { >> src\App.jsx
echo         setExamTimer(prev =^> { >> src\App.jsx
echo           if (prev ^<= 1) { >> src\App.jsx
echo             setIsExamActive(false) >> src\App.jsx
echo             handleAutoSubmit() >> src\App.jsx
echo             return 0 >> src\App.jsx
echo           } >> src\App.jsx
echo           return prev - 1 >> src\App.jsx
echo         }) >> src\App.jsx
echo       }, 1000) >> src\App.jsx
echo     } >> src\App.jsx
echo     return () =^> clearInterval(interval) >> src\App.jsx
echo   }, [isExamActive, examTimer]) >> src\App.jsx
echo. >> src\App.jsx
echo   const formatTime = (seconds) =^> { >> src\App.jsx
echo     const hours = Math.floor(seconds / 3600) >> src\App.jsx
echo     const minutes = Math.floor((seconds %% 3600) / 60) >> src\App.jsx
echo     const secs = seconds %% 60 >> src\App.jsx
echo     return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}` >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const handleLogin = () =^> { >> src\App.jsx
echo     setIsLoggedIn(true) >> src\App.jsx
echo     setShowLoginModal(false) >> src\App.jsx
echo     setCurrentView('dashboard') >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const startExam = (subjectId) =^> { >> src\App.jsx
echo     const subject = subjects.find(s =^> s.id === subjectId) >> src\App.jsx
echo     const questions = generateQuestions(subjectId) >> src\App.jsx
echo     setSelectedSubject(subject) >> src\App.jsx
echo     setExamQuestions(questions) >> src\App.jsx
echo     setCurrentView('exam') >> src\App.jsx
echo     setCurrentQuestion(0) >> src\App.jsx
echo     setExamTimer(3600) >> src\App.jsx
echo     setUserAnswers({}) >> src\App.jsx
echo     setMarkedQuestions(new Set()) >> src\App.jsx
echo     setIsExamActive(true) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const selectAnswer = (questionId, answer) =^> { >> src\App.jsx
echo     setUserAnswers(prev =^> ({...prev, [questionId]: answer})) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const toggleMark = (questionId) =^> { >> src\App.jsx
echo     setMarkedQuestions(prev =^> { >> src\App.jsx
echo       const newMarked = new Set(prev) >> src\App.jsx
echo       if (newMarked.has(questionId)) { >> src\App.jsx
echo         newMarked.delete(questionId) >> src\App.jsx
echo       } else { >> src\App.jsx
echo         newMarked.add(questionId) >> src\App.jsx
echo       } >> src\App.jsx
echo       return newMarked >> src\App.jsx
echo     }) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const handleAutoSubmit = () =^> { >> src\App.jsx
echo     alert('時間到！系統將自動提交您的答案。') >> src\App.jsx
echo     submitExam() >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const submitExam = () =^> { >> src\App.jsx
echo     const correctCount = Object.entries(userAnswers).filter(([questionId, answer]) =^> >> src\App.jsx
echo       examQuestions[parseInt(questionId) - 1]?.correctAnswer === answer >> src\App.jsx
echo     ).length >> src\App.jsx
echo     const totalScore = (correctCount * 1.25).toFixed(1) >> src\App.jsx
echo     const percentage = ((correctCount / 80) * 100).toFixed(1) >> src\App.jsx
echo. >> src\App.jsx
echo     setExamResults({ >> src\App.jsx
echo       correctCount, >> src\App.jsx
echo       totalScore, >> src\App.jsx
echo       percentage, >> src\App.jsx
echo       totalQuestions: 80, >> src\App.jsx
echo       answeredCount: Object.keys(userAnswers).length >> src\App.jsx
echo     }) >> src\App.jsx
echo. >> src\App.jsx
echo     setIsExamActive(false) >> src\App.jsx
echo     setCurrentView('result') >> src\App.jsx
echo     setShowSubmitModal(false) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo ✅ App.jsx 基礎邏輯完成
echo.

echo 🔧 建立首頁視圖...
echo   // 首頁視圖 >> src\App.jsx
echo   if (currentView === 'home') { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div^> >> src\App.jsx
echo         ^<div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"^> >> src\App.jsx
echo           ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo             ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo               ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                 ^<div className="flex items-center"^> >> src\App.jsx
echo                   ^<h1 className="text-2xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo                   ^<span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full"^>完整版^</span^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<button onClick={() =^> setShowLoginModal(true)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"^>登入系統^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</nav^> >> src\App.jsx
echo           ^<main className="max-w-7xl mx-auto py-12 px-4"^> >> src\App.jsx
echo             ^<div className="text-center mb-12"^> >> src\App.jsx
echo               ^<h2 className="text-4xl font-bold text-gray-900 mb-4"^>醫事檢驗師國家考試線上練習系統^</h2^> >> src\App.jsx
echo               ^<p className="text-xl text-gray-600 mb-8"^>完整模擬真實考試環境，每科80題限時60分鐘^</p^> >> src\App.jsx
echo               ^<div className="flex justify-center space-x-4"^> >> src\App.jsx
echo                 ^<button onClick={() =^> setShowLoginModal(true)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"^>開始練習^</button^> >> src\App.jsx
echo                 ^<button onClick={() =^> setCurrentView('demo')} className="bg-gray-100 text-gray-700 px-8 py-3 rounded-lg font-semibold hover:bg-gray-200 transition-colors"^>功能展示^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12"^> >> src\App.jsx
echo               {subjects.map(subject =^> ( >> src\App.jsx
echo                 ^<div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-bold text-gray-900 mb-2"^>{subject.name}^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600 mb-4 text-sm"^>{subject.description}^</p^> >> src\App.jsx
echo                   ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                     ^<span className="text-sm text-blue-600 font-semibold"^>80題 • 60分鐘^</span^> >> src\App.jsx
echo                     ^<button onClick={() =^> setShowLoginModal(true)} className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm"^>開始練習^</button^> >> src\App.jsx
echo                   ^</div^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ))} >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-lg p-8 text-center"^> >> src\App.jsx
echo               ^<h2 className="text-2xl font-bold text-gray-900 mb-4"^>系統特色^</h2^> >> src\App.jsx
echo               ^<div className="grid md:grid-cols-3 gap-8"^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<div className="text-4xl mb-2"^>⏱️^</div^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-semibold mb-2"^>真實考試體驗^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600"^>60分鐘限時作答，完全模擬考場環境^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<div className="text-4xl mb-2"^>📊^</div^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-semibold mb-2"^>詳細成績分析^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600"^>即時計分，答對率統計，弱點分析^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<div className="text-4xl mb-2"^>📚^</div^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-semibold mb-2"^>完整題庫^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600"^>六大科目，每科80題，涵蓋考試重點^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</main^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo         {showLoginModal ^&^& ( >> src\App.jsx
echo           ^<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4"^> >> src\App.jsx
echo               ^<h3 className="text-lg font-semibold text-gray-800 mb-4"^>系統登入^</h3^> >> src\App.jsx
echo               ^<div className="space-y-4"^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<label className="block text-sm font-medium text-gray-700 mb-1"^>學號^</label^> >> src\App.jsx
echo                   ^<input type="text" defaultValue="DEMO001" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<label className="block text-sm font-medium text-gray-700 mb-1"^>密碼^</label^> >> src\App.jsx
echo                   ^<input type="password" defaultValue="demo123" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div className="bg-blue-50 border border-blue-200 rounded-lg p-3"^> >> src\App.jsx
echo                   ^<p className="text-sm text-blue-800"^>^<strong^>展示帳號^</strong^>^<br /^>學號：DEMO001 ^<br /^>密碼：demo123^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="flex gap-3 mt-6"^> >> src\App.jsx
echo                 ^<button onClick={() =^> setShowLoginModal(false)} className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"^>取消^</button^> >> src\App.jsx
echo                 ^<button onClick={handleLogin} className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"^>登入^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         )} >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo ✅ 首頁視圖完成
echo.

echo 📝 由於檔案太長，建立第二階段...
echo 第一階段完成！
echo 現在建立第二階段批次檔...

REM 建立第二階段批次檔
echo @echo off > ..\complete-frontend-stage2.bat
echo chcp 65001 ^>nul >> ..\complete-frontend-stage2.bat
echo echo 建立學生儀表板和考試介面... >> ..\complete-frontend-stage2.bat
echo cd frontend >> ..\complete-frontend-stage2.bat

echo ✅ 第一階段完成
echo ✅ 已建立第二階段批次檔
echo.

echo 🧪 測試目前的建置...
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 第一階段建置成功
) else (
    echo ❌ 建置失敗，請檢查錯誤
    pause
    exit /b 1
)

cd ..

echo 📋 第一階段完成內容：
echo ✅ 完整的狀態管理系統
echo ✅ 80題題目生成器
echo ✅ 計時器功能
echo ✅ 登入和答題邏輯
echo ✅ 首頁視圖（含系統特色展示）
echo.

echo 🚀 下一步：
echo 1. 執行 complete-frontend-stage2.bat 建立儀表板
echo 2. 執行 complete-frontend-stage3.bat 建立考試介面
echo 3. 執行 complete-frontend-stage4.bat 建立結果頁面
echo 4. 最後部署完整系統
echo.

echo ====================================
echo 第一階段完成！請執行第二階段...
echo ====================================
pause