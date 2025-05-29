@echo off
chcp 65001 >nul
echo 正在建立前端設定檔案...
echo.

REM 確保在正確的目錄
if not exist "frontend" (
    echo 錯誤：找不到 frontend 資料夾！
    echo 請確保你在 medical-exam-system 資料夾中執行此批次檔
    pause
    exit /b 1
)

REM 切換到 frontend 資料夾
cd frontend

REM 建立 vite.config.js
echo 建立 vite.config.js...
echo import { defineConfig } from 'vite' > vite.config.js
echo import react from '@vitejs/plugin-react' >> vite.config.js
echo. >> vite.config.js
echo export default defineConfig({ >> vite.config.js
echo   plugins: [react()], >> vite.config.js
echo   base: '/medical-exam-system/', >> vite.config.js
echo   build: { >> vite.config.js
echo     outDir: 'dist' >> vite.config.js
echo   } >> vite.config.js
echo }) >> vite.config.js

REM 建立 public 資料夾（如果不存在）
if not exist "public" mkdir public

REM 建立 public/index.html
echo 建立 public/index.html...
echo ^<!DOCTYPE html^> > public\index.html
echo ^<html lang="zh-TW"^> >> public\index.html
echo ^<head^> >> public\index.html
echo   ^<meta charset="UTF-8"^> >> public\index.html
echo   ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> public\index.html
echo   ^<title^>醫檢師考試系統^</title^> >> public\index.html
echo   ^<script src="https://cdn.tailwindcss.com"^>^</script^> >> public\index.html
echo ^</head^> >> public\index.html
echo ^<body^> >> public\index.html
echo   ^<div id="root"^>^</div^> >> public\index.html
echo   ^<script type="module" src="/src/main.jsx"^>^</script^> >> public\index.html
echo ^</body^> >> public\index.html
echo ^</html^> >> public\index.html

REM 建立 src 資料夾（如果不存在）
if not exist "src" mkdir src

echo.
echo ✅ 前端設定檔案建立完成！
echo.
echo 檔案清單：
echo - vite.config.js
echo - public/index.html
echo.
echo 接下來請手動建立以下兩個檔案：
echo 1. frontend\src\main.jsx
echo 2. frontend\src\App.jsx
echo.
echo 或者執行下一個批次檔來建立這些檔案
echo.
pause