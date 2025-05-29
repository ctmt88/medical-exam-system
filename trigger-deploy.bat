@echo off
chcp 65001 >nul
echo ====================================
echo 觸發新的 GitHub Actions 部署
echo ====================================
echo.

REM 確保在專案根目錄
if not exist ".github\workflows\deploy.yml" (
    echo ❌ 錯誤：找不到部署檔案
    echo 請確保在專案根目錄執行
    pause
    exit /b 1
)

echo ✅ 在正確的專案根目錄
echo.

REM 做一個小修改來觸發新的部署
echo 🔄 更新 README.md 來觸發新部署...
echo. >> README.md
echo ## 🚀 部署狀態 >> README.md
echo. >> README.md
echo - 最後更新: %date% %time% >> README.md
echo - 狀態: 重新部署中... >> README.md
echo - 網址: [https://ctmt88.github.io/medical-exam-system/](https://ctmt88.github.io/medical-exam-system/) >> README.md

echo ✅ README.md 已更新
echo.

REM 同時檢查工作流程檔案是否正確
echo 🔍 檢查工作流程檔案...
if exist ".github\workflows\deploy.yml" (
    echo ✅ deploy.yml 存在
    echo 檔案大小:
    dir .github\workflows\deploy.yml | find "deploy.yml"
) else (
    echo ❌ deploy.yml 不存在
)
echo.

REM 檢查前端檔案
echo 🔍 檢查前端檔案...
if exist "frontend\package.json" (
    echo ✅ frontend/package.json 存在
) else (
    echo ❌ frontend/package.json 不存在
)

if exist "frontend\dist" (
    echo ✅ frontend/dist 資料夾存在
    echo dist 內容:
    dir frontend\dist /b
) else (
    echo ⚠️ frontend/dist 資料夾不存在，先建置一次...
    cd frontend
    npm run build
    cd ..
)
echo.

REM 提交更改來觸發新部署
echo 🚀 提交更改來觸發新部署...
git add .
git commit -m "Trigger new deployment - update README with deployment status"
git push origin main

echo.
if %ERRORLEVEL% EQU 0 (
    echo 🎉 成功觸發新部署！
    echo.
    echo 📋 剛才做了什麼：
    echo ✅ 更新了 README.md
    echo ✅ 提交並推送到 GitHub
    echo ✅ 這會觸發新的 GitHub Actions 執行
    echo.
    echo 🌐 接下來會發生什麼：
    echo 1. GitHub 偵測到新的 commit
    echo 2. 自動執行新的工作流程
    echo 3. 你會在 Actions 頁面看到新的執行記錄
    echo 4. 約 2-3 分鐘後完成部署
    echo.
    echo 📱 請現在：
    echo 1. 重新整理 GitHub Actions 頁面
    echo 2. 應該會看到新的工作流程 "Trigger new deployment"
    echo 3. 點進去查看執行狀況
    echo.
    echo 💡 小提示：
    echo - 如果還是看不到新的執行，等 1-2 分鐘再重新整理
    echo - GitHub 有時候需要一點時間來偵測變更
) else (
    echo ❌ 推送失敗
    echo 可能的原因：
    echo 1. 網路連線問題
    echo 2. Git 認證問題
    echo 3. Repository 權限問題
)

echo.
echo 🎯 如果新部署還是失敗：
echo 1. 點擊 Actions 中的失敗項目
echo 2. 查看詳細錯誤訊息
echo 3. 截圖給我看，我會幫你修正
echo.

echo ====================================
echo 新部署觸發完成
echo ====================================
pause