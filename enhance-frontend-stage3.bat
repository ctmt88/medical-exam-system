@echo off
chcp 65001 >nul
echo ====================================
echo 前端互動功能增強 - 第三階段
echo 建立考試介面和結果頁面
echo ====================================
echo.

REM 確保第二階段已完成
if not exist "frontend\src\App.jsx" (
    echo ❌ 錯誤：找不到 App.jsx，請先執行前兩個階段
    pause
    exit /b 1
)

echo ✅ 建立考試介面和結果頁面...
echo.

REM 繼續建立考試介面
echo 🔧 建立考試介面視圖...
echo. >> frontend\src\App.jsx
echo   // 考試介面視圖 >> frontend\src\App.jsx
echo   const ExamInterface = ^(^) =^> ( >> frontend\src\App.jsx
echo     ^<div className="min-h-screen bg-gray-50"^> >> frontend\src\App.jsx
echo       ^<nav className="bg-white shadow-sm border-b"^> >> frontend\src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-3"^> >> frontend\src\App.jsx
echo           ^<div className="flex items-center justify-between"^> >> frontend\src\App.jsx
echo             ^<h1 className="text-xl font-semibold text-gray-800"^>{selectedSubject?.name}^</h1^> >> frontend\src\App.jsx
echo             ^<div className="flex items-center gap-6"^> >> frontend\src\App.jsx
echo               ^<div className="flex items-center gap-2 text-gray-600"^> >> frontend\src\App.jsx
echo                 ^<span^>已答: {Object.keys(userAnswers^).length}/80^</span^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo               ^<div className="flex items-center gap-2"^> >> frontend\src\App.jsx
echo                 ^<span className={`font-mono text-lg ${examTimer ^< 600 ? 'text-red-600 font-bold' : 'text-gray-700'}`}^> >> frontend\src\App.jsx
echo                   {formatTime(examTimer^)} >> frontend\src\App.jsx
echo                 ^</span^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo               ^<button onClick={^(^) =^> { setIsExamActive(false^); setCurrentView('result'^) }} className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700"^>提交^</button^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo       ^</nav^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo       ^<div className="max-w-7xl mx-auto px-4 py-6"^> >> frontend\src\App.jsx
echo         ^<div className="grid grid-cols-1 lg:grid-cols-4 gap-6"^> >> frontend\src\App.jsx
echo           ^{/* 題目導航面板 */} >> frontend\src\App.jsx
echo           ^<div className="lg:col-span-1"^> >> frontend\src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-sm p-4"^> >> frontend\src\App.jsx
echo               ^<h3 className="font-semibold text-gray-800 mb-3"^>題目導航^</h3^> >> frontend\src\App.jsx
echo               ^<div className="grid grid-cols-8 gap-1"^> >> frontend\src\App.jsx
echo                 {mockQuestions.map(^(_, index^) =^> { >> frontend\src\App.jsx
echo                   const isAnswered = userAnswers[index + 1] >> frontend\src\App.jsx
echo                   const isCurrent = index === currentQuestion >> frontend\src\App.jsx
echo                   return ^( >> frontend\src\App.jsx
echo                     ^<button >> frontend\src\App.jsx
echo                       key={index} >> frontend\src\App.jsx
echo                       onClick={^(^) =^> setCurrentQuestion(index^)} >> frontend\src\App.jsx
echo                       className={` >> frontend\src\App.jsx
echo                         w-8 h-8 text-xs rounded border text-center transition-colors >> frontend\src\App.jsx
echo                         ${isCurrent ? 'ring-2 ring-blue-500' : ''} >> frontend\src\App.jsx
echo                         ${isAnswered ? 'bg-green-100 border-green-300 text-green-700' : 'bg-gray-100 border-gray-300 text-gray-700'} >> frontend\src\App.jsx
echo                         hover:bg-blue-50 >> frontend\src\App.jsx
echo                       `} >> frontend\src\App.jsx
echo                     ^> >> frontend\src\App.jsx
echo                       {index + 1} >> frontend\src\App.jsx
echo                     ^</button^> >> frontend\src\App.jsx
echo                   ^) >> frontend\src\App.jsx
echo                 }^)} >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo               ^<div className="mt-4 space-y-2 text-xs text-gray-600"^> >> frontend\src\App.jsx
echo                 ^<div className="flex items-center gap-2"^> >> frontend\src\App.jsx
echo                   ^<div className="w-3 h-3 bg-green-100 border border-green-300 rounded"^>^</div^> >> frontend\src\App.jsx
echo                   ^<span^>已作答^</span^> >> frontend\src\App.jsx
echo                 ^</div^> >> frontend\src\App.jsx
echo                 ^<div className="flex items-center gap-2"^> >> frontend\src\App.jsx
echo                   ^<div className="w-3 h-3 bg-gray-100 border border-gray-300 rounded"^>^</div^> >> frontend\src\App.jsx
echo                   ^<span^>未作答^</span^> >> frontend\src\App.jsx
echo                 ^</div^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo           ^{/* 題目內容區 */} >> frontend\src\App.jsx
echo           ^<div className="lg:col-span-3"^> >> frontend\src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-sm p-6"^> >> frontend\src\App.jsx
echo               ^<div className="flex items-center justify-between mb-4"^> >> frontend\src\App.jsx
echo                 ^<h2 className="text-lg font-semibold text-gray-800"^>第 {currentQuestion + 1} 題^</h2^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo               ^<div className="mb-6"^> >> frontend\src\App.jsx
echo                 ^<p className="text-gray-800 leading-relaxed mb-4"^> >> frontend\src\App.jsx
echo                   {mockQuestions[currentQuestion]?.question} >> frontend\src\App.jsx
echo                 ^</p^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo               ^<div className="space-y-3 mb-6"^> >> frontend\src\App.jsx
echo                 {Object.entries(mockQuestions[currentQuestion]?.options || {}^).map(^([key, value]^) =^> ^( >> frontend\src\App.jsx
echo                   ^<button >> frontend\src\App.jsx
echo                     key={key} >> frontend\src\App.jsx
echo                     onClick={^(^) =^> selectAnswer(currentQuestion + 1, key^)} >> frontend\src\App.jsx
echo                     className={` >> frontend\src\App.jsx
echo                       w-full p-4 text-left rounded-lg border transition-colors >> frontend\src\App.jsx
echo                       ${userAnswers[currentQuestion + 1] === key >> frontend\src\App.jsx
echo                         ? 'bg-blue-100 border-blue-300 text-blue-800' >> frontend\src\App.jsx
echo                         : 'bg-gray-50 border-gray-200 text-gray-800 hover:bg-gray-100'} >> frontend\src\App.jsx
echo                     `} >> frontend\src\App.jsx
echo                   ^> >> frontend\src\App.jsx
echo                     ^<span className="font-semibold mr-3"^>^({key}^)^</span^> >> frontend\src\App.jsx
echo                     {value} >> frontend\src\App.jsx
echo                   ^</button^> >> frontend\src\App.jsx
echo                 ^)^)} >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo               ^<div className="flex items-center justify-between"^> >> frontend\src\App.jsx
echo                 ^<button >> frontend\src\App.jsx
echo                   onClick={^(^) =^> setCurrentQuestion(Math.max(0, currentQuestion - 1^)^)} >> frontend\src\App.jsx
echo                   disabled={currentQuestion === 0} >> frontend\src\App.jsx
echo                   className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed" >> frontend\src\App.jsx
echo                 ^> >> frontend\src\App.jsx
echo                   上一題 >> frontend\src\App.jsx
echo                 ^</button^> >> frontend\src\App.jsx
echo                 ^<span className="text-gray-600"^>{currentQuestion + 1} / 80^</span^> >> frontend\src\App.jsx
echo                 ^<button >> frontend\src\App.jsx
echo                   onClick={^(^) =^> setCurrentQuestion(Math.min(79, currentQuestion + 1^)^)} >> frontend\src\App.jsx
echo                   disabled={currentQuestion === 79} >> frontend\src\App.jsx
echo                   className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed" >> frontend\src\App.jsx
echo                 ^> >> frontend\src\App.jsx
echo                   下一題 >> frontend\src\App.jsx
echo                 ^</button^> >> frontend\src\App.jsx
echo               ^</div^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo       ^</div^> >> frontend\src\App.jsx
echo     ^</div^> >> frontend\src\App.jsx
echo   ^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx

echo ✅ 考試介面建立完成
echo.

echo 🔧 建立考試結果頁面...
echo   // 考試結果頁面 >> frontend\src\App.jsx
echo   const ResultPage = ^(^) =^> { >> frontend\src\App.jsx
echo     const correctCount = Object.entries(userAnswers^).filter(^([questionId, answer]^) =^> >> frontend\src\App.jsx
echo       mockQuestions[parseInt(questionId^) - 1]?.correctAnswer === answer >> frontend\src\App.jsx
echo     ^).length >> frontend\src\App.jsx
echo     const score = (correctCount * 1.25^).toFixed(1^) >> frontend\src\App.jsx
echo     const percentage = ^((correctCount / 80^) * 100^).toFixed(1^) >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo     return ^( >> frontend\src\App.jsx
echo       ^<div className="min-h-screen bg-gray-50 flex items-center justify-center"^> >> frontend\src\App.jsx
echo         ^<div className="bg-white rounded-lg shadow-xl p-8 max-w-2xl w-full mx-4"^> >> frontend\src\App.jsx
echo           ^<div className="text-center mb-8"^> >> frontend\src\App.jsx
echo             ^<h2 className="text-3xl font-bold text-gray-900 mb-4"^>考試完成！^</h2^> >> frontend\src\App.jsx
echo             ^<p className="text-xl text-gray-600"^>{selectedSubject?.name}^</p^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo           ^<div className="grid grid-cols-2 gap-8 mb-8"^> >> frontend\src\App.jsx
echo             ^<div className="text-center"^> >> frontend\src\App.jsx
echo               ^<div className="text-4xl font-bold text-blue-600 mb-2"^>{score}^</div^> >> frontend\src\App.jsx
echo               ^<div className="text-gray-600"^>總分 ^(滿分100^)^</div^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo             ^<div className="text-center"^> >> frontend\src\App.jsx
echo               ^<div className="text-4xl font-bold text-green-600 mb-2"^>{correctCount}/80^</div^> >> frontend\src\App.jsx
echo               ^<div className="text-gray-600"^>答對題數^</div^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo           ^<div className="mb-8"^> >> frontend\src\App.jsx
echo             ^<div className="bg-gray-200 rounded-full h-4 mb-2"^> >> frontend\src\App.jsx
echo               ^<div className="bg-blue-600 h-4 rounded-full" style={{width: `${percentage}%%`}}^>^</div^> >> frontend\src\App.jsx
echo             ^</div^> >> frontend\src\App.jsx
echo             ^<div className="text-center text-gray-600"^>答對率: {percentage}%%^</div^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo           ^<div className="flex gap-4"^> >> frontend\src\App.jsx
echo             ^<button >> frontend\src\App.jsx
echo               onClick={^(^) =^> setCurrentView('dashboard'^)} >> frontend\src\App.jsx
echo               className="flex-1 py-3 px-6 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold" >> frontend\src\App.jsx
echo             ^> >> frontend\src\App.jsx
echo               返回首頁 >> frontend\src\App.jsx
echo             ^</button^> >> frontend\src\App.jsx
echo             ^<button >> frontend\src\App.jsx
echo               onClick={^(^) =^> { >> frontend\src\App.jsx
echo                 setCurrentView('exam'^) >> frontend\src\App.jsx
echo                 setCurrentQuestion(0^) >> frontend\src\App.jsx
echo                 setExamTimer(3600^) >> frontend\src\App.jsx
echo                 setUserAnswers({}^) >> frontend\src\App.jsx
echo                 setIsExamActive(true^) >> frontend\src\App.jsx
echo               }} >> frontend\src\App.jsx
echo               className="flex-1 py-3 px-6 bg-green-600 text-white rounded-lg hover:bg-green-700 font-semibold" >> frontend\src\App.jsx
echo             ^> >> frontend\src\App.jsx
echo               重新考試 >> frontend\src\App.jsx
echo             ^</button^> >> frontend\src\App.jsx
echo           ^</div^> >> frontend\src\App.jsx
echo         ^</div^> >> frontend\src\App.jsx
echo       ^</div^> >> frontend\src\App.jsx
echo     ^) >> frontend\src\App.jsx
echo   } >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx

echo ✅ 考試結果頁面建立完成
echo.

echo 🔧 建立主要渲染邏輯...
echo   // 主要渲染邏輯 >> frontend\src\App.jsx
echo   return ^( >> frontend\src\App.jsx
echo     ^<div^> >> frontend\src\App.jsx
echo       {currentView === 'home' && ^<HomePage /^>} >> frontend\src\App.jsx
echo       {currentView === 'dashboard' && isLoggedIn && ^<Dashboard /^>} >> frontend\src\App.jsx
echo       {currentView === 'exam' && isLoggedIn && ^<ExamInterface /^>} >> frontend\src\App.jsx
echo       {currentView === 'result' && isLoggedIn && ^<ResultPage /^>} >> frontend\src\App.jsx
echo       {showLoginModal && ^<LoginModal /^>} >> frontend\src\App.jsx
echo     ^</div^> >> frontend\src\App.jsx
echo   ^) >> frontend\src\App.jsx
echo } >> frontend\src\App.jsx
echo. >> frontend\src\App.jsx
echo export default App >> frontend\src\App.jsx

