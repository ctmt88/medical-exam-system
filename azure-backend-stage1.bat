@echo off 
chcp 65001 >nul 
echo 建立儀表板和考試介面... 
cd frontend 
@echo off
chcp 65001 >nul
echo ====================================
echo Azure 後端系統建立 - 第一階段
echo 建立後端專案結構和基本設定
echo ====================================
echo.

echo 🚀 建立後端資料夾結構...
echo.

REM 建立後端目錄結構
if not exist "backend" mkdir backend
cd backend

echo 📦 建立 package.json...
echo { > package.json
echo   "name": "medical-exam-backend", >> package.json
echo   "version": "1.0.0", >> package.json
echo   "description": "醫檢師考試系統後端API", >> package.json
echo   "main": "server.js", >> package.json
echo   "scripts": { >> package.json
echo     "start": "node server.js", >> package.json
echo     "dev": "nodemon server.js", >> package.json
echo     "init-db": "node database/init.js" >> package.json
echo   }, >> package.json
echo   "dependencies": { >> package.json
echo     "express": "^4.18.2", >> package.json
echo     "sqlite3": "^5.1.6", >> package.json
echo     "bcryptjs": "^2.4.3", >> package.json
echo     "jsonwebtoken": "^9.0.2", >> package.json
echo     "cors": "^2.8.5", >> package.json
echo     "helmet": "^7.1.0", >> package.json
echo     "express-rate-limit": "^7.1.5", >> package.json
echo     "joi": "^17.11.0", >> package.json
echo     "multer": "^1.4.5-lts.1", >> package.json
echo     "xlsx": "^0.18.5", >> package.json
echo     "dotenv": "^16.3.1" >> package.json
echo   }, >> package.json
echo   "devDependencies": { >> package.json
echo     "nodemon": "^3.0.2" >> package.json
echo   }, >> package.json
echo   "engines": { >> package.json
echo     "node": "^>=18.0.0" >> package.json
echo   }, >> package.json
echo   "author": "ctmt88", >> package.json
echo   "license": "MIT" >> package.json
echo } >> package.json

echo ✅ package.json 建立完成
echo.

echo 🔧 建立環境變數檔案...
echo NODE_ENV=development > .env
echo PORT=3000 >> .env
echo JWT_SECRET=your-super-secret-jwt-key-change-this-in-production >> .env
echo DB_PATH=./database/exam_system.db >> .env
echo CORS_ORIGIN=http://localhost:5173 >> .env
echo UPLOAD_PATH=./uploads >> .env

echo ✅ .env 檔案建立完成
echo.

echo 📁 建立目錄結構...
mkdir config
mkdir controllers
mkdir middleware
mkdir models
mkdir routes
mkdir services
mkdir utils
mkdir database
mkdir uploads
mkdir uploads\images
mkdir uploads\excel
mkdir logs

echo ✅ 目錄結構建立完成
echo.

echo ⚙️ 建立主要配置檔案...

REM config/database.js
echo const sqlite3 = require('sqlite3').verbose() > config\database.js
echo const path = require('path') >> config\database.js
echo require('dotenv').config() >> config\database.js
echo. >> config\database.js
echo const dbPath = process.env.DB_PATH ^|^| './database/exam_system.db' >> config\database.js
echo. >> config\database.js
echo class Database { >> config\database.js
echo   constructor() { >> config\database.js
echo     this.db = null >> config\database.js
echo   } >> config\database.js
echo. >> config\database.js
echo   connect() { >> config\database.js
echo     return new Promise((resolve, reject) =^> { >> config\database.js
echo       this.db = new sqlite3.Database(dbPath, (err) =^> { >> config\database.js
echo         if (err) { >> config\database.js
echo           console.error('資料庫連線失敗:', err.message) >> config\database.js
echo           reject(err) >> config\database.js
echo         } else { >> config\database.js
echo           console.log('✅ SQLite 資料庫連線成功') >> config\database.js
echo           resolve(this.db) >> config\database.js
echo         } >> config\database.js
echo       }) >> config\database.js
echo     }) >> config\database.js
echo   } >> config\database.js
echo. >> config\database.js
echo   getDb() { >> config\database.js
echo     return this.db >> config\database.js
echo   } >> config\database.js
echo. >> config\database.js
echo   close() { >> config\database.js
echo     if (this.db) { >> config\database.js
echo       this.db.close() >> config\database.js
echo     } >> config\database.js
echo   } >> config\database.js
echo } >> config\database.js
echo. >> config\database.js
echo module.exports = new Database() >> config\database.js

echo ✅ database.js 建立完成
echo.

