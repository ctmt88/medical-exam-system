@echo off
chcp 65001 >nul
echo 正在建立 React 檔案...
echo.

REM 確保在 frontend 資料夾中
if not exist "src" (
    echo 錯誤：找不到 src 資料夾！
    echo 請確保你在 frontend 資料夾中執行此批次檔
    pause
    exit /b 1
)

REM 建立 main.jsx
echo 建立 src/main.jsx...
echo import React from 'react' > src\main.jsx
echo import ReactDOM from 'react-dom/client' >> src\main.jsx
echo import App from './App.jsx' >> src\main.jsx
echo. >> src\main.jsx
echo ReactDOM.createRoot(document.getElementById('root'^)^).render( >> src\main.jsx
echo   ^<React.StrictMode^> >> src\main.jsx
echo     ^<App /^> >> src\main.jsx
echo   ^</React.StrictMode^>, >> src\main.jsx
echo ^) >> src\main.jsx

REM 建立 App.jsx (簡化版本)
echo 建立 src/App.jsx...
echo import React, { useState } from 'react'; > src\App.jsx
echo. >> src\App.jsx
echo function App(^) { >> src\App.jsx
echo   const [showDemo, setShowDemo] = useState(false^); >> src\App.jsx
echo. >> src\App.jsx
echo   return ( >> src\App.jsx
echo     ^<div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"^> >> src\App.jsx
echo       ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo           ^<div className="flex justify-center items-center"^> >> src\App.jsx
echo             ^<h1 className="text-2xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo             ^<span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full"^>展示版^</span^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</nav^> >> src\App.jsx
echo. >> src\App.jsx
echo       ^<main className="max-w-4xl mx-auto py-12 px-4 text-center"^> >> src\App.jsx
echo         ^<h2 className="text-4xl font-bold text-gray-900 mb-4"^> >> src\App.jsx
echo           醫事檢驗師國家考試線上練習系統 >> src\App.jsx
echo         ^</h2^> >> src\App.jsx
echo         ^<p className="text-xl text-gray-600 mb-8"^> >> src\App.jsx
echo           GitHub Pages 展示版本已成功部署！ >> src\App.jsx
echo         ^</p^> >> src\App.jsx
echo. >> src\App.jsx
echo         ^<div className="bg-white rounded-lg shadow-lg p-8 mb-8"^> >> src\App.jsx
echo           ^<h3 className="text-2xl font-semibold mb-4"^>六大考試科目^</h3^> >> src\App.jsx
echo           ^<div className="grid md:grid-cols-2 gap-4"^> >> src\App.jsx
echo             ^<div className="p-4 border rounded-lg"^> >> src\App.jsx
echo               ^<h4 className="font-bold"^>臨床生理學與病理學^</h4^> >> src\App.jsx
echo               ^<p className="text-sm text-gray-600"^>心電圖、肺功能、腦波檢查等^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="p-4 border rounded-lg"^> >> src\App.jsx
echo               ^<h4 className="font-bold"^>臨床血液學與血庫學^</h4^> >> src\App.jsx
echo               ^<p className="text-sm text-gray-600"^>血球計數、凝血功能、血型檢驗等^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="p-4 border rounded-lg"^> >> src\App.jsx
echo               ^<h4 className="font-bold"^>醫學分子檢驗學與臨床鏡檢學^</h4^> >> src\App.jsx
echo               ^<p className="text-sm text-gray-600"^>PCR技術、基因定序、寄生蟲檢驗等^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="p-4 border rounded-lg"^> >> src\App.jsx
echo               ^<h4 className="font-bold"^>微生物學與臨床微生物學^</h4^> >> src\App.jsx
echo               ^<p className="text-sm text-gray-600"^>細菌培養、抗生素敏感性、黴菌檢驗等^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="p-4 border rounded-lg"^> >> src\App.jsx
echo               ^<h4 className="font-bold"^>生物化學與臨床生化學^</h4^> >> src\App.jsx
echo               ^<p className="text-sm text-gray-600"^>肝功能、腎功能、血糖檢驗等^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div className="p-4 border rounded-lg"^> >> src\App.jsx
echo               ^<h4 className="font-bold"^>臨床血清免疫學與臨床病毒學^</h4^> >> src\App.jsx
echo               ^<p className="text-sm text-gray-600"^>腫瘤標記、自體免疫、病毒檢驗等^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo         ^<div className="bg-blue-50 border border-blue-200 rounded-lg p-6"^> >> src\App.jsx
echo           ^<h3 className="text-lg font-semibold mb-2"^>系統特色^</h3^> >> src\App.jsx
echo           ^<ul className="text-left space-y-2"^> >> src\App.jsx
echo             ^<li^>✅ 每科 80 題，限時 60 分鐘^</li^> >> src\App.jsx
echo             ^<li^>✅ 真實考試環境模擬^</li^> >> src\App.jsx
echo             ^<li^>✅ 詳細成績分析^</li^> >> src\App.jsx
echo             ^<li^>✅ 支援圖片題目^</li^> >> src\App.jsx
echo             ^<li^>✅ 答題記錄與複習^</li^> >> src\App.jsx
echo           ^</ul^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</main^> >> src\App.jsx
echo. >> src\App.jsx
echo       ^<footer className="bg-gray-800 text-white py-8 text-center"^> >> src\App.jsx
echo         ^<p^>醫事檢驗師考試練習系統 - 學術教育用途^</p^> >> src\App.jsx
echo       ^</footer^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ^); >> src\App.jsx
echo } >> src\App.jsx
echo. >> src\App.jsx
echo export default App; >> src\App.jsx

echo.
echo ✅ React 檔案建立完成！
echo.
echo 檔案清單：
echo - src/main.jsx
echo - src/App.jsx
echo.
echo 現在可以執行：
echo npm install
echo npm run build
echo.
pause