@echo off
echo 正在建立 GitHub Actions 部署設定...
echo.

REM 回到專案根目錄
cd ..

REM 建立完整的 GitHub Actions 工作流程
echo 建立 .github\workflows\deploy.yml...
(
echo name: Deploy to GitHub Pages
echo.
echo on:
echo   push:
echo     branches: [ main ]
echo   pull_request:
echo     branches: [ main ]
echo.
echo jobs:
echo   build-and-deploy:
echo     runs-on: ubuntu-latest
echo     
echo     steps:
echo     - name: Checkout 🛎️
echo       uses: actions/checkout@v4
echo       
echo     - name: Setup Node.js 🔧
echo       uses: actions/setup-node@v4
echo       with:
echo         node-version: '18'
echo         cache: 'npm'
echo         cache-dependency-path: frontend/package-lock.json
echo         
echo     - name: Install dependencies 📦
echo       run: ^|
echo         cd frontend
echo         npm ci
echo         
echo     - name: Build 🔨
echo       run: ^|
echo         cd frontend
echo         npm run build
echo         
echo     - name: Deploy to GitHub Pages 🚀
echo       uses: peaceiris/actions-gh-pages@v3
echo       if: github.ref == 'refs/heads/main'
echo       with:
echo         github_token: ${{ secrets.GITHUB_TOKEN }}
echo         publish_dir: ./frontend/dist
) > .github\workflows\deploy.yml

REM 建立根目錄的 package.json
echo 建立根目錄 package.json...
(
echo {
echo   "name": "medical-exam-system",
echo   "version": "1.0.0",
echo   "scripts": {
echo     "build": "cd frontend && npm install && npm run build",
echo     "start": "cd backend && npm install && npm start"
echo   },
echo   "engines": {
echo     "node": "^>=18.0.0"
echo   }
echo }
) > package.json

echo.
echo ✅ GitHub Actions 設定檔案建立完成！
echo.
pause