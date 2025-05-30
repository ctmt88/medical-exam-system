# Azure 部署完成! 
 
## 🎉 恭喜！你的後端 API 已準備就緒 
 
### 📋 接下來的步驟： 
 
#### 1. 本地測試 
```bash 
cd backend 
npm start 
``` 
訪問: http://localhost:8000 
 
#### 2. 部署到 Azure 
```bash 
# 登入 Azure 
az login 
 
# 建立資源群組 
az group create --name ctmt88_group --location "East Asia" 
 
# 建立 App Service Plan 
az appservice plan create --name ctmt88-plan --resource-group ctmt88_group --sku F1 --is-linux 
 
# 建立 Web App 
az webapp create --resource-group ctmt88_group --plan ctmt88-plan --name ctmt88 --runtime "NODE:18-lts" 
 
# 設定環境變數 
az webapp config appsettings set --resource-group ctmt88_group --name ctmt88 --settings NODE_ENV=production JWT_SECRET=your-super-secret-key CORS_ORIGIN=https://ctmt88.github.io 
 
# 部署程式碼 
az webapp deployment source config-zip --resource-group ctmt88_group --name ctmt88 --src deployment.zip 
``` 
 
#### 3. 更新前端設定 
將 frontend-api-config.js 的內容複製到你的前端專案中 
 
#### 4. 測試 API 
- 基本健康檢查: https://ctmt88.azurewebsites.net/health 
- API 狀態: https://ctmt88.azurewebsites.net/ 
- 科目列表: https://ctmt88.azurewebsites.net/api/exam/categories 
 
### 🔧 重要設定 
 
1. **JWT_SECRET**: 請更改為更安全的密鑰 
2. **CORS 設定**: 已設定允許從 GitHub Pages 存取 
3. **資料庫**: 使用 SQLite，資料會持久化儲存 
 
### 📊 預設帳號 
- **學生帳號**: DEMO001 / student123 
- **管理員**: admin@medical-exam.com / admin123 
 
### 🎯 下一步 
1. 測試 API 功能 
2. 更新前端連接真實 API 
3. 新增題目資料 
4. 建立學生帳號 
