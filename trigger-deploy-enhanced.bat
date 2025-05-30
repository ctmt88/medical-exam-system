@echo off
chcp 65001 >nul
echo =========================================
echo 🚀 自動部署腳本開始
echo =========================================

REM === 檢查是否為 Git 倉庫 ===
if not exist ".git" (
    echo ❌ 錯誤：此資料夾不是 Git 倉庫，請先 git init 與 remote 設定。
    pause
    exit /b 1
)

REM === 更新 README.md 作為觸發 ===
echo 🔄 更新 README.md...
echo. >> README.md
echo ## 🚀 部署狀態 >> README.md
echo - 最後更新: %date% %time% >> README.md
echo - 狀態: 重新部署中... >> README.md
echo - 網址: [https://ctmt88.github.io/medical-exam-system/](https://ctmt88.github.io/medical-exam-system/) >> README.md
echo ✅ README.md 已更新

REM === 檢查必要檔案 ===
if not exist ".github\workflows\deploy.yml" (
    echo ❌ 錯誤：找不到 .github\workflows\deploy.yml
    pause
    exit /b 1
)

REM === 建置前端（如未存在 dist） ===
if not exist "frontend\dist" (
    echo ⚙️ 未偵測到 dist 資料夾，開始建置...
    cd frontend
    npm run build
    cd ..
    echo ✅ 建置完成
)

REM === Git Commit 與 Push ===
echo 📝 Git Commit + Push 中...
git add .
git commit -m "📦 自動部署：更新 README.md 以觸發 GitHub Actions"
git push origin main

if %ERRORLEVEL% NEQ 0 (
    echo ❌ 推送失敗！請確認網路與 GitHub 權限設定
    pause
    exit /b 1
)

echo ✅ 成功推送至 GitHub，開始部署流程！

REM === 自動開啟 GitHub 頁面 ===
echo 🌐 開啟部署頁面...
start https://ctmt88.github.io/medical-exam-system/

echo =========================================
echo 🎉 完成！GitHub Pages 部署應在幾分鐘後更新
echo =========================================
pause
