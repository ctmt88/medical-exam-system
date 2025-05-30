@echo off 
chcp 65001 >nul 
echo 建立學生儀表板和考試介面... 
 
REM 繼續建立 App.jsx 的學生儀表板 
echo 🔧 建立學生儀表板視圖... 
echo   // 學生儀表板視圖 >> frontend\src\App.jsx 
echo   const Dashboard = ^(^) =^> ^( >> frontend\src\App.jsx 
echo     ^<div className="min-h-screen bg-gray-50"^> >> frontend\src\App.jsx 
echo       ^<nav className="bg-white shadow-sm"^> >> frontend\src\App.jsx 
echo         ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> frontend\src\App.jsx 
echo           ^<div className="flex justify-between items-center"^> >> frontend\src\App.jsx 
echo             ^<h1 className="text-xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> frontend\src\App.jsx 
echo             ^<div className="flex items-center space-x-4"^> >> frontend\src\App.jsx 
echo               ^<span className="text-gray-700"^>歡迎，展示使用者^</span^> >> frontend\src\App.jsx 
echo               ^<button onClick={^(^) =^> { setIsLoggedIn(false^); setCurrentView('home'^) }} className="text-gray-500 hover:text-gray-700"^>登出^</button^> >> frontend\src\App.jsx 
echo             ^</div^> >> frontend\src\App.jsx 
echo           ^</div^> >> frontend\src\App.jsx 
echo         ^</div^> >> frontend\src\App.jsx 
echo       ^</nav^> >> frontend\src\App.jsx 
echo. >> frontend\src\App.jsx 
echo       ^<div className="max-w-7xl mx-auto py-8 px-4"^> >> frontend\src\App.jsx 
echo         ^<div className="grid lg:grid-cols-4 gap-6 mb-8"^> >> frontend\src\App.jsx 
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> frontend\src\App.jsx 
echo             ^<h4 className="text-sm text-gray-600"^>最佳成績^</h4^> >> frontend\src\App.jsx 
echo             ^<p className="text-2xl font-bold text-yellow-600"^>95.0^</p^> >> frontend\src\App.jsx 
echo           ^</div^> >> frontend\src\App.jsx 
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> frontend\src\App.jsx 
echo             ^<h4 className="text-sm text-gray-600"^>平均分數^</h4^> >> frontend\src\App.jsx 
echo             ^<p className="text-2xl font-bold text-blue-600"^>85.3^</p^> >> frontend\src\App.jsx 
echo           ^</div^> >> frontend\src\App.jsx 
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> frontend\src\App.jsx 
echo             ^<h4 className="text-sm text-gray-600"^>考試次數^</h4^> >> frontend\src\App.jsx 
echo             ^<p className="text-2xl font-bold text-green-600"^>15^</p^> >> frontend\src\App.jsx 
echo           ^</div^> >> frontend\src\App.jsx 
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> frontend\src\App.jsx 
echo             ^<h4 className="text-sm text-gray-600"^>學習狀態^</h4^> >> frontend\src\App.jsx 
echo             ^<p className="text-2xl font-bold text-purple-600"^>活躍^</p^> >> frontend\src\App.jsx 
echo           ^</div^> >> frontend\src\App.jsx 
echo         ^</div^> >> frontend\src\App.jsx 
echo. >> frontend\src\App.jsx 
echo         ^<div className="bg-white rounded-lg shadow p-6"^> >> frontend\src\App.jsx 
echo           ^<h2 className="text-lg font-semibold text-gray-900 mb-6"^>選擇考試科目^</h2^> >> frontend\src\App.jsx 
echo           ^<div className="grid md:grid-cols-2 gap-4"^> >> frontend\src\App.jsx 
echo             {subjects.map(subject =^> ^( >> frontend\src\App.jsx 
echo               ^<div key={subject.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors"^> >> frontend\src\App.jsx 
echo                 ^<h3 className="font-semibold text-gray-900 mb-2"^>{subject.name}^</h3^> >> frontend\src\App.jsx 
echo                 ^<p className="text-sm text-gray-600 mb-4"^>{subject.shortName}^</p^> >> frontend\src\App.jsx 
echo                 ^<div className="flex justify-between items-center"^> >> frontend\src\App.jsx 
echo                   ^<span className="text-xs text-gray-500"^>{subject.questions}題 • 60分鐘 • 100分^</span^> >> frontend\src\App.jsx 
echo                   ^<button onClick={^(^) =^> startExam(subject.id^)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm"^>開始考試^</button^> >> frontend\src\App.jsx 
echo                 ^</div^> >> frontend\src\App.jsx 
echo               ^</div^> >> frontend\src\App.jsx 
echo             ^)^)} >> frontend\src\App.jsx 
echo           ^</div^> >> frontend\src\App.jsx 
echo         ^</div^> >> frontend\src\App.jsx 
echo       ^</div^> >> frontend\src\App.jsx 
echo     ^</div^> >> frontend\src\App.jsx 
echo   ^) >> frontend\src\App.jsx 
