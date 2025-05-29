@echo off
chcp 65001 >nul
echo ====================================
echo 醫檢師考試系統 - 檔案檢查工具
echo ====================================
echo.

REM 檢查目前位置
echo 🔍 當前位置檢查：
cd
echo.

REM 檢查是否在 frontend 資料夾
if exist "package.json" (
    echo ✅ 在 frontend 資料夾中
) else (
    echo ❌ 不在 frontend 資料夾中
    echo 請切換到 frontend 資料夾執行此檢查
    pause
    exit /b 1
)
echo.

REM 檢查必要檔案
echo 📁 檔案存在性檢查：
if exist "package.json" (
    echo ✅ package.json 存在
) else (
    echo ❌ package.json 不存在
)

if exist "vite.config.js" (
    echo ✅ vite.config.js 存在
) else (
    echo ❌ vite.config.js 不存在
)

if exist "public\index.html" (
    echo ✅ public\index.html 存在
) else (
    echo ❌ public\index.html 不存在
)

if exist "src\main.jsx" (
    echo ✅ src\main.jsx 存在
) else (
    echo ❌ src\main.jsx 不存在
)

if exist "src\App.jsx" (
    echo ✅ src\App.jsx 存在
) else (
    echo ❌ src\App.jsx 不存在
)
echo.

REM 檢查檔案內容
echo 📄 檔案內容檢查：
echo.
echo --- package.json 內容 ---
type package.json 2>nul
echo.
echo.

echo --- vite.config.js 內容 ---
type vite.config.js 2>nul
echo.
echo.

echo --- public\index.html 前10行 ---
for /f "skip=0 tokens=*" %%i in ('type "public\index.html" 2^>nul ^| findstr /n ".*"') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    if "!line:~0,2!" leq "10" echo !line!
    endlocal
)
echo.
echo.

echo --- src\main.jsx 內容 ---
type src\main.jsx 2>nul
echo.
echo.

echo --- src\App.jsx 前15行 ---
for /f "skip=0 tokens=*" %%i in ('type "src\App.jsx" 2^>nul ^| findstr /n ".*"') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    if "!line:~0,2!" leq "15" echo !line!
    endlocal
)
echo.

REM 檢查 node_modules
echo 📦 依賴套件檢查：
if exist "node_modules" (
    echo ✅ node_modules 資料夾存在
    echo 套件數量：
    dir node_modules | find /c "<DIR>"
) else (
    echo ❌ node_modules 資料夾不存在 - 需要執行 npm install
)
echo.

REM 檢查重要套件
echo 🔧 重要套件檢查：
if exist "node_modules\react" (
    echo ✅ React 已安裝
) else (
    echo ❌ React 未安裝
)

if exist "node_modules\vite" (
    echo ✅ Vite 已安裝
) else (
    echo ❌ Vite 未安裝
)

if exist "node_modules\@vitejs\plugin-react" (
    echo ✅ Vite React Plugin 已安裝
) else (
    echo ❌ Vite React Plugin 未安裝
)
echo.

REM 建議修復步驟
echo 🔧 建議修復步驟：
echo 1. 如果 node_modules 不存在：執行 npm install
echo 2. 如果套件不完整：執行 npm install --force
echo 3. 如果檔案內容有問題：重新建立該檔案
echo 4. 如果還是失敗：刪除 node_modules 和 package-lock.json 重新安裝
echo.

REM 快速修復選項
echo 🚀 要執行快速修復嗎？ (Y/N)
set /p choice="請選擇: "
if /i "%choice%"=="Y" (
    echo.
    echo 正在執行快速修復...
    echo 刪除舊的安裝...
    if exist "node_modules" rmdir /s /q node_modules
    if exist "package-lock.json" del package-lock.json
    echo.
    echo 重新安裝套件...
    npm install
    echo.
    echo 嘗試建置...
    npm run build
) else (
    echo 跳過快速修復
)

echo.
echo ====================================
echo 檢查完成！
echo ====================================
pause