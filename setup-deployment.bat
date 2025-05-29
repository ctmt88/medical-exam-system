@echo off
chcp 65001 >nul
echo ====================================
echo 設定 GitHub Actions 自動部署
echo ====================================
echo.

REM 確保在專案根目錄
if not exist "frontend" (
    echo ❌ 錯誤：請在 medical-exam-system 根目錄執行此批次檔
    echo 目前位置：
    cd
    pause
    exit /b 1
)

echo ✅ 在正確的專案根目錄
echo.

REM 建立 .github 目錄結構
echo 📁 建立 .github 目錄結構...
if not exist ".github" mkdir .github
if not exist ".github\workflows" mkdir .github\workflows

echo ✅ 目錄結構建立完成
echo.

REM 建立 GitHub Actions 工作流程檔案
echo 📝 建立 GitHub Actions 工作流程...
echo name: Deploy to GitHub Pages > .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo on: >> .github\workflows\deploy.yml
echo   push: >> .github\workflows\deploy.yml
echo     branches: [ main ] >> .github\workflows\deploy.yml
echo   workflow_dispatch: >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo permissions: >> .github\workflows\deploy.yml
echo   contents: read >> .github\workflows\deploy.yml
echo   pages: write >> .github\workflows\deploy.yml
echo   id-token: write >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo concurrency: >> .github\workflows\deploy.yml
echo   group: "pages" >> .github\workflows\deploy.yml
echo   cancel-in-progress: false >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo jobs: >> .github\workflows\deploy.yml
echo   build: >> .github\workflows\deploy.yml
echo     runs-on: ubuntu-latest >> .github\workflows\deploy.yml
echo     steps: >> .github\workflows\deploy.yml
echo     - name: Checkout >> .github\workflows\deploy.yml
echo       uses: actions/checkout@v4 >> .github\workflows\deploy.yml
echo       >> .github\workflows\deploy.yml
echo     - name: Setup Node.js >> .github\workflows\deploy.yml
echo       uses: actions/setup-node@v4 >> .github\workflows\deploy.yml
echo       with: >> .github\workflows\deploy.yml
echo         node-version: '18' >> .github\workflows\deploy.yml
echo         cache: 'npm' >> .github\workflows\deploy.yml
echo         cache-dependency-path: frontend/package-lock.json >> .github\workflows\deploy.yml
echo         >> .github\workflows\deploy.yml
echo     - name: Install dependencies >> .github\workflows\deploy.yml
echo       run: ^| >> .github\workflows\deploy.yml
echo         cd frontend >> .github\workflows\deploy.yml
echo         npm ci >> .github\workflows\deploy.yml
echo         >> .github\workflows\deploy.yml
echo     - name: Build >> .github\workflows\deploy.yml
echo       run: ^| >> .github\workflows\deploy.yml
echo         cd frontend >> .github\workflows\deploy.yml
echo         npm run build >> .github\workflows\deploy.yml
echo         >> .github\workflows\deploy.yml
echo     - name: Setup Pages >> .github\workflows\deploy.yml
echo       uses: actions/configure-pages@v4 >> .github\workflows\deploy.yml
echo       >> .github\workflows\deploy.yml
echo     - name: Upload artifact >> .github\workflows\deploy.yml
echo       uses: actions/upload-pages-artifact@v3 >> .github\workflows\deploy.yml
echo       with: >> .github\workflows\deploy.yml
echo         path: './frontend/dist' >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo   deploy: >> .github\workflows\deploy.yml
echo     environment: >> .github\workflows\deploy.yml
echo       name: github-pages >> .github\workflows\deploy.yml
echo       url: ${{ steps.deployment.outputs.page_url }} >> .github\workflows\deploy.yml
echo     runs-on: ubuntu-latest >> .github\workflows\deploy.yml
echo     needs: build >> .github\workflows\deploy.yml
echo     steps: >> .github\workflows\deploy.yml
echo     - name: Deploy to GitHub Pages >> .github\workflows\deploy.yml
echo       id: deployment >> .github\workflows\deploy.yml
echo       uses: actions/deploy-pages@v4 >> .github\workflows\deploy.yml

