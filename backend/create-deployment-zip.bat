@echo off 
echo 📦 建立部署包... 
if exist deployment.zip del deployment.zip 
powershell Compress-Archive -Path server.js,package.json,database,web.config,.env.example -DestinationPath deployment.zip -Force 
echo ✅ deployment.zip 建立成功 
echo. 
echo 📋 接下來請執行: 
echo 1. az login (登入 Azure) 
echo 2. az group create --name ctmt88_group --location "East Asia" 
echo 3. az appservice plan create --name ctmt88-plan --resource-group ctmt88_group --sku F1 --is-linux 
echo 4. az webapp create --resource-group ctmt88_group --plan ctmt88-plan --name ctmt88 --runtime "NODE:18-lts" 
echo 5. az webapp config appsettings set --resource-group ctmt88_group --name ctmt88 --settings NODE_ENV=production JWT_SECRET=your-secret CORS_ORIGIN=https://ctmt88.github.io 
echo 6. az webapp deployment source config-zip --resource-group ctmt88_group --name ctmt88 --src deployment.zip 
pause 