echo ✅ 主要渲染邏輯建立完成
echo.

echo 🧪 測試建置...
cd frontend
npm run build
if %ERRORLEVEL% EQU 0 (
    echo ✅ 建置成功！
    cd ..
) else (
    echo ❌ 建置失敗，檢查錯誤...
    cd ..
    pause
    exit /b 1
)

echo 🚀 部署到 GitHub...
git add .
git commit -m "Add complete interactive exam system with timer and navigation"
git push origin main

echo.
if %ERRORLEVEL% EQU 0 (
    echo 🎉🎉🎉 完整的互動考試系統部署成功！ 🎉🎉🎉
    echo.
    echo 📋 新功能摘要：
    echo ✅ 可用的登入系統 ^(DEMO001/demo123^)
    echo ✅ 學生儀表板 ^(顯示統計資訊^)
    echo ✅ 六大科目考試選擇
    echo ✅ 完整的考試介面 ^(80題，60分鐘^)
    echo ✅ 題目導航 ^(可跳題^)
    echo ✅ 倒數計時器
    echo ✅ 即時答題狀態
    echo ✅ 考試結果頁面 ^(分數計算^)
    echo ✅ 重考功能
    echo.
    echo 🌐 你的網站：https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 🎯 現在你可以：
    echo 1. 等待 2-3 分鐘讓 GitHub Actions 部署
    echo 2. 訪問網站測試所有功能
    echo 3. 使用 DEMO001/demo123 登入
    echo 4. 開始一場完整的模擬考試！
    echo.
    echo 🏆 恭喜！你已經有一個功能完整的考試系統了！
) else (
    echo ❌ 部署失敗，請檢查錯誤訊息
)

echo.
echo ====================================
echo 前端互動功能增強完成！
echo ====================================
pause