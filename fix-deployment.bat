@echo off
chcp 65001 >nul
echo ====================================
echo 修正 GitHub Actions 權限問題
echo ====================================
echo.

REM 確保在專案根目錄
if not exist ".github\workflows" (
    echo ❌ 錯誤：找不到 .github\workflows 目錄
    echo 請確保在專案根目錄執行
    pause
    exit /b 1
)

echo ✅ 在正確的專案根目錄
echo.

REM 重新建立工作流程檔案，修正權限問題
echo 🔧 重新建立 GitHub Actions 工作流程 (修正版)...

echo name: Deploy to GitHub Pages > .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo on: >> .github\workflows\deploy.yml
echo   push: >> .github\workflows\deploy.yml
echo     branches: [ main ] >> .github\workflows\deploy.yml
echo   workflow_dispatch: >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo # 設定必要的權限 >> .github\workflows\deploy.yml
echo permissions: >> .github\workflows\deploy.yml
echo   contents: read >> .github\workflows\deploy.yml
echo   pages: write >> .github\workflows\deploy.yml
echo   id-token: write >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo # 確保同時只有一個部署在進行 >> .github\workflows\deploy.yml
echo concurrency: >> .github\workflows\deploy.yml
echo   group: "pages" >> .github\workflows\deploy.yml
echo   cancel-in-progress: false >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo jobs: >> .github\workflows\deploy.yml
echo   # 建置工作 >> .github\workflows\deploy.yml
echo   build: >> .github\workflows\deploy.yml
echo     runs-on: ubuntu-latest >> .github\workflows\deploy.yml
echo     steps: >> .github\workflows\deploy.yml
echo     - name: 📥 Checkout repository >> .github\workflows\deploy.yml
echo       uses: actions/checkout@v4 >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo     - name: 🔧 Setup Node.js >> .github\workflows\deploy.yml
echo       uses: actions/setup-node@v4 >> .github\workflows\deploy.yml
echo       with: >> .github\workflows\deploy.yml
echo         node-version: '18' >> .github\workflows\deploy.yml
echo         cache: 'npm' >> .github\workflows\deploy.yml
echo         cache-dependency-path: frontend/package-lock.json >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo     - name: 📦 Install dependencies >> .github\workflows\deploy.yml
echo       working-directory: ./frontend >> .github\workflows\deploy.yml
echo       run: npm ci >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo     - name: 🏗️ Build project >> .github\workflows\deploy.yml
echo       working-directory: ./frontend >> .github\workflows\deploy.yml
echo       run: npm run build >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo     - name: 📄 Setup Pages >> .github\workflows\deploy.yml
echo       uses: actions/configure-pages@v4 >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo     - name: 📤 Upload artifact >> .github\workflows\deploy.yml
echo       uses: actions/upload-pages-artifact@v3 >> .github\workflows\deploy.yml
echo       with: >> .github\workflows\deploy.yml
echo         path: ./frontend/dist >> .github\workflows\deploy.yml
echo. >> .github\workflows\deploy.yml
echo   # 部署工作 >> .github\workflows\deploy.yml
echo   deploy: >> .github\workflows\deploy.yml
echo     environment: >> .github\workflows\deploy.yml
echo       name: github-pages >> .github\workflows\deploy.yml
echo       url: ${{ steps.deployment.outputs.page_url }} >> .github\workflows\deploy.yml
echo     runs-on: ubuntu-latest >> .github\workflows\deploy.yml
echo     needs: build >> .github\workflows\deploy.yml
echo     steps: >> .github\workflows\deploy.yml
echo     - name: 🚀 Deploy to GitHub Pages >> .github\workflows\deploy.yml
echo       id: deployment >> .github\workflows\deploy.yml
echo       uses: actions/deploy-pages@v4 >> .github\workflows\deploy.yml

echo ✅ 修正版工作流程檔案建立完成
echo.

REM 檢查 frontend 目錄中是否有 package-lock.json
echo 🔍 檢查 package-lock.json...
if exist "frontend\package-lock.json" (
    echo ✅ package-lock.json 存在
) else (
    echo ⚠️ package-lock.json 不存在，建立中...
    cd frontend
    npm install
    cd ..
    echo ✅ package-lock.json 已建立
)
echo.

REM 測試本地建置是否正常
echo 🧪 測試本地建置...
cd frontend
echo 測試建置...
npm run build
set BUILD_RESULT=%ERRORLEVEL%
cd ..

if %BUILD_RESULT% EQU 0 (
    echo ✅ 本地建置成功
) else (
    echo ❌ 本地建置失敗，請檢查錯誤
    pause
    exit /b 1
)
echo.

REM 建立簡單的測試文件來確保結構正確
echo 📝 建立測試文件...
echo # Test File > test.md
echo This file ensures the repository structure is correct. >> test.md
echo Created: %date% %time% >> test.md

echo ✅ 測試文件建立完成
echo.

REM 提交修正
echo 🚀 提交修正到 GitHub...
git add .
git commit -m "Fix GitHub Actions workflow permissions and configuration"
git push origin main

echo.
if %ERRORLEVEL% EQU 0 (
    echo 🎉 修正完成並已推送到 GitHub！
    echo.
    echo 📋 修正內容：
    echo ✅ 修正了權限設定
    echo ✅ 使用 working-directory 避免路徑問題
    echo ✅ 確保 package-lock.json 存在
    echo ✅ 本地測試建置成功
    echo.
    echo 🌐 接下來會發生什麼：
    echo 1. GitHub Actions 會自動重新執行
    echo 2. 建置應該會成功 (約 2-3 分鐘)
    echo 3. 網站會自動部署到：https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 📱 請檢查：
    echo 1. 回到 GitHub Actions 頁面
    echo 2. 應該會看到新的工作流程正在執行
    echo 3. 等待綠色 ✅ 完成標誌
    echo.
    echo 🎯 如果還是失敗，問題可能是：
    echo 1. GitHub Pages 權限未啟用
    echo 2. Repository 設定問題
    echo 請截圖錯誤訊息給我看
) else (
    echo ❌ 推送失敗
    echo 請檢查網路連線或 Git 設定
)

echo.
echo ====================================
echo 權限修正完成
echo ====================================
pause