echo ✅ GitHub Actions 工作流程檔案建立完成
echo.

REM 建立根目錄的 package.json (如果不存在)
if not exist "package.json" (
    echo 📝 建立根目錄 package.json...
    echo { > package.json
    echo   "name": "medical-exam-system", >> package.json
    echo   "version": "1.0.0", >> package.json
    echo   "description": "醫事檢驗師考試練習系統", >> package.json
    echo   "scripts": { >> package.json
    echo     "build": "cd frontend && npm install && npm run build", >> package.json
    echo     "dev": "cd frontend && npm run dev" >> package.json
    echo   }, >> package.json
    echo   "keywords": ["medical", "exam", "system"], >> package.json
    echo   "author": "ctmt88", >> package.json
    echo   "license": "MIT" >> package.json
    echo } >> package.json
    echo ✅ 根目錄 package.json 建立完成
)
echo.

REM 建立 README.md (如果不存在)
if not exist "README.md" (
    echo 📝 建立 README.md...
    echo # 醫事檢驗師考試練習系統 > README.md
    echo. >> README.md
    echo 這是一個專為醫事檢驗師國家考試設計的線上練習系統。 >> README.md
    echo. >> README.md
    echo ## 功能特色 >> README.md
    echo. >> README.md
    echo - 六大考試科目完整涵蓋 >> README.md
    echo - 每科 80 題，限時 60 分鐘 >> README.md
    echo - 真實考試環境模擬 >> README.md
    echo - 詳細成績統計分析 >> README.md
    echo - 支援圖片題目顯示 >> README.md
    echo. >> README.md
    echo ## 線上展示 >> README.md
    echo. >> README.md
    echo 🌐 [https://ctmt88.github.io/medical-exam-system/](https://ctmt88.github.io/medical-exam-system/^) >> README.md
    echo. >> README.md
    echo ## 技術架構 >> README.md
    echo. >> README.md
    echo - 前端：React + Vite + Tailwind CSS >> README.md
    echo - 部署：GitHub Pages + GitHub Actions >> README.md
    echo. >> README.md
    echo ✅ README.md 建立完成
)
echo.

REM 檢查檔案結構
echo 📁 檢查最終檔案結構...
echo.
echo 專案根目錄：
dir /b
echo.
echo .github\workflows\ 目錄：
dir .github\workflows /b
echo.
echo frontend\ 目錄：
dir frontend /b
echo.

REM 提交所有更改
echo 🚀 提交更改到 GitHub...
git add .
git status

echo.
echo 準備提交...
git commit -m "Add GitHub Actions workflow for automatic deployment to GitHub Pages"

echo.
echo 推送到 GitHub...
git push origin main

echo.
if %ERRORLEVEL% EQU 0 (
    echo 🎉 成功！GitHub Actions 工作流程已設定完成
    echo.
    echo 📋 接下來會發生什麼：
    echo 1. GitHub 會自動偵測到新的工作流程
    echo 2. 開始執行自動建置和部署
    echo 3. 幾分鐘後你的網站就會上線
    echo.
    echo 🌐 網站網址：https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 📱 請檢查：
    echo 1. 前往 GitHub repository 的 Actions 頁面
    echo 2. 應該會看到工作流程正在執行
    echo 3. 等待完成後訪問網站
    echo.
    echo 🎯 如果 Actions 頁面還是空白，請：
    echo 1. 重新整理頁面
    echo 2. 檢查 Settings ^> Pages 是否設為 "GitHub Actions"
) else (
    echo ❌ 推送失敗，請檢查錯誤訊息
)

echo.
echo ====================================
echo GitHub Actions 設定完成
echo ====================================
pause