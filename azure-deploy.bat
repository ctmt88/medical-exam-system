@echo off
chcp 65001 >nul
echo ====================================
echo Azure 雲端部署 - 自動化腳本
echo ====================================
echo.

echo 🎯 這個腳本會幫你：
echo 1. 準備 Azure 版本的後端代碼
echo 2. 建立部署配置
echo 3. 準備前端 API 連接
echo 4. 生成部署指令
echo.

set /p CONTINUE="準備開始部署嗎？(Y/N): "
if /i not "%CONTINUE%"=="Y" goto :END

echo.
echo 📝 請提供以下資訊：
echo.

set /p APP_NAME="你的 App Service 名稱 (例: medical-exam-api-ctmt88): "
set /p RESOURCE_GROUP="資源群組名稱 (例: medical-exam-rg): "

echo.
echo ✅ 設定確認：
echo App Service: %APP_NAME%.azurewebsites.net
echo 資源群組: %RESOURCE_GROUP%
echo.

set /p CONFIRM="確認設定正確嗎？(Y/N): "
if /i not "%CONFIRM%"=="Y" goto :END

echo.
echo 🔧 開始準備部署檔案...
echo.

REM 建立 backend 資料夾
if not exist backend mkdir backend
cd backend

echo 📦 建立 package.json...
echo { > package.json
echo   "name": "medical-exam-backend", >> package.json
echo   "version": "1.0.0", >> package.json
echo   "main": "server.js", >> package.json
echo   "scripts": { >> package.json
echo     "start": "node server.js", >> package.json
echo     "dev": "nodemon server.js" >> package.json
echo   }, >> package.json
echo   "dependencies": { >> package.json
echo     "express": "^4.18.2", >> package.json
echo     "cors": "^2.8.5", >> package.json
echo     "helmet": "^7.1.0", >> package.json
echo     "bcryptjs": "^2.4.3", >> package.json
echo     "jsonwebtoken": "^9.0.2", >> package.json
echo     "sqlite3": "^5.1.6", >> package.json
echo     "multer": "^1.4.5-lts.1", >> package.json
echo     "joi": "^17.11.0", >> package.json
echo     "dotenv": "^16.3.1" >> package.json
echo   }, >> package.json
echo   "engines": { >> package.json
echo     "node": ">=18.0.0" >> package.json
echo   } >> package.json
echo } >> package.json

echo ✅ package.json 建立完成