REM config/config.js
echo require('dotenv').config() > config\config.js
echo. >> config\config.js
echo module.exports = { >> config\config.js
echo   port: process.env.PORT ^|^| 3000, >> config\config.js
echo   nodeEnv: process.env.NODE_ENV ^|^| 'development', >> config\config.js
echo   jwtSecret: process.env.JWT_SECRET ^|^| 'default-secret-change-this', >> config\config.js
echo   dbPath: process.env.DB_PATH ^|^| './database/exam_system.db', >> config\config.js
echo   corsOrigin: process.env.CORS_ORIGIN ^|^| 'http://localhost:5173', >> config\config.js
echo   uploadPath: process.env.UPLOAD_PATH ^|^| './uploads', >> config\config.js
echo   rateLimit: { >> config\config.js
echo     windowMs: 15 * 60 * 1000, // 15 分鐘 >> config\config.js
echo     max: 100 // 每個 IP 最多 100 次請求 >> config\config.js
echo   } >> config\config.js
echo } >> config\config.js

echo ✅ config.js 建立完成
echo.

echo 🗃️ 建立資料庫初始化腳本...

REM database/schema.sql
echo -- 醫事檢驗師考試系統資料庫架構 > database\schema.sql
echo -- SQLite 版本 >> database\schema.sql
echo. >> database\schema.sql
echo PRAGMA foreign_keys = ON; >> database\schema.sql
echo. >> database\schema.sql
echo -- 使用者角色表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS user_roles ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     role_name VARCHAR(50) NOT NULL UNIQUE, >> database\schema.sql
echo     description TEXT, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 使用者表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS users ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     student_id VARCHAR(20) UNIQUE, >> database\schema.sql
echo     name VARCHAR(100) NOT NULL, >> database\schema.sql
echo     email VARCHAR(255) UNIQUE, >> database\schema.sql
echo     password_hash VARCHAR(255) NOT NULL, >> database\schema.sql
echo     role_id INTEGER NOT NULL, >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     last_login DATETIME, >> database\schema.sql
echo     FOREIGN KEY (role_id) REFERENCES user_roles(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 六大科目分類表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS categories ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     category_code VARCHAR(10) NOT NULL UNIQUE, >> database\schema.sql
echo     category_name VARCHAR(200) NOT NULL, >> database\schema.sql
echo     description TEXT, >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 主題分類表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS topic_categories ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     category_id INTEGER NOT NULL, >> database\schema.sql
echo     topic_name VARCHAR(200) NOT NULL, >> database\schema.sql
echo     topic_code VARCHAR(20), >> database\schema.sql
echo     description TEXT, >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (category_id) REFERENCES categories(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 題目表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS questions ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     question_number VARCHAR(20), >> database\schema.sql
echo     exam_year INTEGER, >> database\schema.sql
echo     exam_semester VARCHAR(10), >> database\schema.sql
echo     category_id INTEGER NOT NULL, >> database\schema.sql
echo     topic_category_id INTEGER, >> database\schema.sql
echo     question_text TEXT NOT NULL, >> database\schema.sql
echo     option_a TEXT NOT NULL, >> database\schema.sql
echo     option_b TEXT NOT NULL, >> database\schema.sql
echo     option_c TEXT NOT NULL, >> database\schema.sql
echo     option_d TEXT NOT NULL, >> database\schema.sql
echo     correct_answer CHAR(1) NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D'^)^), >> database\schema.sql
echo     explanation TEXT, >> database\schema.sql
echo     image_url VARCHAR(500), >> database\schema.sql
echo     difficulty_level INTEGER DEFAULT 1 CHECK (difficulty_level BETWEEN 1 AND 5), >> database\schema.sql
echo     frequency_weight REAL DEFAULT 1.0, >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_by INTEGER, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (category_id) REFERENCES categories(id), >> database\schema.sql
echo     FOREIGN KEY (topic_category_id) REFERENCES topic_categories(id), >> database\schema.sql
echo     FOREIGN KEY (created_by) REFERENCES users(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 考試場次表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS exam_sessions ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     user_id INTEGER NOT NULL, >> database\schema.sql
echo     category_id INTEGER NOT NULL, >> database\schema.sql
echo     session_name VARCHAR(200), >> database\schema.sql
echo     exam_type VARCHAR(50) DEFAULT 'single_subject', >> database\schema.sql
echo     total_questions INTEGER DEFAULT 80, >> database\schema.sql
echo     time_limit_minutes INTEGER DEFAULT 60, >> database\schema.sql
echo     max_score REAL DEFAULT 100.0, >> database\schema.sql
echo     score_per_question REAL DEFAULT 1.25, >> database\schema.sql
echo     start_time DATETIME, >> database\schema.sql
echo     end_time DATETIME, >> database\schema.sql
echo     submitted_time DATETIME, >> database\schema.sql
echo     time_remaining INTEGER, >> database\schema.sql
echo     is_completed BOOLEAN DEFAULT 0, >> database\schema.sql
echo     is_submitted BOOLEAN DEFAULT 0, >> database\schema.sql
echo     total_score REAL, >> database\schema.sql
echo     correct_count INTEGER DEFAULT 0, >> database\schema.sql
echo     marked_count INTEGER DEFAULT 0, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (user_id) REFERENCES users(id), >> database\schema.sql
echo     FOREIGN KEY (category_id) REFERENCES categories(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 考試題目表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS exam_questions ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     session_id INTEGER NOT NULL, >> database\schema.sql
echo     question_id INTEGER NOT NULL, >> database\schema.sql
echo     question_order INTEGER NOT NULL, >> database\schema.sql
echo     category_id INTEGER NOT NULL, >> database\schema.sql
echo     FOREIGN KEY (session_id) REFERENCES exam_sessions(id) ON DELETE CASCADE, >> database\schema.sql
echo     FOREIGN KEY (question_id) REFERENCES questions(id), >> database\schema.sql
echo     FOREIGN KEY (category_id) REFERENCES categories(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 學生答題記錄表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS user_answers ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     session_id INTEGER NOT NULL, >> database\schema.sql
echo     question_id INTEGER NOT NULL, >> database\schema.sql
echo     question_order INTEGER NOT NULL, >> database\schema.sql
echo     user_answer CHAR(1) CHECK (user_answer IN ('A', 'B', 'C', 'D'^)^), >> database\schema.sql
echo     is_marked BOOLEAN DEFAULT 0, >> database\schema.sql
echo     is_correct BOOLEAN, >> database\schema.sql
echo     answer_time DATETIME, >> database\schema.sql
echo     time_spent INTEGER, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (session_id) REFERENCES exam_sessions(id) ON DELETE CASCADE, >> database\schema.sql
echo     FOREIGN KEY (question_id) REFERENCES questions(id), >> database\schema.sql
echo     UNIQUE(session_id, question_id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 錯題收藏表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS bookmarked_questions ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     user_id INTEGER NOT NULL, >> database\schema.sql
echo     question_id INTEGER NOT NULL, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, >> database\schema.sql
echo     FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE, >> database\schema.sql
echo     UNIQUE(user_id, question_id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 檔案上傳記錄表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS upload_logs ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     uploaded_by INTEGER NOT NULL, >> database\schema.sql
echo     file_name VARCHAR(255) NOT NULL, >> database\schema.sql
echo     file_size INTEGER, >> database\schema.sql
echo     record_count INTEGER, >> database\schema.sql
echo     error_count INTEGER DEFAULT 0, >> database\schema.sql
echo     upload_type VARCHAR(50), >> database\schema.sql
echo     status VARCHAR(20) DEFAULT 'processing', >> database\schema.sql
echo     error_log TEXT, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (uploaded_by) REFERENCES users(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 建立索引 >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_questions_category ON questions(category_id); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_questions_topic ON questions(topic_category_id); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_questions_year ON questions(exam_year); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_questions_active ON questions(is_active); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_users_student_id ON users(student_id); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_users_email ON users(email); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_exam_sessions_user ON exam_sessions(user_id); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_user_answers_session ON user_answers(session_id); >> database\schema.sql
echo CREATE INDEX IF NOT EXISTS idx_user_answers_question ON user_answers(question_id); >> database\schema.sql

echo ✅ 資料庫架構檔案建立完成
echo.

echo 🏗️ 建立第二階段批次檔...

REM 建立第二階段批次檔
echo @echo off > ..\azure-backend-stage2.bat
echo chcp 65001 ^>nul >> ..\azure-backend-stage2.bat
echo echo Azure 後端系統 - 第二階段 >> ..\azure-backend-stage2.bat
echo echo 建立資料庫初始化和基本模型... >> ..\azure-backend-stage2.bat
echo cd backend >> ..\azure-backend-stage2.bat

echo ✅ 第一階段完成！
echo.

echo 📋 第一階段建立內容：
echo ✅ 完整的 package.json 設定
echo ✅ 環境變數配置 (.env)
echo ✅ 資料庫配置 (config/database.js)
echo ✅ 系統配置 (config/config.js)
echo ✅ 完整的資料庫架構 (database/schema.sql)
echo ✅ 專案目錄結構
echo.

echo 🚀 下一步：
echo 1. 執行 azure-backend-stage2.bat 建立資料庫初始化
echo 2. 執行 azure-backend-stage3.bat 建立 API 控制器
echo 3. 執行 azure-backend-stage4.bat 建立服務器和部署設定
echo.

echo ====================================
echo Azure 後端第一階段完成！
echo ====================================
pause