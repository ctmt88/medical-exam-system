# 醫檢師考試系統 - 完整部署指南

## 🎯 系統概述

醫檢師國家考試線上練習系統，包含完整的前後端代碼、API服務、資料庫設計和診斷工具。

## 📁 檔案結構

```
醫檢師考試系統/
├── backend/                    # 後端檔案
│   ├── index.php              # 完整後端API
│   └── config.php             # 資料庫配置
├── frontend/                   # 前端檔案
│   ├── src/
│   │   ├── App.jsx            # 主應用組件
│   │   ├── ApiService.js      # API服務類
│   │   └── ExcelImport.jsx    # Excel匯入組件
│   ├── index.html             # HTML模板（可直接使用）
│   └── package.json           # NPM依賴配置
├── tools/
│   └── diagnostic.html        # 系統診斷工具
└── README.md                  # 部署指南
```

## 🚀 快速部署

### **方案1：立即使用版本（推薦）**

#### 後端部署：
1. **上傳後端檔案**
   ```bash
   # 將 backend/index.php 上傳到你的服務器
   # 例如：https://starsport.tw/exam/api/index.php
   ```

2. **修改資料庫配置**
   編輯 `index.php` 中的資料庫配置：
   ```php
   $dbConfig = [
       'host' => 'localhost',
       'dbname' => 'your_database_name',    # 修改這裡
       'username' => 'your_username',       # 修改這裡
       'password' => 'your_password',       # 修改這裡
       'charset' => 'utf8mb4'
   ];
   ```

3. **執行資料庫建表**
   ```sql
   -- 執行完整的資料庫建表SQL（你之前應該已經有了）
   ```

#### 前端部署：
1. **直接使用HTML版本**
   - 將 `frontend/index.html` 上傳到你的網站根目錄
   - 確保API地址正確設置為你的後端地址

2. **或部署到GitHub Pages**
   - Fork你的現有repository
   - 替換所有檔案為新版本
   - GitHub Pages會自動部署

#### 測試部署：
1. **使用診斷工具**
   - 打開 `tools/diagnostic.html`
   - 點擊「完整診斷」測試所有功能

2. **測試前端**
   - 訪問你的前端網址
   - 登入：DEMO001 / demo123
   - 測試考試功能

### **方案2：開發版本**

#### 環境要求：
- Node.js 16+
- PHP 7.4+
- MySQL 5.7+

#### 後端設置：
```bash
# 1. 部署PHP檔案
cp backend/* /your/web/server/path/

# 2. 設置權限
chmod 755 index.php
chmod 644 config.php

# 3. 測試API
curl -X POST https://your-domain.com/exam/api/ \
  -H "Content-Type: application/json" \
  -d '{"action":"health_check"}'
```

#### 前端設置：
```bash
# 1. 初始化專案
npm install

# 2. 開發模式
npm run dev

# 3. 構建生產版本
npm run build

# 4. 部署到GitHub Pages
npm run deploy
```

## ⚙️ 配置說明

### **後端配置**

#### 1. 資料庫配置 (`backend/index.php`)
```php
$dbConfig = [
    'host' => 'localhost',                    # 資料庫主機
    'dbname' => 'starspor_medical_exam_db',  # 資料庫名稱
    'username' => 'starspor_exam_user',      # 用戶名
    'password' => '"R,)gY"",d9K]ai',         # 密碼
    'charset' => 'utf8mb4'                   # 字符集
];
```

#### 2. CORS設置
```php
header('Access-Control-Allow-Origin: *');                    # 允許所有來源
header('Access-Control-Allow-Origin: https://ctmt88.github.io'); # 或指定來源
```

### **前端配置**

#### 1. API地址設置
在 `ApiService.js` 或 `index.html` 中：
```javascript
this.baseURL = 'https://starsport.tw/exam/api/';  # 修改為你的API地址
```

#### 2. 超時設置
```javascript
this.timeout = 15000; // 15秒超時
```

## 🔧 功能特色

### **後端API功能**
- ✅ **完整RESTful API** - 支援POST/GET雙重模式
- ✅ **用戶認證系統** - 登入/登出/權限管理
- ✅ **考試功能** - 題目獲取/答案提交/成績計算
- ✅ **Excel匯入** - 批量題目匯入功能
- ✅ **資料庫診斷** - 重複題目檢查和清理
- ✅ **健康檢查** - 系統狀態監控
- ✅ **錯誤處理** - 完整的日誌和錯誤追蹤

### **前端功能**
- ✅ **響應式設計** - 支援手機/平板/桌面
- ✅ **考試介面** - 完整的考試流程和計時器
- ✅ **成績統計** - 歷史記錄和統計分析
- ✅ **Excel匯入** - 智能欄位映射和預覽
- ✅ **離線模式** - API失敗時的模擬模式
- ✅ **錯誤處理** - 用戶友善的錯誤提示

