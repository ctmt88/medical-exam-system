@echo off
chcp 65001 >nul
echo ====================================
echo 前端互動功能增強 - 第一階段
echo ====================================
echo.

REM 確保在專案根目錄
if not exist "frontend\src" (
    echo ❌ 錯誤：請在專案根目錄執行此批次檔
    pause
    exit /b 1
)

echo ✅ 開始增強前端互動功能...
echo.

REM 建立增強版的 App.jsx - 加入登入和考試模擬功能
echo 🔧 建立增強版 App.jsx...
echo import React, { useState, useEffect } from 'react' > frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo function App() { >> frontend\src\App.jsx
echo   const [currentView, setCurrentView] = useState('home'^) >> frontend\src\App.jsx
echo   const [isLoggedIn, setIsLoggedIn] = useState(false^) >> frontend\src\App.jsx
echo   const [showLoginModal, setShowLoginModal] = useState(false^) >> frontend\src\App.jsx
echo   const [selectedSubject, setSelectedSubject] = useState(null^) >> frontend\src\App.jsx
echo   const [examTimer, setExamTimer] = useState(3600^) // 60分鐘 >> frontend\src\App.jsx
echo   const [currentQuestion, setCurrentQuestion] = useState(0^) >> frontend\src\App.jsx
echo   const [userAnswers, setUserAnswers] = useState({}^) >> frontend\src\App.jsx
echo   const [isExamActive, setIsExamActive] = useState(false^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 六大科目資料 >> frontend\src\App.jsx
echo   const subjects = [ >> frontend\src\App.jsx
echo     { id: 1, name: '臨床生理學與病理學', shortName: '生理病理', questions: 80 }, >> frontend\src\App.jsx
echo     { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫', questions: 80 }, >> frontend\src\App.jsx
echo     { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢', questions: 80 }, >> frontend\src\App.jsx
echo     { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學', questions: 80 }, >> frontend\src\App.jsx
echo     { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學', questions: 80 }, >> frontend\src\App.jsx
echo     { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫', questions: 80 } >> frontend\src\App.jsx
echo   ] >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 模擬考試題目 >> frontend\src\App.jsx
echo   const mockQuestions = Array.from({ length: 80 }, (_, i^) =^> ({ >> frontend\src\App.jsx
echo     id: i + 1, >> frontend\src\App.jsx
echo     question: `第${i + 1}題：關於醫事檢驗的描述，下列何者正確？（這是模擬題目）`, >> frontend\src\App.jsx
echo     options: { >> frontend\src\App.jsx
echo       A: `選項A：這是第${i + 1}題的選項A，描述某個檢驗方法的特點。`, >> frontend\src\App.jsx
echo       B: `選項B：這是第${i + 1}題的選項B，說明另一種檢驗技術。`, >> frontend\src\App.jsx
echo       C: `選項C：這是第${i + 1}題的選項C，解釋相關的生理機制。`, >> frontend\src\App.jsx
echo       D: `選項D：這是第${i + 1}題的選項D，描述臨床應用情況。` >> frontend\src\App.jsx
echo     }, >> frontend\src\App.jsx
echo     correctAnswer: ['A', 'B', 'C', 'D'][i %% 4] >> frontend\src\App.jsx
echo   }^^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 計時器效果 >> frontend\src\App.jsx
echo   useEffect(^(^) =^> { >> frontend\src\App.jsx
echo     let interval = null >> frontend\src\App.jsx
echo     if (isExamActive && examTimer ^> 0^) { >> frontend\src\App.jsx
echo       interval = setInterval(^(^) =^> { >> frontend\src\App.jsx
echo         setExamTimer(timer =^> timer - 1^) >> frontend\src\App.jsx
echo       }, 1000^) >> frontend\src\App.jsx
echo     } else if (examTimer === 0^) { >> frontend\src\App.jsx
echo       setIsExamActive(false^) >> frontend\src\App.jsx
echo       alert('時間到！考試結束'^^) >> frontend\src\App.jsx
echo       setCurrentView('result'^) >> frontend\src\App.jsx
echo     } >> frontend\src\App.jsx
echo     return ^(^) =^> clearInterval(interval^) >> frontend\src\App.jsx
echo   }, [isExamActive, examTimer]^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 格式化時間顯示 >> frontend\src\App.jsx
echo   const formatTime = (seconds^) =^> { >> frontend\src\App.jsx
echo     const hours = Math.floor(seconds / 3600^) >> frontend\src\App.jsx
echo     const minutes = Math.floor((seconds %% 3600^) / 60^) >> frontend\src\App.jsx
echo     const secs = seconds %% 60 >> frontend\src\App.jsx
echo     return `${hours.toString(^).padStart(2, '0'^)}:${minutes.toString(^).padStart(2, '0'^)}:${secs.toString(^).padStart(2, '0'^)}` >> frontend\src\App.jsx
echo   } >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 處理登入 >> frontend\src\App.jsx
echo   const handleLogin = ^(^) =^> { >> frontend\src\App.jsx
echo     setIsLoggedIn(true^) >> frontend\src\App.jsx
echo     setShowLoginModal(false^) >> frontend\src\App.jsx
echo     setCurrentView('dashboard'^) >> frontend\src\App.jsx
echo   } >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 開始考試 >> frontend\src\App.jsx
echo   const startExam = (subjectId^) =^> { >> frontend\src\App.jsx
echo     const subject = subjects.find(s =^> s.id === subjectId^) >> frontend\src\App.jsx
echo     setSelectedSubject(subject^) >> frontend\src\App.jsx
echo     setCurrentView('exam'^) >> frontend\src\App.jsx
echo     setCurrentQuestion(0^) >> frontend\src\App.jsx
echo     setExamTimer(3600^) >> frontend\src\App.jsx
echo     setUserAnswers({}^) >> frontend\src\App.jsx
echo     setIsExamActive(true^) >> frontend\src\App.jsx
echo   } >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo   // 選擇答案 >> frontend\src\App.jsx
echo   const selectAnswer = (questionId, answer^) =^> { >> frontend\src\App.jsx
echo     setUserAnswers(prev =^> ({...prev, [questionId]: answer}^^)^) >> frontend\src\App.jsx
echo   } >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx

echo ✅ App.jsx 基礎邏輯建立完成
echo.

echo 🔧 繼續建立 App.jsx 視圖組件...
echo   // 登入模態框 >> frontend\src\App.jsx
echo   const LoginModal = ^(^) =^> ( >> frontend\src\App.jsx
echo     ^<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"^> >> frontend\src\App.jsx
echo       ^<div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4"^> >> frontend\src\App.jsx
echo         ^<h3 className="text-lg font-semibold text-gray-800 mb-4"^>系統登入^</h3^> >> frontend\src\App.jsx
echo         ^<div className="space-y-4"^> >> frontend\src\App.jsx
echo           ^<div^> >> frontend\src\App.jsx
echo             ^<label className="block text-sm font-medium text-gray-700 mb-1"^>學號^</label^> >> frontend\src\App.jsx
echo             ^<input type="text" defaultValue="DEMO001" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo           ^<div^> >> frontend\src\App.jsx
echo             ^<label className="block text-sm font-medium text-gray-700 mb-1"^>密碼^</label^> >> frontend\src\App.jsx
echo             ^<input type="password" defaultValue="demo123" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo           ^<div className="bg-blue-50 border border-blue-200 rounded-lg p-3"^> >> frontend\src\App.jsx
echo             ^<p className="text-sm text-blue-800"^>展示帳號：學號 DEMO001，密碼 demo123^</p^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo         ^<div className="flex gap-3 mt-6"^> >> frontend\src\App.jsx
echo           ^<button onClick={^(^) =^> setShowLoginModal(false^)} className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200"^>取消^</button^> >> frontend\src\App.jsx
echo           ^<button onClick={handleLogin} className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700"^>登入^</button^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo       ^</div^> >> frontend\src\App.jsx
echo     ^</div^> >> frontend\src\App.jsx
echo   ^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx

echo 🔧 建立首頁視圖...
echo   // 首頁視圖 >> frontend\src\App.jsx
echo   const HomePage = ^(^) =^> ( >> frontend\src\App.jsx
echo     ^<div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"^> >> frontend\src\App.jsx
echo       ^<nav className="bg-white shadow-sm"^> >> frontend\src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> frontend\src\App.jsx
echo           ^<div className="flex justify-between items-center"^> >> frontend\src\App.jsx
echo             ^<div className="flex items-center"^> >> frontend\src\App.jsx
echo               ^<h1 className="text-2xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> frontend\src\App.jsx
echo               ^<span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full"^>互動展示版^</span^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo             ^<button onClick={^(^) =^> setShowLoginModal(true^)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"^>登入^</button^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo       ^</nav^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo       ^<main className="max-w-7xl mx-auto py-12 px-4"^> >> frontend\src\App.jsx
echo         ^<div className="text-center mb-12"^> >> frontend\src\App.jsx
echo           ^<h2 className="text-4xl font-bold text-gray-900 mb-4"^>醫事檢驗師國家考試線上練習系統^</h2^> >> frontend\src\App.jsx
echo           ^<p className="text-xl text-gray-600 mb-8"^>提供完整的六大科目練習，幫助您順利通過醫檢師考試^</p^> >> frontend\src\App.jsx
echo           ^<button onClick={^(^) =^> setShowLoginModal(true^)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"^>開始練習^</button^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo         ^<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8"^> >> frontend\src\App.jsx
echo           {subjects.map(subject =^> ( >> frontend\src\App.jsx
echo             ^<div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"^> >> frontend\src\App.jsx
echo               ^<h3 className="text-lg font-bold text-gray-900 mb-2"^>{subject.name}^</h3^> >> frontend\src\App.jsx
echo               ^<p className="text-gray-600 mb-4 text-sm"^>{subject.shortName}^</p^> >> frontend\src\App.jsx
echo               ^<div className="flex justify-between items-center"^> >> frontend\src\App.jsx
echo                 ^<span className="text-sm text-blue-600 font-semibold"^>{subject.questions}題 • 60分鐘^</span^> >> frontend\src\App.jsx
echo                 ^<button onClick={^(^) =^> setShowLoginModal(true^)} className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm"^>開始練習^</button^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo           ^)^)} >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo       ^</main^> >> frontend\src\App.jsx
echo     ^</div^> >> frontend\src\App.jsx
echo   ^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx

echo ✅ App.jsx 首頁視圖建立完成
echo.

REM 由於批次檔有長度限制，這裡先暫停並建立第二個檔案
echo 📝 建立第二階段檔案...
echo 第一階段完成！請執行第二階段批次檔來完成剩餘組件
echo.

REM 建立第二階段批次檔
echo @echo off > enhance-frontend-stage2.bat
echo chcp 65001 ^>nul >> enhance-frontend-stage2.bat
echo echo 建立學生儀表板和考試介面... >> enhance-frontend-stage2.bat
echo. >> enhance-frontend-stage2.bat

echo REM 繼續建立 App.jsx 的學生儀表板 >> enhance-frontend-stage2.bat
echo echo 🔧 建立學生儀表板視圖... >> enhance-frontend-stage2.bat
echo echo   // 學生儀表板視圖 ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo   const Dashboard = ^^^(^^^) =^^^> ^^( ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo     ^^^<div className="min-h-screen bg-gray-50"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo       ^^^<nav className="bg-white shadow-sm"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo         ^^^<div className="max-w-7xl mx-auto px-4 py-4"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<div className="flex justify-between items-center"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<h1 className="text-xl font-bold text-gray-900"^^^>醫檢師考試系統^^^</h1^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<div className="flex items-center space-x-4"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo               ^^^<span className="text-gray-700"^^^>歡迎，展示使用者^^^</span^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo               ^^^<button onClick={^^^(^^^) =^^^> { setIsLoggedIn(false^^^); setCurrentView('home'^^^) }} className="text-gray-500 hover:text-gray-700"^^^>登出^^^</button^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo         ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo       ^^^</nav^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo. ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo       ^^^<div className="max-w-7xl mx-auto py-8 px-4"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo         ^^^<div className="grid lg:grid-cols-4 gap-6 mb-8"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<div className="bg-white rounded-lg shadow p-6"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<h4 className="text-sm text-gray-600"^^^>最佳成績^^^</h4^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<p className="text-2xl font-bold text-yellow-600"^^^>95.0^^^</p^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<div className="bg-white rounded-lg shadow p-6"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<h4 className="text-sm text-gray-600"^^^>平均分數^^^</h4^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<p className="text-2xl font-bold text-blue-600"^^^>85.3^^^</p^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<div className="bg-white rounded-lg shadow p-6"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<h4 className="text-sm text-gray-600"^^^>考試次數^^^</h4^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<p className="text-2xl font-bold text-green-600"^^^>15^^^</p^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<div className="bg-white rounded-lg shadow p-6"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<h4 className="text-sm text-gray-600"^^^>學習狀態^^^</h4^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^<p className="text-2xl font-bold text-purple-600"^^^>活躍^^^</p^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo         ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo. ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo         ^^^<div className="bg-white rounded-lg shadow p-6"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<h2 className="text-lg font-semibold text-gray-900 mb-6"^^^>選擇考試科目^^^</h2^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^<div className="grid md:grid-cols-2 gap-4"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             {subjects.map(subject =^^^> ^^( ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo               ^^^<div key={subject.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo                 ^^^<h3 className="font-semibold text-gray-900 mb-2"^^^>{subject.name}^^^</h3^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo                 ^^^<p className="text-sm text-gray-600 mb-4"^^^>{subject.shortName}^^^</p^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo                 ^^^<div className="flex justify-between items-center"^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo                   ^^^<span className="text-xs text-gray-500"^^^>{subject.questions}題 • 60分鐘 • 100分^^^</span^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo                   ^^^<button onClick={^^^(^^^) =^^^> startExam(subject.id^^^)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm"^^^>開始考試^^^</button^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo                 ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo               ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo             ^^^)^^^)} ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo           ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo         ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo       ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo     ^^^</div^^^> ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat
echo echo   ^^^) ^>^> frontend\src\App.jsx >> enhance-frontend-stage2.bat

echo ✅ 第二階段批次檔建立完成
echo.

echo 🔧 建立測試和部署...
npm run build > nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ 本地建置測試成功
) else (
    echo ⚠️ 本地建置測試失敗，但這可能是正常的（檔案還沒建立完成）
)
echo.

echo 📋 第一階段完成摘要：
echo ✅ 建立了增強版 App.jsx 基礎結構
echo ✅ 加入了狀態管理和計時器功能
echo ✅ 建立了登入模態框
echo ✅ 建立了首頁視圖
echo ✅ 準備了第二階段批次檔
echo.

echo 🚀 下一步：
echo 1. 執行 enhance-frontend-stage2.bat 完成剩餘組件
echo 2. 然後執行 enhance-frontend-stage3.bat 建立考試介面
echo 3. 最後部署到 GitHub Pages
echo.

echo ====================================
echo 第一階段完成！請執行第二階段...
echo ====================================
pause