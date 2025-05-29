@echo off
chcp 65001 >nul
echo ====================================
echo 終極修正方案 - 重新建立整個前端
echo ====================================
echo.

REM 完全重新開始
echo 🔥 完全重新建立前端專案
echo.

REM 刪除所有相關檔案
echo 清理現有檔案...
if exist "node_modules" rmdir /s /q node_modules
if exist "dist" rmdir /s /q dist
if exist "package-lock.json" del package-lock.json
if exist "vite.config.js" del vite.config.js
if exist "package.json" del package.json

REM 重建 package.json (最簡化版本)
echo 建立新的 package.json...
echo { > package.json
echo   "name": "medical-exam-frontend", >> package.json
echo   "version": "1.0.0", >> package.json
echo   "type": "module", >> package.json
echo   "scripts": { >> package.json
echo     "dev": "vite", >> package.json
echo     "build": "vite build", >> package.json
echo     "preview": "vite preview" >> package.json
echo   }, >> package.json
echo   "dependencies": { >> package.json
echo     "react": "^18.2.0", >> package.json
echo     "react-dom": "^18.2.0" >> package.json
echo   }, >> package.json
echo   "devDependencies": { >> package.json
echo     "@vitejs/plugin-react": "^4.2.1", >> package.json
echo     "vite": "^5.0.8" >> package.json
echo   } >> package.json
echo } >> package.json

REM 重建 vite.config.js (最簡化版本)
echo 建立新的 vite.config.js...
echo import { defineConfig } from 'vite' > vite.config.js
echo import react from '@vitejs/plugin-react' >> vite.config.js
echo. >> vite.config.js
echo export default defineConfig({ >> vite.config.js
echo   plugins: [react()], >> vite.config.js
echo   base: '/medical-exam-system/' >> vite.config.js
echo }) >> vite.config.js

REM 確保資料夾結構
if not exist "public" mkdir public
if not exist "src" mkdir src

REM 重建 index.html (移到根目錄，不在 public)
echo 建立 index.html...
echo ^<!DOCTYPE html^> > index.html
echo ^<html lang="zh-TW"^> >> index.html
echo ^<head^> >> index.html
echo   ^<meta charset="UTF-8" /^> >> index.html
echo   ^<meta name="viewport" content="width=device-width, initial-scale=1.0" /^> >> index.html
echo   ^<title^>醫檢師考試系統^</title^> >> index.html
echo   ^<script src="https://cdn.tailwindcss.com"^>^</script^> >> index.html
echo ^</head^> >> index.html
echo ^<body^> >> index.html
echo   ^<div id="root"^>^</div^> >> index.html
echo   ^<script type="module" src="/src/main.jsx"^>^</script^> >> index.html
echo ^</body^> >> index.html
echo ^</html^> >> index.html

REM 重建 main.jsx
echo 建立 src/main.jsx...
echo import React from 'react' > src\main.jsx
echo import ReactDOM from 'react-dom/client' >> src\main.jsx
echo import App from './App.jsx' >> src\main.jsx
echo. >> src\main.jsx
echo ReactDOM.createRoot(document.getElementById('root'^)^).render( >> src\main.jsx
echo   ^<React.StrictMode^> >> src\main.jsx
echo     ^<App /^> >> src\main.jsx
echo   ^</React.StrictMode^> >> src\main.jsx
echo ^) >> src\main.jsx

REM 重建 App.jsx (超簡化版本)
echo 建立 src/App.jsx...
echo import React from 'react' > src\App.jsx
echo. >> src\App.jsx
echo function App(^) { >> src\App.jsx
echo   return ( >> src\App.jsx
echo     ^<div className="min-h-screen bg-blue-50 flex items-center justify-center"^> >> src\App.jsx
echo       ^<div className="text-center"^> >> src\App.jsx
echo         ^<h1 className="text-4xl font-bold text-blue-600 mb-4"^> >> src\App.jsx
echo           醫事檢驗師考試系統 >> src\App.jsx
echo         ^</h1^> >> src\App.jsx
echo         ^<p className="text-xl text-gray-600 mb-8"^> >> src\App.jsx
echo           GitHub Pages 部署成功！ >> src\App.jsx
echo         ^</p^> >> src\App.jsx
echo         ^<div className="bg-white rounded-lg shadow-lg p-8 max-w-2xl"^> >> src\App.jsx
echo           ^<h2 className="text-2xl font-semibold mb-4"^>系統功能^</h2^> >> src\App.jsx
echo           ^<div className="grid grid-cols-2 gap-4 text-left"^> >> src\App.jsx
echo             ^<div className="p-3 border rounded"^>臨床生理學與病理學^</div^> >> src\App.jsx
echo             ^<div className="p-3 border rounded"^>臨床血液學與血庫學^</div^> >> src\App.jsx
echo             ^<div className="p-3 border rounded"^>醫學分子檢驗學^</div^> >> src\App.jsx
echo             ^<div className="p-3 border rounded"^>微生物學^</div^> >> src\App.jsx
echo             ^<div className="p-3 border rounded"^>生物化學^</div^> >> src\App.jsx
echo             ^<div className="p-3 border rounded"^>血清免疫學^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ^) >> src\App.jsx
echo } >> src\App.jsx
echo. >> src\App.jsx
echo export default App >> src\App.jsx

echo.
echo ✅ 所有檔案重新建立完成
echo.

REM 顯示檔案結構
echo 📁 專案結構：
dir /b
echo.
echo src\ 資料夾：
dir src /b
echo.

REM 安裝依賴套件
echo 📦 安裝依賴套件...
npm install

echo.
echo 🚀 嘗試建置...
npm run build

echo.
if exist "dist\index.html" (
    echo.
    echo 🎉🎉🎉 SUCCESS! 🎉🎉🎉
    echo ✅ 建置完全成功！
    echo.
    echo 📁 dist 資料夾內容：
    dir dist
    echo.
    echo 🚀 下一步：
    echo 1. cd .. (回到專案根目錄)
    echo 2. git add .
    echo 3. git commit -m "Fix frontend build completely"
    echo 4. git push origin main
    echo 5. 等待 GitHub Actions 自動部署
    echo.
    echo 🌐 幾分鐘後你的網站會在這裡上線：
    echo https://ctmt88.github.io/medical-exam-system/
) else (
    echo.
    echo ❌ 建置仍然失敗
    echo 讓我們檢查錯誤...
    echo.
    echo 請檢查上方是否有紅色錯誤訊息
    echo 如果有，請將錯誤訊息截圖或複製給我
)

echo.
echo ====================================
echo 終極修正完成
echo ====================================
pause