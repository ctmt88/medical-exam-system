@echo off
chcp 65001 >nul
echo 建立Dashboard和其他頁面...
cd frontend

echo 繼續建立Dashboard頁面...
echo   if (currentView === 'dashboard') { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div className="min-h-screen bg-gray-50"^> >> src\App.jsx
echo         ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo           ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo             ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo               ^<h1 className="text-xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo               ^<div className="flex items-center space-x-4"^> >> src\App.jsx
echo                 ^<span className="text-gray-700"^>歡迎，{currentUser?.username}^</span^> >> src\App.jsx
echo                 ^<button onClick={() =^> setCurrentView('home')} className="text-blue-600 hover:text-blue-700"^>返回首頁^</button^> >> src\App.jsx
echo                 ^<button onClick={() =^> { setIsLoggedIn(false); setCurrentUser(null); setCurrentView('home') }} className="text-gray-500 hover:text-gray-700"^>登出^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</nav^> >> src\App.jsx
echo         ^<div className="max-w-7xl mx-auto py-8 px-4"^> >> src\App.jsx
echo           ^<div className="grid lg:grid-cols-4 gap-6 mb-8"^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow p-6"^>^<h4 className="text-sm text-gray-600"^>最佳成績^</h4^>^<p className="text-2xl font-bold text-yellow-600"^>95.0^</p^>^</div^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow p-6"^>^<h4 className="text-sm text-gray-600"^>平均分數^</h4^>^<p className="text-2xl font-bold text-blue-600"^>85.3^</p^>^</div^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow p-6"^>^<h4 className="text-sm text-gray-600"^>考試次數^</h4^>^<p className="text-2xl font-bold text-green-600"^>15^</p^>^</div^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow p-6"^>^<h4 className="text-sm text-gray-600"^>學習狀態^</h4^>^<p className="text-2xl font-bold text-purple-600"^>活躍^</p^>^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> src\App.jsx
echo             ^<h2 className="text-lg font-semibold text-gray-900 mb-6"^>選擇考試科目^</h2^> >> src\App.jsx
echo             ^<div className="grid md:grid-cols-2 gap-4"^> >> src\App.jsx
echo               {subjects.map(subject =^> ( >> src\App.jsx
echo                 ^<div key={subject.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors"^> >> src\App.jsx
echo                   ^<h3 className="font-semibold text-gray-900 mb-2"^>{subject.name}^</h3^> >> src\App.jsx
echo                   ^<p className="text-sm text-gray-600 mb-4"^>{subject.description}^</p^> >> src\App.jsx
echo                   ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                     ^<span className="text-xs text-gray-500"^>{subject.questions}題 • 60分鐘^</span^> >> src\App.jsx
echo                     ^<button onClick={() =^> startExam(subject.id)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm"^>開始考試^</button^> >> src\App.jsx
echo                   ^</div^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ))} >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo 建立考試介面...
echo   if (currentView === 'exam') { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div className="min-h-screen bg-gray-50"^> >> src\App.jsx
echo         ^<nav className="bg-white shadow-sm border-b"^> >> src\App.jsx
echo           ^<div className="max-w-7xl mx-auto px-4 py-3"^> >> src\App.jsx
echo             ^<div className="flex items-center justify-between"^> >> src\App.jsx
echo               ^<h1 className="text-xl font-semibold text-gray-800"^>{selectedSubject?.name}^</h1^> >> src\App.jsx
echo               ^<div className="flex items-center gap-6"^> >> src\App.jsx
echo                 ^<span className="text-gray-600"^>已答: {Object.keys(userAnswers).length}/80^</span^> >> src\App.jsx
echo                 ^<span className={`font-mono text-lg ${examTimer ^< 600 ? 'text-red-600 font-bold' : 'text-gray-700'}`}^>{formatTime(examTimer)}^</span^> >> src\App.jsx
echo                 ^<button onClick={() =^> { setIsExamActive(false); setCurrentView('result') }} className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700"^>提交^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</nav^> >> src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-6"^> >> src\App.jsx
echo           ^<div className="grid grid-cols-1 lg:grid-cols-4 gap-6"^> >> src\App.jsx
echo             ^<div className="lg:col-span-1"^> >> src\App.jsx
echo               ^<div className="bg-white rounded-lg shadow-sm p-4"^> >> src\App.jsx
echo                 ^<h3 className="font-semibold text-gray-800 mb-3"^>題目導航^</h3^> >> src\App.jsx
echo                 ^<div className="grid grid-cols-8 gap-1"^> >> src\App.jsx
echo                   {mockQuestions.map((_, index) =^> { >> src\App.jsx
echo                     const isAnswered = userAnswers[index + 1] >> src\App.jsx
echo                     const isCurrent = index === currentQuestion >> src\App.jsx
echo                     const isMarked = markedQuestions.has(index + 1) >> src\App.jsx
echo                     return ( >> src\App.jsx
echo                       ^<button key={index} onClick={() =^> setCurrentQuestion(index)} className={`w-8 h-8 text-xs rounded border text-center transition-colors relative ${isCurrent ? 'ring-2 ring-blue-500' : ''} ${isAnswered ? 'bg-green-100 border-green-300 text-green-700' : 'bg-gray-100 border-gray-300 text-gray-700'} hover:bg-blue-50`}^> >> src\App.jsx
echo                         {index + 1} >> src\App.jsx
echo                         {isMarked ^&^& ^<div className="absolute -top-1 -right-1 w-2 h-2 bg-yellow-400 rounded-full"^>^</div^>} >> src\App.jsx
echo                       ^</button^> >> src\App.jsx
echo                     ) >> src\App.jsx
echo                   })} >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="lg:col-span-3"^> >> src\App.jsx
echo               ^<div className="bg-white rounded-lg shadow-sm p-6"^> >> src\App.jsx
echo                 ^<div className="flex items-center justify-between mb-4"^> >> src\App.jsx
echo                   ^<h2 className="text-lg font-semibold text-gray-800"^>第 {currentQuestion + 1} 題^</h2^> >> src\App.jsx
echo                   ^<button onClick={() =^> toggleMark(currentQuestion + 1)} className={`px-3 py-1 rounded text-sm ${markedQuestions.has(currentQuestion + 1) ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-700'}`}^>{markedQuestions.has(currentQuestion + 1) ? '取消標記' : '標記'}^</button^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div className="mb-6"^>^<p className="text-gray-800 leading-relaxed mb-4"^>{mockQuestions[currentQuestion]?.question}^</p^>^</div^> >> src\App.jsx
echo                 ^<div className="space-y-3 mb-6"^> >> src\App.jsx
echo                   {Object.entries(mockQuestions[currentQuestion]?.options || {}).map(([key, value]) =^> ( >> src\App.jsx
echo                     ^<button key={key} onClick={() =^> selectAnswer(currentQuestion + 1, key)} className={`w-full p-4 text-left rounded-lg border transition-colors ${userAnswers[currentQuestion + 1] === key ? 'bg-blue-100 border-blue-300 text-blue-800' : 'bg-gray-50 border-gray-200 text-gray-800 hover:bg-gray-100'}`}^> >> src\App.jsx
echo                       ^<span className="font-semibold mr-3"^>({key})^</span^>{value} >> src\App.jsx
echo                     ^</button^> >> src\App.jsx
echo                   ))} >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div className="flex items-center justify-between"^> >> src\App.jsx
echo                   ^<button onClick={() =^> setCurrentQuestion(Math.max(0, currentQuestion - 1))} disabled={currentQuestion === 0} className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 disabled:opacity-50"^>上一題^</button^> >> src\App.jsx
echo                   ^<span className="text-gray-600"^>{currentQuestion + 1} / 80^</span^> >> src\App.jsx
echo                   ^<button onClick={() =^> setCurrentQuestion(Math.min(79, currentQuestion + 1))} disabled={currentQuestion === 79} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50"^>下一題^</button^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo 建立結果頁面...
echo   if (currentView === 'result') { >> src\App.jsx
echo     const correctCount = Object.entries(userAnswers).filter(([questionId, answer]) =^> mockQuestions[parseInt(questionId) - 1]?.correctAnswer === answer).length >> src\App.jsx
echo     const score = (correctCount * 1.25).toFixed(1) >> src\App.jsx
echo     const percentage = ((correctCount / 80) * 100).toFixed(1) >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div className="min-h-screen bg-gray-50 flex items-center justify-center"^> >> src\App.jsx
echo         ^<div className="bg-white rounded-lg shadow-xl p-8 max-w-2xl w-full mx-4"^> >> src\App.jsx
echo           ^<div className="text-center mb-8"^>^<h2 className="text-3xl font-bold text-gray-900 mb-4"^>考試完成！^</h2^>^<p className="text-xl text-gray-600"^>{selectedSubject?.name}^</p^>^</div^> >> src\App.jsx
echo           ^<div className="grid grid-cols-2 gap-8 mb-8"^> >> src\App.jsx
echo             ^<div className="text-center"^>^<div className="text-4xl font-bold text-blue-600 mb-2"^>{score}^</div^>^<div className="text-gray-600"^>總分^</div^>^</div^> >> src\App.jsx
echo             ^<div className="text-center"^>^<div className="text-4xl font-bold text-green-600 mb-2"^>{correctCount}/80^</div^>^<div className="text-gray-600"^>答對題數^</div^>^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div className="mb-8"^>^<div className="bg-gray-200 rounded-full h-4 mb-2"^>^<div className="bg-blue-600 h-4 rounded-full" style={{width: `${percentage}%%`}}^>^</div^>^</div^>^<div className="text-center text-gray-600"^>答對率: {percentage}%%^</div^>^</div^> >> src\App.jsx
echo           ^<div className="flex gap-4"^> >> src\App.jsx
echo             ^<button onClick={() =^> setCurrentView('dashboard')} className="flex-1 py-3 px-6 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold"^>返回首頁^</button^> >> src\App.jsx
echo             ^<button onClick={() =^> startExam(selectedSubject.id)} className="flex-1 py-3 px-6 bg-green-600 text-white rounded-lg hover:bg-green-700 font-semibold"^>重新考試^</button^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo 建立主要return邏輯...
echo   return null >> src\App.jsx
echo } >> src\App.jsx
echo. >> src\App.jsx
echo export default App >> src\App.jsx

echo 測試建置...
npm run build
if %ERRORLEVEL% EQU 0 (
    echo 建置成功！
) else (
    echo 建置失敗
    pause
    exit /b 1
)

echo 部署到GitHub...
cd ..
git add .
git commit -m "Complete App.jsx fix - all pages working with proper login flow"
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo 🎉 完整修復成功！
    echo ========================================
    echo.
    echo ✅ 所有功能：
    echo - 免登入瀏覽首頁
    echo - 點擊科目登入考試
    echo - 完整考試流程
    echo - 成績計算和顯示
    echo.
    echo 🌐 https://ctmt88.github.io/medical-exam-system/
    echo ========================================
) else (
    echo 部署失敗
)

pause