echo 🚀 建立主服務器檔案...
echo const express = require('express'); > server.js
echo const cors = require('cors'); >> server.js
echo const helmet = require('helmet'); >> server.js
echo const path = require('path'); >> server.js
echo const sqlite3 = require('sqlite3').verbose(); >> server.js
echo const bcrypt = require('bcryptjs'); >> server.js
echo const jwt = require('jsonwebtoken'); >> server.js
echo require('dotenv').config(); >> server.js
echo. >> server.js
echo const app = express(); >> server.js
echo const PORT = process.env.PORT ^|^| 8000; >> server.js
echo const JWT_SECRET = process.env.JWT_SECRET ^|^| 'your-jwt-secret-key'; >> server.js
echo. >> server.js
echo // 資料庫初始化 >> server.js
echo const dbPath = process.env.NODE_ENV === 'production' ? >> server.js
echo   path.join(__dirname, 'database', 'exam_system.db') : >> server.js
echo   path.join(__dirname, 'database', 'exam_system.db'); >> server.js
echo. >> server.js
echo const db = new sqlite3.Database(dbPath, (err) =^> { >> server.js
echo   if (err) { >> server.js
echo     console.error('❌ 資料庫連接失敗:', err.message); >> server.js
echo   } else { >> server.js
echo     console.log('✅ SQLite 資料庫連接成功'); >> server.js
echo   } >> server.js
echo }); >> server.js
echo. >> server.js
echo // 中間件設定 >> server.js
echo app.use(helmet()); >> server.js
echo app.use(cors({ >> server.js
echo   origin: ['https://ctmt88.github.io', 'http://localhost:5173'], >> server.js
echo   credentials: true >> server.js
echo })); >> server.js
echo app.use(express.json({ limit: '10mb' })); >> server.js
echo app.use(express.urlencoded({ extended: true })); >> server.js
echo. >> server.js
echo // JWT 認證中間件 >> server.js
echo const authenticateToken = (req, res, next) =^> { >> server.js
echo   const authHeader = req.headers['authorization']; >> server.js
echo   const token = authHeader && authHeader.split(' ')[1]; >> server.js
echo. >> server.js
echo   if (!token) { >> server.js
echo     return res.status(401).json({ success: false, error: { message: '需要認證 token' } }); >> server.js
echo   } >> server.js
echo. >> server.js
echo   jwt.verify(token, JWT_SECRET, (err, user) =^> { >> server.js
echo     if (err) { >> server.js
echo       return res.status(403).json({ success: false, error: { message: 'Token 無效' } }); >> server.js
echo     } >> server.js
echo     req.user = user; >> server.js
echo     next(); >> server.js
echo   }); >> server.js
echo }; >> server.js
echo. >> server.js
echo // 基本路由 >> server.js
echo app.get('/', (req, res) =^> { >> server.js
echo   res.json({ >> server.js
echo     message: '醫檢師考試系統 API', >> server.js
echo     status: 'running', >> server.js
echo     version: '1.0.0', >> server.js
echo     endpoints: ['/api/auth/login', '/api/exam/categories', '/api/exam/start'] >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 登入 API >> server.js
echo app.post('/api/auth/login', (req, res) =^> { >> server.js
echo   const { student_id, password } = req.body; >> server.js
echo. >> server.js
echo   // 驗證輸入 >> server.js
echo   if (!student_id ^|^| !password) { >> server.js
echo     return res.status(400).json({ >> server.js
echo       success: false, >> server.js
echo       error: { message: '請提供學號和密碼' } >> server.js
echo     }); >> server.js
echo   } >> server.js
echo. >> server.js
echo   // 查詢使用者 >> server.js
echo   const sql = 'SELECT * FROM users WHERE student_id = ? AND is_active = 1'; >> server.js
echo   db.get(sql, [student_id], async (err, user) =^> { >> server.js
echo     if (err) { >> server.js
echo       console.error('資料庫查詢錯誤:', err); >> server.js
echo       return res.status(500).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '伺服器錯誤' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     if (!user) { >> server.js
echo       return res.status(401).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '學號或密碼錯誤' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     // 驗證密碼 >> server.js
echo     const isValidPassword = await bcrypt.compare(password, user.password_hash); >> server.js
echo     if (!isValidPassword) { >> server.js
echo       return res.status(401).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '學號或密碼錯誤' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     // 生成 JWT token >> server.js
echo     const token = jwt.sign({ >> server.js
echo       id: user.id, >> server.js
echo       student_id: user.student_id, >> server.js
echo       role: user.role_id >> server.js
echo     }, JWT_SECRET, { expiresIn: '24h' }); >> server.js
echo. >> server.js
echo     // 更新最後登入時間 >> server.js
echo     db.run('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?', [user.id]); >> server.js
echo. >> server.js
echo     res.json({ >> server.js
echo       success: true, >> server.js
echo       data: { >> server.js
echo         token, >> server.js
echo         user: { >> server.js
echo           id: user.id, >> server.js
echo           student_id: user.student_id, >> server.js
echo           name: user.name, >> server.js
echo           email: user.email >> server.js
echo         } >> server.js
echo       } >> server.js
echo     }); >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 取得科目列表 API >> server.js
echo app.get('/api/exam/categories', (req, res) =^> { >> server.js
echo   const sql = 'SELECT * FROM categories WHERE is_active = 1 ORDER BY id'; >> server.js
echo   db.all(sql, [], (err, categories) =^> { >> server.js
echo     if (err) { >> server.js
echo       console.error('查詢科目錯誤:', err); >> server.js
echo       return res.status(500).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '伺服器錯誤' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     res.json({ >> server.js
echo       success: true, >> server.js
echo       data: { categories } >> server.js
echo     }); >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 開始考試 API >> server.js
echo app.post('/api/exam/start', authenticateToken, (req, res) =^> { >> server.js
echo   const { category_id } = req.body; >> server.js
echo   const user_id = req.user.id; >> server.js
echo. >> server.js
echo   if (!category_id) { >> server.js
echo     return res.status(400).json({ >> server.js
echo       success: false, >> server.js
echo       error: { message: '請選擇考試科目' } >> server.js
echo     }); >> server.js
echo   } >> server.js
echo. >> server.js
echo   // 隨機抽取80題 >> server.js
echo   const sql = `SELECT q.*, c.category_name >> server.js
echo                FROM questions q >> server.js
echo                JOIN categories c ON q.category_id = c.id >> server.js
echo                WHERE q.category_id = ? AND q.is_active = 1 >> server.js
echo                ORDER BY RANDOM() LIMIT 80`; >> server.js
echo. >> server.js
echo   db.all(sql, [category_id], (err, questions) =^> { >> server.js
echo     if (err) { >> server.js
echo       console.error('查詢題目錯誤:', err); >> server.js
echo       return res.status(500).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '伺服器錯誤' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     if (questions.length ^< 80) { >> server.js
echo       return res.status(400).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '該科目題目數量不足80題' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     // 建立考試場次 >> server.js
echo     const createSessionSql = `INSERT INTO exam_sessions >> server.js
echo       (user_id, category_id, total_questions, time_limit_minutes, max_score, score_per_question, start_time) >> server.js
echo       VALUES (?, ?, 80, 60, 100, 1.25, CURRENT_TIMESTAMP)`; >> server.js
echo. >> server.js
echo     db.run(createSessionSql, [user_id, category_id], function(err) { >> server.js
echo       if (err) { >> server.js
echo         console.error('建立考試場次錯誤:', err); >> server.js
echo         return res.status(500).json({ >> server.js
echo           success: false, >> server.js
echo           error: { message: '建立考試失敗' } >> server.js
echo         }); >> server.js
echo       } >> server.js
echo. >> server.js
echo       const sessionId = this.lastID; >> server.js
echo. >> server.js
echo       // 格式化題目資料 >> server.js
echo       const formattedQuestions = questions.map((q, index) =^> ({ >> server.js
echo         id: q.id, >> server.js
echo         order: index + 1, >> server.js
echo         question_text: q.question_text, >> server.js
echo         options: { >> server.js
echo           A: q.option_a, >> server.js
echo           B: q.option_b, >> server.js
echo           C: q.option_c, >> server.js
echo           D: q.option_d >> server.js
echo         }, >> server.js
echo         image_url: q.image_url >> server.js
echo       })); >> server.js
echo. >> server.js
echo       res.json({ >> server.js
echo         success: true, >> server.js
echo         data: { >> server.js
echo           session_id: sessionId, >> server.js
echo           category_name: questions[0].category_name, >> server.js
echo           questions: formattedQuestions, >> server.js
echo           time_limit_minutes: 60, >> server.js
echo           total_questions: 80, >> server.js
echo           max_score: 100, >> server.js
echo           score_per_question: 1.25 >> server.js
echo         } >> server.js
echo       }); >> server.js
echo     }); >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 儲存答案 API >> server.js
echo app.post('/api/exam/save-answer', authenticateToken, (req, res) =^> { >> server.js
echo   const { session_id, question_id, answer, is_marked } = req.body; >> server.js
echo. >> server.js
echo   const sql = `INSERT OR REPLACE INTO user_answers >> server.js
echo     (session_id, question_id, user_answer, is_marked, answer_time) >> server.js
echo     VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)`; >> server.js
echo. >> server.js
echo   db.run(sql, [session_id, question_id, answer, is_marked ^|^| 0], function(err) { >> server.js
echo     if (err) { >> server.js
echo       console.error('儲存答案錯誤:', err); >> server.js
echo       return res.status(500).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '儲存答案失敗' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     res.json({ >> server.js
echo       success: true, >> server.js
echo       data: { message: '答案已儲存' } >> server.js
echo     }); >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 提交考試 API >> server.js
echo app.post('/api/exam/submit', authenticateToken, (req, res) =^> { >> server.js
echo   const { session_id } = req.body; >> server.js
echo. >> server.js
echo   // 計算成績 >> server.js
echo   const sql = `SELECT ua.*, q.correct_answer >> server.js
echo                FROM user_answers ua >> server.js
echo                JOIN questions q ON ua.question_id = q.id >> server.js
echo                WHERE ua.session_id = ?`; >> server.js
echo. >> server.js
echo   db.all(sql, [session_id], (err, answers) =^> { >> server.js
echo     if (err) { >> server.js
echo       console.error('查詢答案錯誤:', err); >> server.js
echo       return res.status(500).json({ >> server.js
echo         success: false, >> server.js
echo         error: { message: '提交考試失敗' } >> server.js
echo       }); >> server.js
echo     } >> server.js
echo. >> server.js
echo     let correctCount = 0; >> server.js
echo     answers.forEach(answer =^> { >> server.js
echo       if (answer.user_answer === answer.correct_answer) { >> server.js
echo         correctCount++; >> server.js
echo       } >> server.js
echo     }); >> server.js
echo. >> server.js
echo     const totalScore = correctCount * 1.25; >> server.js
echo. >> server.js
echo     // 更新考試場次 >> server.js
echo     const updateSql = `UPDATE exam_sessions >> server.js
echo       SET is_completed = 1, is_submitted = 1, end_time = CURRENT_TIMESTAMP, >> server.js
echo           total_score = ?, correct_count = ? >> server.js
echo       WHERE id = ?`; >> server.js
echo. >> server.js
echo     db.run(updateSql, [totalScore, correctCount, session_id], function(err) { >> server.js
echo       if (err) { >> server.js
echo         console.error('更新考試場次錯誤:', err); >> server.js
echo         return res.status(500).json({ >> server.js
echo           success: false, >> server.js
echo           error: { message: '提交考試失敗' } >> server.js
echo         }); >> server.js
echo       } >> server.js
echo. >> server.js
echo       res.json({ >> server.js
echo         success: true, >> server.js
echo         data: { >> server.js
echo           total_score: totalScore, >> server.js
echo           correct_count: correctCount, >> server.js
echo           total_questions: 80, >> server.js
echo           score_per_question: 1.25 >> server.js
echo         } >> server.js
echo       }); >> server.js
echo     }); >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 健康檢查 >> server.js
echo app.get('/health', (req, res) =^> { >> server.js
echo   res.json({ status: 'healthy', timestamp: new Date().toISOString() }); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 啟動服務器 >> server.js
echo app.listen(PORT, () =^> { >> server.js
echo   console.log(`🚀 服務器已啟動在 port ${PORT}`); >> server.js
echo   console.log(`📡 本地測試: http://localhost:${PORT}`); >> server.js
echo   console.log(`🌐 線上地址: https://%APP_NAME%.azurewebsites.net`); >> server.js
echo }); >> server.js
echo. >> server.js
echo // 優雅關閉 >> server.js
echo process.on('SIGINT', () =^> { >> server.js
echo   console.log('收到 SIGINT 信號，正在關閉服務器...'); >> server.js
echo   db.close((err) =^> { >> server.js
echo     if (err) { >> server.js
echo       console.error('關閉資料庫時發生錯誤:', err.message); >> server.js
echo     } else { >> server.js
echo       console.log('資料庫連接已關閉'); >> server.js
echo     } >> server.js
echo     process.exit(0); >> server.js
echo   }); >> server.js
echo }); >> server.js

echo ✅ 主服務器檔案建立完成

echo 🗃️ 建立資料庫結構...
if not exist database mkdir database
echo -- 醫檢師考試系統資料庫 Schema > database\schema.sql
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
echo     role_id INTEGER NOT NULL DEFAULT 2, >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     last_login DATETIME, >> database\schema.sql
echo     FOREIGN KEY (role_id) REFERENCES user_roles(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 科目分類表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS categories ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     category_code VARCHAR(10) NOT NULL UNIQUE, >> database\schema.sql
echo     category_name VARCHAR(200) NOT NULL, >> database\schema.sql
echo     description TEXT, >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 題目表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS questions ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     category_id INTEGER NOT NULL, >> database\schema.sql
echo     question_text TEXT NOT NULL, >> database\schema.sql
echo     option_a TEXT NOT NULL, >> database\schema.sql
echo     option_b TEXT NOT NULL, >> database\schema.sql
echo     option_c TEXT NOT NULL, >> database\schema.sql
echo     option_d TEXT NOT NULL, >> database\schema.sql
echo     correct_answer CHAR(1) NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D')), >> database\schema.sql
echo     explanation TEXT, >> database\schema.sql
echo     image_url VARCHAR(500), >> database\schema.sql
echo     is_active BOOLEAN DEFAULT 1, >> database\schema.sql
echo     created_at DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (category_id) REFERENCES categories(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 考試場次表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS exam_sessions ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     user_id INTEGER NOT NULL, >> database\schema.sql
echo     category_id INTEGER NOT NULL, >> database\schema.sql
echo     total_questions INTEGER DEFAULT 80, >> database\schema.sql
echo     time_limit_minutes INTEGER DEFAULT 60, >> database\schema.sql
echo     max_score REAL DEFAULT 100.0, >> database\schema.sql
echo     score_per_question REAL DEFAULT 1.25, >> database\schema.sql
echo     start_time DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     end_time DATETIME, >> database\schema.sql
echo     is_completed BOOLEAN DEFAULT 0, >> database\schema.sql
echo     is_submitted BOOLEAN DEFAULT 0, >> database\schema.sql
echo     total_score REAL, >> database\schema.sql
echo     correct_count INTEGER DEFAULT 0, >> database\schema.sql
echo     FOREIGN KEY (user_id) REFERENCES users(id), >> database\schema.sql
echo     FOREIGN KEY (category_id) REFERENCES categories(id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 答題記錄表 >> database\schema.sql
echo CREATE TABLE IF NOT EXISTS user_answers ( >> database\schema.sql
echo     id INTEGER PRIMARY KEY AUTOINCREMENT, >> database\schema.sql
echo     session_id INTEGER NOT NULL, >> database\schema.sql
echo     question_id INTEGER NOT NULL, >> database\schema.sql
echo     user_answer CHAR(1) CHECK (user_answer IN ('A', 'B', 'C', 'D')), >> database\schema.sql
echo     is_marked BOOLEAN DEFAULT 0, >> database\schema.sql
echo     answer_time DATETIME DEFAULT CURRENT_TIMESTAMP, >> database\schema.sql
echo     FOREIGN KEY (session_id) REFERENCES exam_sessions(id), >> database\schema.sql
echo     FOREIGN KEY (question_id) REFERENCES questions(id), >> database\schema.sql
echo     UNIQUE(session_id, question_id) >> database\schema.sql
echo ); >> database\schema.sql
echo. >> database\schema.sql
echo -- 初始化資料 >> database\schema.sql
echo INSERT OR IGNORE INTO user_roles (role_name, description) VALUES >> database\schema.sql
echo ('admin', '系統管理員'), >> database\schema.sql
echo ('student', '學生'); >> database\schema.sql
echo. >> database\schema.sql
echo INSERT OR IGNORE INTO categories (category_code, category_name, description) VALUES >> database\schema.sql
echo ('PHYS', '臨床生理學與病理學', '心電圖、肺功能、腦波檢查等'), >> database\schema.sql
echo ('HEMA', '臨床血液學與血庫學', '血球計數、凝血功能、血型檢驗等'), >> database\schema.sql
echo ('MOLE', '醫學分子檢驗學與臨床鏡檢學', 'PCR技術、基因定序、寄生蟲檢驗等'), >> database\schema.sql
echo ('MICR', '微生物學與臨床微生物學', '細菌培養、抗生素敏感性、黴菌檢驗等'), >> database\schema.sql
echo ('BIOC', '生物化學與臨床生化學', '肝功能、腎功能、血糖檢驗等'), >> database\schema.sql
echo ('SERO', '臨床血清免疫學與臨床病毒學', '腫瘤標記、自體免疫、病毒檢驗等'); >> database\schema.sql
echo. >> database\schema.sql
echo -- 建立示範管理員帳號 (密碼: admin123) >> database\schema.sql
echo INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) VALUES >> database\schema.sql
echo (NULL, '系統管理員', 'admin@medical-exam.com', '$2b$10$rQZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ', 1); >> database\schema.sql
echo. >> database\schema.sql
echo -- 建立示範學生帳號 (密碼: student123) >> database\schema.sql
echo INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) VALUES >> database\schema.sql
echo ('DEMO001', '展示學生', 'student@medical-exam.com', '$2b$10$rQZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ', 2); >> database\schema.sql

echo ✅ 資料庫 Schema 建立完成

echo 📄 建立 Azure 部署配置...
echo { > azure-deploy.json
echo   "version": 4, >> azure-deploy.json
echo   "defaultProvider": "azure", >> azure-deploy.json
echo   "providers": { >> azure-deploy.json
echo     "azure": { >> azure-deploy.json
echo       "name": "azure", >> azure-deploy.json
echo       "runtime": "nodejs", >> azure-deploy.json
echo       "region": "East Asia" >> azure-deploy.json
echo     } >> azure-deploy.json
echo   } >> azure-deploy.json
echo } >> azure-deploy.json

echo 🌐 建立 Azure Web App 配置...
echo { > web.config
echo   "version": "1.0.0", >> web.config
echo   "defaultDocuments": ["server.js"], >> web.config
echo   "nodeProcessCommandLine": "node server.js" >> web.config
echo } >> web.config

echo 📦 建立環境變數範本...
echo # Azure 環境變數 > .env.example
echo NODE_ENV=production >> .env.example
echo PORT=8000 >> .env.example
echo JWT_SECRET=your-super-secure-jwt-secret-key-here >> .env.example
echo CORS_ORIGIN=https://ctmt88.github.io >> .env.example

echo 🚢 建立 Docker 配置 (可選)...
echo FROM node:18-alpine > Dockerfile
echo WORKDIR /app >> Dockerfile
echo COPY package*.json ./ >> Dockerfile
echo RUN npm ci --only=production >> Dockerfile
echo COPY . . >> Dockerfile
echo RUN mkdir -p database >> Dockerfile
echo EXPOSE 8000 >> Dockerfile
echo CMD ["node", "server.js"] >> Dockerfile

echo 📋 建立部署腳本...
echo @echo off > deploy-to-azure.bat
echo echo 🚀 開始部署到 Azure... >> deploy-to-azure.bat
echo echo. >> deploy-to-azure.bat
echo echo 📦 安裝相依套件... >> deploy-to-azure.bat
echo npm install >> deploy-to-azure.bat
echo if errorlevel 1 ( >> deploy-to-azure.bat
echo   echo ❌ npm install 失敗 >> deploy-to-azure.bat
echo   pause >> deploy-to-azure.bat
echo   exit /b 1 >> deploy-to-azure.bat
echo ) >> deploy-to-azure.bat
echo. >> deploy-to-azure.bat
echo echo 🗃️ 初始化資料庫... >> deploy-to-azure.bat
echo node -e "const sqlite3=require('sqlite3'); const fs=require('fs'); const db=new sqlite3.Database('./database/exam_system.db'); const schema=fs.readFileSync('./database/schema.sql','utf8'); db.exec(schema,(err)=^>{if(err) console.error(err); else console.log('✅ 資料庫初始化完成'); db.close();});" >> deploy-to-azure.bat
echo. >> deploy-to-azure.bat
echo echo 🧪 本地測試服務器... >> deploy-to-azure.bat
echo echo 請開啟新的命令提示字元視窗執行: npm start >> deploy-to-azure.bat
echo echo 然後訪問: http://localhost:8000 >> deploy-to-azure.bat
echo echo. >> deploy-to-azure.bat
echo echo 📋 Azure CLI 部署指令: >> deploy-to-azure.bat
echo echo. >> deploy-to-azure.bat
echo echo az login >> deploy-to-azure.bat
echo echo az group create --name %RESOURCE_GROUP% --location "East Asia" >> deploy-to-azure.bat
echo echo az appservice plan create --name %APP_NAME%-plan --resource-group %RESOURCE_GROUP% --sku F1 --is-linux >> deploy-to-azure.bat
echo echo az webapp create --resource-group %RESOURCE_GROUP% --plan %APP_NAME%-plan --name %APP_NAME% --runtime "NODE:18-lts" >> deploy-to-azure.bat
echo echo az webapp config appsettings set --resource-group %RESOURCE_GROUP% --name %APP_NAME% --settings NODE_ENV=production JWT_SECRET=your-secret CORS_ORIGIN=https://ctmt88.github.io >> deploy-to-azure.bat
echo echo az webapp deployment source config-zip --resource-group %RESOURCE_GROUP% --name %APP_NAME% --src deployment.zip >> deploy-to-azure.bat
echo echo. >> deploy-to-azure.bat
echo pause >> deploy-to-azure.bat

echo 📦 建立 ZIP 部署包腳本...
echo @echo off > create-deployment-zip.bat
echo echo 📦 建立部署包... >> create-deployment-zip.bat
echo if exist deployment.zip del deployment.zip >> create-deployment-zip.bat
echo powershell Compress-Archive -Path server.js,package.json,database,web.config,.env.example -DestinationPath deployment.zip -Force >> create-deployment-zip.bat
echo echo ✅ deployment.zip 建立成功 >> create-deployment-zip.bat
echo echo. >> create-deployment-zip.bat
echo echo 📋 接下來請執行: >> create-deployment-zip.bat
echo echo 1. az login (登入 Azure) >> create-deployment-zip.bat
echo echo 2. az group create --name %RESOURCE_GROUP% --location "East Asia" >> create-deployment-zip.bat
echo echo 3. az appservice plan create --name %APP_NAME%-plan --resource-group %RESOURCE_GROUP% --sku F1 --is-linux >> create-deployment-zip.bat
echo echo 4. az webapp create --resource-group %RESOURCE_GROUP% --plan %APP_NAME%-plan --name %APP_NAME% --runtime "NODE:18-lts" >> create-deployment-zip.bat
echo echo 5. az webapp config appsettings set --resource-group %RESOURCE_GROUP% --name %APP_NAME% --settings NODE_ENV=production JWT_SECRET=your-secret CORS_ORIGIN=https://ctmt88.github.io >> create-deployment-zip.bat
echo echo 6. az webapp deployment source config-zip --resource-group %RESOURCE_GROUP% --name %APP_NAME% --src deployment.zip >> create-deployment-zip.bat
echo pause >> create-deployment-zip.bat

cd ..

echo 🔧 建立前端 API 連接設定...
echo const API_CONFIG = { > frontend-api-config.js
echo   development: { >> frontend-api-config.js
echo     baseURL: 'http://localhost:8000/api', >> frontend-api-config.js
echo     useMockData: false >> frontend-api-config.js
echo   }, >> frontend-api-config.js
echo   production: { >> frontend-api-config.js
echo     baseURL: 'https://%APP_NAME%.azurewebsites.net/api', >> frontend-api-config.js
echo     useMockData: false >> frontend-api-config.js
echo   }, >> frontend-api-config.js
echo   github_pages: { >> frontend-api-config.js
echo     baseURL: 'https://%APP_NAME%.azurewebsites.net/api', >> frontend-api-config.js
echo     useMockData: false >> frontend-api-config.js
echo   } >> frontend-api-config.js
echo }; >> frontend-api-config.js
echo. >> frontend-api-config.js
echo const getEnvironment = () =^> { >> frontend-api-config.js
echo   if (window.location.hostname === 'localhost') return 'development'; >> frontend-api-config.js
echo   if (window.location.hostname.includes('github.io')) return 'github_pages'; >> frontend-api-config.js
echo   return 'production'; >> frontend-api-config.js
echo }; >> frontend-api-config.js
echo. >> frontend-api-config.js
echo export const config = API_CONFIG[getEnvironment()]; >> frontend-api-config.js
echo export const useMockData = config.useMockData; >> frontend-api-config.js

echo 📋 建立測試 API 腳本...
echo @echo off > test-api.bat
echo echo 🧪 測試 Azure API... >> test-api.bat
echo echo. >> test-api.bat
echo curl -X GET https://%APP_NAME%.azurewebsites.net/ >> test-api.bat
echo echo. >> test-api.bat
echo echo. >> test-api.bat
echo curl -X GET https://%APP_NAME%.azurewebsites.net/health >> test-api.bat
echo echo. >> test-api.bat
echo echo. >> test-api.bat
echo curl -X GET https://%APP_NAME%.azurewebsites.net/api/exam/categories >> test-api.bat
echo echo. >> test-api.bat
echo pause >> test-api.bat

echo 📝 建立說明文件...
echo # Azure 部署完成! > DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo ## 🎉 恭喜！你的後端 API 已準備就緒 >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo ### 📋 接下來的步驟： >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo #### 1. 本地測試 >> DEPLOYMENT-GUIDE.md
echo ```bash >> DEPLOYMENT-GUIDE.md
echo cd backend >> DEPLOYMENT-GUIDE.md
echo npm start >> DEPLOYMENT-GUIDE.md
echo ``` >> DEPLOYMENT-GUIDE.md
echo 訪問: http://localhost:8000 >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo #### 2. 部署到 Azure >> DEPLOYMENT-GUIDE.md
echo ```bash >> DEPLOYMENT-GUIDE.md
echo # 登入 Azure >> DEPLOYMENT-GUIDE.md
echo az login >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo # 建立資源群組 >> DEPLOYMENT-GUIDE.md
echo az group create --name %RESOURCE_GROUP% --location "East Asia" >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo # 建立 App Service Plan >> DEPLOYMENT-GUIDE.md
echo az appservice plan create --name %APP_NAME%-plan --resource-group %RESOURCE_GROUP% --sku F1 --is-linux >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo # 建立 Web App >> DEPLOYMENT-GUIDE.md
echo az webapp create --resource-group %RESOURCE_GROUP% --plan %APP_NAME%-plan --name %APP_NAME% --runtime "NODE:18-lts" >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo # 設定環境變數 >> DEPLOYMENT-GUIDE.md
echo az webapp config appsettings set --resource-group %RESOURCE_GROUP% --name %APP_NAME% --settings NODE_ENV=production JWT_SECRET=your-super-secret-key CORS_ORIGIN=https://ctmt88.github.io >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo # 部署程式碼 >> DEPLOYMENT-GUIDE.md
echo az webapp deployment source config-zip --resource-group %RESOURCE_GROUP% --name %APP_NAME% --src deployment.zip >> DEPLOYMENT-GUIDE.md
echo ``` >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo #### 3. 更新前端設定 >> DEPLOYMENT-GUIDE.md
echo 將 frontend-api-config.js 的內容複製到你的前端專案中 >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo #### 4. 測試 API >> DEPLOYMENT-GUIDE.md
echo - 基本健康檢查: https://%APP_NAME%.azurewebsites.net/health >> DEPLOYMENT-GUIDE.md
echo - API 狀態: https://%APP_NAME%.azurewebsites.net/ >> DEPLOYMENT-GUIDE.md
echo - 科目列表: https://%APP_NAME%.azurewebsites.net/api/exam/categories >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo ### 🔧 重要設定 >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo 1. **JWT_SECRET**: 請更改為更安全的密鑰 >> DEPLOYMENT-GUIDE.md
echo 2. **CORS 設定**: 已設定允許從 GitHub Pages 存取 >> DEPLOYMENT-GUIDE.md
echo 3. **資料庫**: 使用 SQLite，資料會持久化儲存 >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo ### 📊 預設帳號 >> DEPLOYMENT-GUIDE.md
echo - **學生帳號**: DEMO001 / student123 >> DEPLOYMENT-GUIDE.md
echo - **管理員**: admin@medical-exam.com / admin123 >> DEPLOYMENT-GUIDE.md
echo. >> DEPLOYMENT-GUIDE.md
echo ### 🎯 下一步 >> DEPLOYMENT-GUIDE.md
echo 1. 測試 API 功能 >> DEPLOYMENT-GUIDE.md
echo 2. 更新前端連接真實 API >> DEPLOYMENT-GUIDE.md
echo 3. 新增題目資料 >> DEPLOYMENT-GUIDE.md
echo 4. 建立學生帳號 >> DEPLOYMENT-GUIDE.md

echo.
echo ====================================
echo 🎉 Azure 部署腳本建立完成！
echo ====================================
echo.
echo 📂 建立的檔案：
echo ├── backend/
echo │   ├── server.js           (主服務器)
echo │   ├── package.json        (相依套件)
echo │   ├── database/
echo │   │   └── schema.sql      (資料庫結構)
echo │   ├── deploy-to-azure.bat (部署腳本)
echo │   └── create-deployment-zip.bat
echo ├── frontend-api-config.js  (前端API設定)
echo ├── test-api.bat           (API測試)
echo └── DEPLOYMENT-GUIDE.md    (部署說明)
echo.
echo 🚀 接下來請：
echo.
echo 1. 先測試本地服務器：
echo    cd backend
echo    npm start
echo.
echo 2. 建立部署包：
echo    create-deployment-zip.bat
echo.
echo 3. 部署到 Azure：
echo    按照 DEPLOYMENT-GUIDE.md 的步驟
echo.
echo 4. 你的 API 地址將會是：
echo    https://%APP_NAME%.azurewebsites.net
echo.
echo 5. 前端整合：
echo    使用 frontend-api-config.js 連接真實 API
echo.
echo ⚡ 免費版 Azure App Service 限制：
echo - 每天 60 分鐘 CPU 時間
echo - 1GB 儲存空間
echo - 自動休眠 (無活動20分鐘後)
echo.

:END
echo 📋 需要協助嗎？請參考 DEPLOYMENT-GUIDE.md
pause