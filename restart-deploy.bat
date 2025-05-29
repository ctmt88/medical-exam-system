@echo off
chcp 65001 >nul
echo ====================================
echo 簡單重啟部署 - 回到能工作的版本
echo ====================================
echo.

echo 🔄 建立最簡單但有效的互動版本...
echo.

REM 先確保基本建置可以工作
cd frontend

REM 刪除有問題的 App.jsx，建立一個簡單版本
echo 🔧 建立簡單互動版 App.jsx...
echo import React, { useState } from 'react' > src\App.jsx
echo. >> src\App.jsx
echo function App() { >> src\App.jsx
echo   const [showLogin, setShowLogin] = useState(false) >> src\App.jsx
echo   const [isLoggedIn, setIsLoggedIn] = useState(false) >> src\App.jsx
echo. >> src\App.jsx
echo   const subjects = [ >> src\App.jsx
echo     '臨床生理學與病理學', >> src\App.jsx
echo     '臨床血液學與血庫學', >> src\App.jsx
echo     '醫學分子檢驗學與臨床鏡檢學', >> src\App.jsx
echo     '微生物學與臨床微生物學', >> src\App.jsx
echo     '生物化學與臨床生化學', >> src\App.jsx
echo     '臨床血清免疫學與臨床病毒學' >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   const handleLogin = () =^> { >> src\App.jsx
echo     setIsLoggedIn(true) >> src\App.jsx
echo     setShowLogin(false) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const startExam = (subject) =^> { >> src\App.jsx
echo     alert(`準備開始 ${subject} 考試！\n\n這是展示版本，完整功能開發中...`) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   if (!isLoggedIn) { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"^> >> src\App.jsx
echo         ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo           ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo             ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo               ^<div className="flex items-center"^> >> src\App.jsx
echo                 ^<h1 className="text-2xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo                 ^<span className="ml-2 px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded-full"^>互動展示版^</span^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<button >> src\App.jsx
echo                 onClick={() =^> setShowLogin(true)} >> src\App.jsx
echo                 className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors" >> src\App.jsx
echo               ^> >> src\App.jsx
echo                 登入系統 >> src\App.jsx
echo               ^</button^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</nav^> >> src\App.jsx
echo. >> src\App.jsx
echo         ^<main className="max-w-7xl mx-auto py-12 px-4"^> >> src\App.jsx
echo           ^<div className="text-center mb-12"^> >> src\App.jsx
echo             ^<h2 className="text-4xl font-bold text-gray-900 mb-4"^> >> src\App.jsx
echo               醫事檢驗師國家考試線上練習系統 >> src\App.jsx
echo             ^</h2^> >> src\App.jsx
echo             ^<p className="text-xl text-gray-600 mb-8"^> >> src\App.jsx
echo               互動展示版 - 點擊登入體驗完整功能 >> src\App.jsx
echo             ^</p^> >> src\App.jsx
echo             ^<button >> src\App.jsx
echo               onClick={() =^> setShowLogin(true)} >> src\App.jsx
echo               className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors" >> src\App.jsx
echo             ^> >> src\App.jsx
echo               立即體驗 >> src\App.jsx
echo             ^</button^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo           ^<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8"^> >> src\App.jsx
echo             {subjects.map((subject, index) =^> ( >> src\App.jsx
echo               ^<div key={index} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"^> >> src\App.jsx
echo                 ^<h3 className="text-lg font-bold text-gray-900 mb-2"^>{subject}^</h3^> >> src\App.jsx
echo                 ^<p className="text-gray-600 mb-4 text-sm"^>80題 • 60分鐘 • 滿分100分^</p^> >> src\App.jsx
echo                 ^<button >> src\App.jsx
echo                   onClick={() =^> setShowLogin(true)} >> src\App.jsx
echo                   className="w-full px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm font-medium" >> src\App.jsx
echo                 ^> >> src\App.jsx
echo                   開始練習 >> src\App.jsx
echo                 ^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ))} >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</main^> >> src\App.jsx
echo. >> src\App.jsx
echo         {showLogin ^&^& ( >> src\App.jsx
echo           ^<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4"^> >> src\App.jsx
echo               ^<h3 className="text-lg font-semibold text-gray-800 mb-4"^>系統登入^</h3^> >> src\App.jsx
echo               ^<div className="space-y-4"^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<label className="block text-sm font-medium text-gray-700 mb-1"^>學號^</label^> >> src\App.jsx
echo                   ^<input >> src\App.jsx
echo                     type="text" >> src\App.jsx
echo                     defaultValue="DEMO001" >> src\App.jsx
echo                     className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" >> src\App.jsx
echo                   /^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<label className="block text-sm font-medium text-gray-700 mb-1"^>密碼^</label^> >> src\App.jsx
echo                   ^<input >> src\App.jsx
echo                     type="password" >> src\App.jsx
echo                     defaultValue="demo123" >> src\App.jsx
echo                     className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" >> src\App.jsx
echo                   /^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div className="bg-blue-50 border border-blue-200 rounded-lg p-3"^> >> src\App.jsx
echo                   ^<p className="text-sm text-blue-800"^> >> src\App.jsx
echo                     展示帳號：學號 DEMO001，密碼 demo123 >> src\App.jsx
echo                   ^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="flex gap-3 mt-6"^> >> src\App.jsx
echo                 ^<button >> src\App.jsx
echo                   onClick={() =^> setShowLogin(false)} >> src\App.jsx
echo                   className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors" >> src\App.jsx
echo                 ^> >> src\App.jsx
echo                   取消 >> src\App.jsx
echo                 ^</button^> >> src\App.jsx
echo                 ^<button >> src\App.jsx
echo                   onClick={handleLogin} >> src\App.jsx
echo                   className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors" >> src\App.jsx
echo                 ^> >> src\App.jsx
echo                   登入 >> src\App.jsx
echo                 ^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         )} >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   return ( >> src\App.jsx
echo     ^<div className="min-h-screen bg-gray-50"^> >> src\App.jsx
echo       ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo           ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo             ^<h1 className="text-xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo             ^<div className="flex items-center space-x-4"^> >> src\App.jsx
echo               ^<span className="text-gray-700"^>歡迎，展示使用者^</span^> >> src\App.jsx
echo               ^<button >> src\App.jsx
echo                 onClick={() =^> setIsLoggedIn(false)} >> src\App.jsx
echo                 className="text-gray-500 hover:text-gray-700 transition-colors" >> src\App.jsx
echo               ^> >> src\App.jsx
echo                 登出 >> src\App.jsx
echo               ^</button^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</nav^> >> src\App.jsx
echo. >> src\App.jsx
echo       ^<div className="max-w-7xl mx-auto py-8 px-4"^> >> src\App.jsx
echo         ^<div className="grid lg:grid-cols-4 gap-6 mb-8"^> >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6 text-center"^> >> src\App.jsx
echo             ^<h4 className="text-sm text-gray-600 mb-2"^>最佳成績^</h4^> >> src\App.jsx
echo             ^<p className="text-2xl font-bold text-yellow-600"^>95.0^</p^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6 text-center"^> >> src\App.jsx
echo             ^<h4 className="text-sm text-gray-600 mb-2"^>平均分數^</h4^> >> src\App.jsx
echo             ^<p className="text-2xl font-bold text-blue-600"^>85.3^</p^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6 text-center"^> >> src\App.jsx
echo             ^<h4 className="text-sm text-gray-600 mb-2"^>考試次數^</h4^> >> src\App.jsx
echo             ^<p className="text-2xl font-bold text-green-600"^>15^</p^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6 text-center"^> >> src\App.jsx
echo             ^<h4 className="text-sm text-gray-600 mb-2"^>學習狀態^</h4^> >> src\App.jsx
echo             ^<p className="text-2xl font-bold text-purple-600"^>活躍^</p^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo         ^<div className="bg-white rounded-lg shadow p-6"^> >> src\App.jsx
echo           ^<h2 className="text-lg font-semibold text-gray-900 mb-6"^>選擇考試科目^</h2^> >> src\App.jsx
echo           ^<div className="grid md:grid-cols-2 gap-4"^> >> src\App.jsx
echo             {subjects.map((subject, index) =^> ( >> src\App.jsx
echo               ^<div key={index} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors"^> >> src\App.jsx
echo                 ^<h3 className="font-semibold text-gray-900 mb-2"^>{subject}^</h3^> >> src\App.jsx
echo                 ^<p className="text-sm text-gray-600 mb-4"^>80題 • 60分鐘 • 滿分100分^</p^> >> src\App.jsx
echo                 ^<button >> src\App.jsx
echo                   onClick={() =^> startExam(subject)} >> src\App.jsx
echo                   className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium" >> src\App.jsx
echo                 ^> >> src\App.jsx
echo                   開始考試 >> src\App.jsx
echo                 ^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ))} >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ) >> src\App.jsx
echo } >> src\App.jsx
echo. >> src\App.jsx
echo export default App >> src\App.jsx

echo ✅ 簡單版 App.jsx 建立完成
echo.

echo 🧪 測試建置...
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 建置成功！
) else (
    echo ❌ 建置失敗
    pause
    exit /b 1
)

cd ..

echo 🚀 部署簡化互動版本...
git add .
git commit -m "Deploy working interactive version with login and dashboard"
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 成功部署簡化互動版本！
    echo.
    echo 📋 這個版本包含：
    echo ✅ 可點擊的登入按鈕
    echo ✅ 登入模態框 ^(DEMO001/demo123^)
    echo ✅ 學生儀表板 ^(登入後顯示^)
    echo ✅ 統計卡片顯示
    echo ✅ 可點擊的考試按鈕 ^(會顯示準備訊息^)
    echo ✅ 現代化的 UI 設計
    echo.
    echo 🌐 等待 3-5 分鐘後訪問：
    echo https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 🎯 測試步驟：
    echo 1. 點擊 "登入系統" 按鈕
    echo 2. 使用 DEMO001/demo123 登入
    echo 3. 查看學生儀表板
    echo 4. 點擊任一科目的 "開始考試"
    echo.
    echo 📱 現在應該會看到明顯的變化：
    echo - 標題旁有 "互動展示版" 標籤
    echo - 按鈕可以實際點擊並有反應
    echo - 登入後會切換到不同的頁面
) else (
    echo ❌ 部署失敗
)

echo.
echo ====================================
echo 簡化互動版本部署完成
echo ====================================
pause