### **診斷工具功能**
- ✅ **完整健康檢查** - 系統狀態和API測試
- ✅ **資料庫診斷** - 題目統計和重複檢查
- ✅ **API測試套件** - 所有端點的自動測試
- ✅ **重複題目清理** - 安全的重複題目刪除
- ✅ **實時日誌** - 詳細的操作記錄

## 🧪 測試流程

### **1. 後端API測試**
```bash
# 健康檢查
curl -X POST https://your-domain.com/exam/api/ \
  -H "Content-Type: application/json" \
  -d '{"action":"health_check"}'

# 登入測試
curl -X POST https://your-domain.com/exam/api/ \
  -H "Content-Type: application/json" \
  -d '{"action":"login","username":"DEMO001","password":"demo123"}'

# 科目獲取
curl -X POST https://your-domain.com/exam/api/ \
  -H "Content-Type: application/json" \
  -d '{"action":"categories"}'

# 題目獲取
curl -X POST https://your-domain.com/exam/api/ \
  -H "Content-Type: application/json" \
  -d '{"action":"questions","category_id":1,"limit":5}'
```

### **2. 前端功能測試**
1. **登入功能** - 使用 DEMO001/demo123 登入
2. **科目選擇** - 選擇任一科目開始考試
3. **考試流程** - 答題/導航/提交考試
4. **Excel匯入** - 上傳Excel檔案測試匯入
5. **歷史記錄** - 查看考試歷史和統計

### **3. 診斷工具測試**
1. 打開 `tools/diagnostic.html`
2. 設置正確的API地址
3. 點擊「完整診斷」
4. 檢查所有測試項目是否通過

## 🛠️ 故障排除

### **常見問題**

#### 1. API連接失敗
**症狀：** 前端顯示「系統載入中...」或連接錯誤
**解決方案：**
- 檢查API地址是否正確
- 檢查CORS設置
- 檢查服務器PHP是否正常運行
- 查看瀏覽器控制台錯誤

#### 2. 資料庫連接失敗
**症狀：** API返回資料庫錯誤
**解決方案：**
- 檢查資料庫配置是否正確
- 確認資料庫服務是否運行
- 檢查用戶權限
- 查看API錯誤日誌

#### 3. Excel匯入失敗
**症狀：** 匯入顯示成功0題
**解決方案：**
- 檢查Excel格式是否正確
- 確認資料庫表結構
- 查看API錯誤日誌
- 使用診斷工具測試匯入功能

#### 4. 考試功能異常
**症狀：** 無法載入題目或提交失敗
**解決方案：**
- 檢查資料庫中是否有題目
- 確認科目ID是否存在
- 查看API錯誤日誌
- 使用診斷工具測試API

### **調試工具**

#### 1. 瀏覽器控制台
```javascript
// 在前端頁面控制台執行
window.apiService.testConnection();  // 測試API連接
window.apiService.runFullTest();     // 完整API測試
```

#### 2. API錯誤日誌
查看服務器上的 `api_errors.log` 檔案

#### 3. 診斷工具
使用 `tools/diagnostic.html` 進行完整系統診斷

## 📞 技術支援

### **支援的瀏覽器**
- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

### **系統要求**
- **後端：** PHP 7.4+, MySQL 5.7+
- **前端：** 現代瀏覽器，支援ES6+

### **性能建議**
- 啟用PHP OPCache
- 使用CDN加速靜態資源
- 資料庫索引優化
- 適當的緩存策略

## 🔄 更新和維護

### **版本更新**
1. 備份現有檔案和資料庫
2. 替換新版本檔案
3. 執行必要的資料庫更新
4. 使用診斷工具驗證功能

### **資料備份**
```bash
# 備份資料庫
mysqldump -u username -p database_name > backup.sql

# 備份檔案
tar -czf backup.tar.gz /path/to/exam/system/
```

### **監控建議**
- 定期檢查API錯誤日誌
- 監控資料庫性能
- 使用診斷工具定期健康檢查
- 監控磁碟空間和內存使用

## 📄 授權和版權

本系統採用MIT授權，可自由使用和修改。

---

**🎉 部署完成！**

如果你按照這個指南成功部署了系統，你現在擁有一個完整功能的醫檢師考試練習平台！

如需技術支援，請檢查診斷工具的輸出和錯誤日誌。 
## 🚀 部署狀態 
- 最後更新: 週六 2025/05/31 11:02:08.70 
- 狀態: 重新部署中... 
- 網址: [https://ctmt88.github.io/medical-exam-system/](https://ctmt88.github.io/medical-exam-system/) 
 
## 🚀 部署狀態 
- 最後更新: 週六 2025/05/31 11:05:32.04 
- 狀態: 重新部署中... 
- 網址: [https://ctmt88.github.io/medical-exam-system/](https://ctmt88.github.io/medical-exam-system/) 
