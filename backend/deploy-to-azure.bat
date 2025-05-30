@echo off 
echo 🚀 開始部署到 Azure... 
echo. 
echo 📦 安裝相依套件... 
npm install 
if errorlevel 1 ( 
  echo ❌ npm install 失敗 
  pause 
  exit /b 1 
) 
 
echo 🗃️ 初始化資料庫... 
node -e "const sqlite3=require('sqlite3'); const fs=require('fs'); const db=new sqlite3.Database('./database/exam_system.db'); const schema=fs.readFileSync('./database/schema.sql','utf8'); db.exec(schema,(err)=^>{if(err) console.error(err); else console.log('✅ 資料庫初始化完成'); db.close();});" 
 
echo 🧪 本地測試服務器... 
echo 請開啟新的命令提示字元視窗執行: npm start 
echo 然後訪問: http://localhost:8000 
echo. 
echo 📋 Azure CLI 部署指令: 
echo. 
echo az login 
echo az group create --name ctmt88_group --location "East Asia" 
echo az appservice plan create --name ctmt88-plan --resource-group ctmt88_group --sku F1 --is-linux 
echo az webapp create --resource-group ctmt88_group --plan ctmt88-plan --name ctmt88 --runtime "NODE:18-lts" 
echo az webapp config appsettings set --resource-group ctmt88_group --name ctmt88 --settings NODE_ENV=production JWT_SECRET=your-secret CORS_ORIGIN=https://ctmt88.github.io 
echo az webapp deployment source config-zip --resource-group ctmt88_group --name ctmt88 --src deployment.zip 
echo. 
pause 
