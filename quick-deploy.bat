@echo off
chcp 65001 >nul
echo ====================================
echo 快速重新部署到 GitHub Pages
echo ====================================
echo.

REM 確保在專案根目錄
if not exist "frontend\src\App.jsx" (
    echo ❌ 錯誤：請在專案根目錄執行
    pause
    exit /b 1
)

echo ✅ 檢查前端建置...
cd frontend
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 前端建置成功
    cd ..
) else (
    echo ❌ 前端建置失敗，請檢查錯誤
    cd ..
    pause
    exit /b 1
)

echo.
echo 📤 提交更改到 GitHub...
git add .
git status
echo.

echo 提交訊息：更新互動功能
git commit -m "Update frontend with interactive exam features - login, dashboard, exam interface"

echo.
echo 🚀 推送到 GitHub...
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 部署成功！
    echo.
    echo 📋 部署狀態：
    echo ✅ 代碼已推送到 GitHub
    echo ✅ GitHub Actions 將自動開始建置
    echo ✅ 約 2-3 分鐘後網站會更新
    echo.
    echo 🌐 你的網站：https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 📱 接下來請：
    echo 1. 等待 2-3 分鐘
    echo 2. 重新整理網站頁面
    echo 3. 應該會看到新的互動功能
    echo 4. 嘗試使用 DEMO001/demo123 登入
    echo.
    echo 🔍 如果網站沒更新：
    echo 1. 檢查 GitHub Actions 是否執行成功
    echo 2. 清除瀏覽器快取 ^(Ctrl+F5^)
    echo 3. 等待更長時間 ^(最多10分鐘^)
) else (
    echo ❌ 推送失敗
    echo 請檢查網路連線或 Git 設定
)

echo.
echo ====================================
echo 重新部署完成
echo ====================================
pause