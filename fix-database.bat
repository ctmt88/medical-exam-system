@echo off
chcp 65001 >nul
echo ====================================
echo 修正資料庫初始化問題
echo ====================================
echo.

cd backend

echo 🔧 檢查並修正問題...
echo.

REM 檢查目前狀況
echo 📋 檢查目前檔案結構：
if exist "database" (
    echo ✅ database 資料夾存在
    dir database
) else (
    echo ❌ database 資料夾不存在
    mkdir database
)
echo.

if exist "models" (
    echo ✅ models 資料夾存在
) else (
    echo ❌ models 資料夾不存在
    mkdir models
)
echo.

REM 重新建立簡化版的資料庫初始化
echo 🗃️ 建立簡化版資料庫初始化...

echo const sqlite3 = require('sqlite3').verbose() > database\simple-init.js
echo const path = require('path') >> database\simple-init.js
echo. >> database\simple-init.js
echo console.log('🚀 開始初始化資料庫...') >> database\simple-init.js
echo. >> database\simple-init.js
echo const dbPath = './database/exam_system.db' >> database\simple-init.js
echo console.log('資料庫路徑:', dbPath) >> database\simple-init.js
echo. >> database\simple-init.js
echo const db = new sqlite3.Database(dbPath, (err) =^> { >> database\simple-init.js
echo   if (err) { >> database\simple-init.js
echo     console.error('❌ 資料庫連線失敗:', err.message) >> database\simple-init.js
echo     process.exit(1) >> database\simple-init.js
echo   } else { >> database\simple-init.js
echo     console.log('✅ 資料庫連線成功') >> database\simple-init.js
echo     initTables() >> database\simple-init.js
echo   } >> database\simple-init.js
echo }) >> database\simple-init.js
echo. >> database\simple-init.js
echo function initTables() { >> database\simple-init.js
echo   console.log('📝 建立資料表...') >> database\simple-init.js
echo. >> database\simple-init.js
echo   // 建立角色表 >> database\simple-init.js
echo   db.run(`CREATE TABLE IF NOT EXISTS user_roles ( >> database\simple-init.js
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\simple-init.js
echo     role_name VARCHAR(50) NOT NULL UNIQUE, >> database\simple-init.js
echo     description TEXT, >> database\simple-init.js
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP >> database\simple-init.js
echo   )`, (err) =^> { >> database\simple-init.js
echo     if (err) console.error('角色表建立失敗:', err) >> database\simple-init.js
echo     else console.log('✅ 角色表建立成功') >> database\simple-init.js
echo   }) >> database\simple-init.js
echo. >> database\simple-init.js
echo   // 建立使用者表 >> database\simple-init.js
echo   db.run(`CREATE TABLE IF NOT EXISTS users ( >> database\simple-init.js
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\simple-init.js
echo     student_id VARCHAR(20) UNIQUE, >> database\simple-init.js
echo     name VARCHAR(100) NOT NULL, >> database\simple-init.js
echo     email VARCHAR(255) UNIQUE, >> database\simple-init.js
echo     password_hash VARCHAR(255) NOT NULL, >> database\simple-init.js
echo     role_id INTEGER NOT NULL, >> database\simple-init.js
echo     is_active BOOLEAN DEFAULT 1, >> database\simple-init.js
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\simple-init.js
echo     last_login DATETIME >> database\simple-init.js
echo   )`, (err) =^> { >> database\simple-init.js
echo     if (err) console.error('使用者表建立失敗:', err) >> database\simple-init.js
echo     else console.log('✅ 使用者表建立成功') >> database\simple-init.js
echo   }) >> database\simple-init.js
echo. >> database\simple-init.js
echo   // 建立科目表 >> database\simple-init.js
echo   db.run(`CREATE TABLE IF NOT EXISTS categories ( >> database\simple-init.js
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\simple-init.js
echo     category_code VARCHAR(10) NOT NULL UNIQUE, >> database\simple-init.js
echo     category_name VARCHAR(200) NOT NULL, >> database\simple-init.js
echo     description TEXT, >> database\simple-init.js
echo     is_active BOOLEAN DEFAULT 1, >> database\simple-init.js
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP >> database\simple-init.js
echo   )`, (err) =^> { >> database\simple-init.js
echo     if (err) console.error('科目表建立失敗:', err) >> database\simple-init.js
echo     else console.log('✅ 科目表建立成功') >> database\simple-init.js
echo     initData() >> database\simple-init.js
echo   }) >> database\simple-init.js
echo } >> database\simple-init.js
echo. >> database\simple-init.js
echo function initData() { >> database\simple-init.js
echo   console.log('📊 初始化基礎資料...') >> database\simple-init.js
echo. >> database\simple-init.js
echo   // 插入角色 >> database\simple-init.js
echo   db.run(`INSERT OR IGNORE INTO user_roles (role_name, description) VALUES >> database\simple-init.js
echo     ('admin', '系統管理員'), ('student', '學生')`, (err) =^> { >> database\simple-init.js
echo     if (err) console.error('角色資料插入失敗:', err) >> database\simple-init.js
echo     else console.log('✅ 角色資料初始化完成') >> database\simple-init.js
echo   }) >> database\simple-init.js
echo. >> database\simple-init.js
echo   // 插入科目 >> database\simple-init.js
echo   db.run(`INSERT OR IGNORE INTO categories (category_code, category_name, description) VALUES >> database\simple-init.js
echo     ('PHYS', '臨床生理學與病理學', '包含生理學、病理學相關內容'), >> database\simple-init.js
echo     ('HEMA', '臨床血液學與血庫學', '包含血液學、血庫學相關內容'), >> database\simple-init.js
echo     ('MOLE', '醫學分子檢驗學與臨床鏡檢學', '包含分子檢驗、鏡檢相關內容'), >> database\simple-init.js
echo     ('MICR', '微生物學與臨床微生物學', '包含微生物學相關內容'), >> database\simple-init.js
echo     ('BIOC', '生物化學與臨床生化學', '包含生物化學相關內容'), >> database\simple-init.js
echo     ('SERO', '臨床血清免疫學與臨床病毒學', '包含血清免疫學相關內容')`, (err) =^> { >> database\simple-init.js
echo     if (err) console.error('科目資料插入失敗:', err) >> database\simple-init.js
echo     else console.log('✅ 科目資料初始化完成') >> database\simple-init.js
echo   }) >> database\simple-init.js
echo. >> database\simple-init.js
echo   // 建立測試使用者 >> database\simple-init.js
echo   const bcrypt = require('bcryptjs') >> database\simple-init.js
echo   const password = bcrypt.hashSync('demo123', 10) >> database\simple-init.js
echo   db.run(`INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) VALUES >> database\simple-init.js
echo     ('DEMO001', '展示學生', 'demo@test.com', '${password}', 2)`, (err) =^> { >> database\simple-init.js
echo     if (err) console.error('測試使用者建立失敗:', err) >> database\simple-init.js
echo     else console.log('✅ 測試使用者建立完成') >> database\simple-init.js
echo     console.log('🎉 資料庫初始化完成！') >> database\simple-init.js
echo     console.log('測試帳號：DEMO001 / demo123') >> database\simple-init.js
echo     db.close() >> database\simple-init.js
echo   }) >> database\simple-init.js
echo } >> database\simple-init.js

