@echo off
echo 修正 package.json...

del package.json

echo {> package.json
echo   "name": "medical-exam-frontend",>> package.json
echo   "version": "1.0.0",>> package.json
echo   "type": "module",>> package.json
echo   "scripts": {>> package.json
echo     "dev": "vite",>> package.json
echo     "build": "vite build",>> package.json
echo     "preview": "vite preview">> package.json
echo   },>> package.json
echo   "dependencies": {>> package.json
echo     "react": "^18.2.0",>> package.json
echo     "react-dom": "^18.2.0">> package.json
echo   },>> package.json
echo   "devDependencies": {>> package.json
echo     "@vitejs/plugin-react": "^4.2.1",>> package.json
echo     "vite": "^5.0.8">> package.json
echo   }>> package.json
echo }>> package.json

echo 重新安裝套件...
npm install

echo 建置專案...
npm run build

pause