echo ✅ 簡化版資料庫初始化腳本建立完成
echo.

echo 🧪 執行資料庫初始化...
node database/simple-init.js

if %ERRORLEVEL% EQU 0 (
    echo ✅ 資料庫初始化成功！
) else (
    echo ❌ 資料庫初始化失敗
    echo 手動建立資料庫檔案...
    echo. > database\exam_system.db
    echo 再次嘗試初始化...
    node database/simple-init.js
)

echo.

echo 🔍 檢查資料庫檔案...
if exist "database\exam_system.db" (
    echo ✅ 資料庫檔案已建立
    dir database\exam_system.db
) else (
    echo ❌ 資料庫檔案不存在
)

echo.

echo 🏗️ 建立簡化版服務器...

REM 建立簡化版 server.js
echo const express = require('express') > server.js
echo const cors = require('cors') >> server.js
echo const sqlite3 = require('sqlite3').verbose() >> server.js
echo const bcrypt = require('bcryptjs') >> server.js
echo const jwt = require('jsonwebtoken') >> server.js
echo. >> server.js
echo const app = express() >> server.js
echo const PORT = process.env.PORT ^|^| 3000 >> server.js
echo const JWT_SECRET = 'your-jwt-secret-key' >> server.js
echo. >> server.js
echo // 中間件 >> server.js
echo app.use(cors()) >> server.js
echo app.use(express.json()) >> server.js
echo. >> server.js
echo // 資料庫連線 >> server.js
echo const db = new sqlite3.Database('./database/exam_system.db', (err) =^> { >> server.js
echo   if (err) { >> server.js
echo     console.error('❌ 資料庫連線失敗:', err.message) >> server.js
echo   } else { >> server.js
echo     console.log('✅ 資料庫連線成功') >> server.js
echo   } >> server.js
echo }) >> server.js
echo. >> server.js
echo // 登入 API >> server.js
echo app.post('/api/auth/login', (req, res) =^> { >> server.js
echo   const { student_id, password } = req.body >> server.js
echo   >> server.js
echo   db.get('SELECT * FROM users WHERE student_id = ?', [student_id], (err, user) =^> { >> server.js
echo     if (err) { >> server.js
echo       return res.status(500).json({ success: false, error: { message: '伺服器錯誤' } }) >> server.js
echo     } >> server.js
echo     if (!user) { >> server.js
echo       return res.status(401).json({ success: false, error: { message: '學號或密碼錯誤' } }) >> server.js
echo     } >> server.js
echo     >> server.js
echo     bcrypt.compare(password, user.password_hash, (err, isValid) =^> { >> server.js
echo       if (err ^|^| !isValid) { >> server.js
echo         return res.status(401).json({ success: false, error: { message: '學號或密碼錯誤' } }) >> server.js
echo       } >> server.js
echo       >> server.js
echo       const token = jwt.sign({ userId: user.id, studentId: user.student_id }, JWT_SECRET, { expiresIn: '24h' }) >> server.js
echo       res.json({ >> server.js
echo         success: true, >> server.js
echo         data: { >> server.js
echo           token, >> server.js
echo           user: { id: user.id, student_id: user.student_id, name: user.name } >> server.js
echo         } >> server.js
echo       }) >> server.js
echo     }) >> server.js
echo   }) >> server.js
echo }) >> server.js
echo. >> server.js
echo // 取得科目 API >> server.js
echo app.get('/api/exam/categories', (req, res) =^> { >> server.js
echo   db.all('SELECT * FROM categories WHERE is_active = 1', (err, categories) =^> { >> server.js
echo     if (err) { >> server.js
echo       return res.status(500).json({ success: false, error: { message: '伺服器錯誤' } }) >> server.js
echo     } >> server.js
echo     res.json({ success: true, data: { categories } }) >> server.js
echo   }) >> server.js
echo }) >> server.js
echo. >> server.js
echo // 啟動服務器 >> server.js
echo app.listen(PORT, () =^> { >> server.js
echo   console.log(`🚀 服務器啟動成功！`) >> server.js
echo   console.log(`📡 API 地址: http://localhost:${PORT}`) >> server.js
echo   console.log(`🔑 測試帳號: DEMO001 / demo123`) >> server.js
echo }) >> server.js

echo ✅ 簡化版服務器建立完成
echo.

echo 🧪 測試服務器啟動...
echo 按任意鍵啟動服務器，或 Ctrl+C 跳過...
pause >nul

echo 正在啟動服務器...
echo 如要停止服務器，請按 Ctrl+C
echo.
node server.js

echo.
echo ====================================
echo 資料庫初始化修正完成
echo ====================================