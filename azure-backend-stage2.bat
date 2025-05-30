@echo off
chcp 65001 >nul
echo ====================================
echo Azure 後端系統 - 第二階段
echo 建立資料庫初始化和基本模型
echo ====================================
echo.

cd backend

echo 🗃️ 建立資料庫初始化腳本...

REM database/init.js
echo const sqlite3 = require('sqlite3').verbose() > database\init.js
echo const fs = require('fs') >> database\init.js
echo const path = require('path') >> database\init.js
echo const bcrypt = require('bcryptjs') >> database\init.js
echo require('dotenv').config() >> database\init.js
echo. >> database\init.js
echo const dbPath = process.env.DB_PATH ^|^| './database/exam_system.db' >> database\init.js
echo const schemaPath = './database/schema.sql' >> database\init.js
echo. >> database\init.js
echo async function initDatabase() { >> database\init.js
echo   try { >> database\init.js
echo     console.log('🚀 開始初始化資料庫...') >> database\init.js
echo. >> database\init.js
echo     // 確保資料庫目錄存在 >> database\init.js
echo     const dbDir = path.dirname(dbPath) >> database\init.js
echo     if (!fs.existsSync(dbDir)) { >> database\init.js
echo       fs.mkdirSync(dbDir, { recursive: true }) >> database\init.js
echo     } >> database\init.js
echo. >> database\init.js
echo     const db = new sqlite3.Database(dbPath) >> database\init.js
echo. >> database\init.js
echo     // 讀取並執行 schema >> database\init.js
echo     const schema = fs.readFileSync(schemaPath, 'utf8') >> database\init.js
echo     const statements = schema.split(';').filter(stmt =^> stmt.trim()) >> database\init.js
echo. >> database\init.js
echo     for (const statement of statements) { >> database\init.js
echo       await new Promise((resolve, reject) =^> { >> database\init.js
echo         db.run(statement, (err) =^> { >> database\init.js
echo           if (err) reject(err) >> database\init.js
echo           else resolve() >> database\init.js
echo         }) >> database\init.js
echo       }) >> database\init.js
echo     } >> database\init.js
echo. >> database\init.js
echo     console.log('✅ 資料庫架構建立完成') >> database\init.js
echo. >> database\init.js
echo     // 初始化基礎資料 >> database\init.js
echo     await initBasicData(db) >> database\init.js
echo. >> database\init.js
echo     db.close() >> database\init.js
echo     console.log('🎉 資料庫初始化完成！') >> database\init.js
echo   } catch (error) { >> database\init.js
echo     console.error('❌ 資料庫初始化失敗:', error) >> database\init.js
echo     process.exit(1) >> database\init.js
echo   } >> database\init.js
echo } >> database\init.js
echo. >> database\init.js
echo async function initBasicData(db) { >> database\init.js
echo   console.log('📝 初始化基礎資料...') >> database\init.js
echo. >> database\init.js
echo   // 初始化角色 >> database\init.js
echo   await runQuery(db, >> database\init.js
echo     `INSERT OR IGNORE INTO user_roles (role_name, description) VALUES >> database\init.js
echo      ('admin', '系統管理員'), >> database\init.js
echo      ('student', '學生')` >> database\init.js
echo   ) >> database\init.js
echo. >> database\init.js
echo   // 初始化科目分類 >> database\init.js
echo   await runQuery(db, >> database\init.js
echo     `INSERT OR IGNORE INTO categories (category_code, category_name, description) VALUES >> database\init.js
echo      ('PHYS', '臨床生理學與病理學', '包含生理學、病理學相關內容'), >> database\init.js
echo      ('HEMA', '臨床血液學與血庫學', '包含血液學、血庫學相關內容'), >> database\init.js
echo      ('MOLE', '醫學分子檢驗學與臨床鏡檢學(包括寄生蟲學)', '包含分子檢驗、鏡檢、寄生蟲學相關內容'), >> database\init.js
echo      ('MICR', '微生物學與臨床微生物學(包括細菌與黴菌)', '包含微生物學、細菌學、黴菌學相關內容'), >> database\init.js
echo      ('BIOC', '生物化學與臨床生化學', '包含生物化學、臨床生化學相關內容'), >> database\init.js
echo      ('SERO', '臨床血清免疫學與臨床病毒學', '包含血清免疫學、病毒學相關內容')` >> database\init.js
echo   ) >> database\init.js
echo. >> database\init.js
echo   // 初始化主題分類 >> database\init.js
echo   await runQuery(db, >> database\init.js
echo     `INSERT OR IGNORE INTO topic_categories (category_id, topic_name, topic_code) VALUES >> database\init.js
echo      (1, '心電圖學', 'ECG'), (1, '肺功能檢查', 'PFT'), (1, '腦波檢查', 'EEG'), >> database\init.js
echo      (2, '血球計數', 'CBC'), (2, '凝血功能', 'COAG'), (2, '血型檢驗', 'BLOOD_TYPE'), >> database\init.js
echo      (3, 'PCR技術', 'PCR'), (3, '基因定序', 'SEQUENCING'), (3, '寄生蟲檢驗', 'PARASITE'), >> database\init.js
echo      (4, '細菌培養', 'CULTURE'), (4, '抗生素敏感性', 'AST'), (4, '黴菌檢驗', 'FUNGUS'), >> database\init.js
echo      (5, '肝功能檢查', 'LFT'), (5, '腎功能檢查', 'RFT'), (5, '糖尿病檢驗', 'DIABETES'), >> database\init.js
echo      (6, '腫瘤標記', 'TUMOR_MARKER'), (6, '自體免疫', 'AUTOIMMUNE'), (6, '病毒檢驗', 'VIRUS')` >> database\init.js
echo   ) >> database\init.js
echo. >> database\init.js
echo   // 建立預設管理員帳號 >> database\init.js
echo   const adminPassword = await bcrypt.hash('admin123', 10) >> database\init.js
echo   await runQuery(db, >> database\init.js
echo     `INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) >> database\init.js
echo      VALUES ('ADMIN', '系統管理員', 'admin@medical-exam.local', '${adminPassword}', 1)` >> database\init.js
echo   ) >> database\init.js
echo. >> database\init.js
echo   // 建立展示學生帳號 >> database\init.js
echo   const studentPassword = await bcrypt.hash('demo123', 10) >> database\init.js
echo   await runQuery(db, >> database\init.js
echo     `INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) >> database\init.js
echo      VALUES ('DEMO001', '展示學生', 'demo@medical-exam.local', '${studentPassword}', 2)` >> database\init.js
echo   ) >> database\init.js
echo. >> database\init.js
echo   console.log('✅ 基礎資料初始化完成') >> database\init.js
echo } >> database\init.js
echo. >> database\init.js
echo function runQuery(db, query) { >> database\init.js
echo   return new Promise((resolve, reject) =^> { >> database\init.js
echo     db.run(query, (err) =^> { >> database\init.js
echo       if (err) reject(err) >> database\init.js
echo       else resolve() >> database\init.js
echo     }) >> database\init.js
echo   }) >> database\init.js
echo } >> database\init.js
echo. >> database\init.js
echo if (require.main === module) { >> database\init.js
echo   initDatabase() >> database\init.js
echo } >> database\init.js
echo. >> database\init.js
echo module.exports = { initDatabase } >> database\init.js

echo ✅ 資料庫初始化腳本完成
echo.

echo 🏗️ 建立基本模型...

REM models/User.js
echo class User { > models\User.js
echo   constructor(db) { >> models\User.js
echo     this.db = db >> models\User.js
echo   } >> models\User.js
echo. >> models\User.js
echo   async findByStudentId(studentId) { >> models\User.js
echo     return new Promise((resolve, reject) =^> { >> models\User.js
echo       const query = ` >> models\User.js
echo         SELECT u.*, ur.role_name >> models\User.js
echo         FROM users u >> models\User.js
echo         JOIN user_roles ur ON u.role_id = ur.id >> models\User.js
echo         WHERE u.student_id = ? AND u.is_active = 1 >> models\User.js
echo       ` >> models\User.js
echo       this.db.get(query, [studentId], (err, row) =^> { >> models\User.js
echo         if (err) reject(err) >> models\User.js
echo         else resolve(row) >> models\User.js
echo       }) >> models\User.js
echo     }) >> models\User.js
echo   } >> models\User.js
echo. >> models\User.js
echo   async findByEmail(email) { >> models\User.js
echo     return new Promise((resolve, reject) =^> { >> models\User.js
echo       const query = ` >> models\User.js
echo         SELECT u.*, ur.role_name >> models\User.js
echo         FROM users u >> models\User.js
echo         JOIN user_roles ur ON u.role_id = ur.id >> models\User.js
echo         WHERE u.email = ? AND u.is_active = 1 >> models\User.js
echo       ` >> models\User.js
echo       this.db.get(query, [email], (err, row) =^> { >> models\User.js
echo         if (err) reject(err) >> models\User.js
echo         else resolve(row) >> models\User.js
echo       }) >> models\User.js
echo     }) >> models\User.js
echo   } >> models\User.js
echo. >> models\User.js
echo   async create(userData) { >> models\User.js
echo     return new Promise((resolve, reject) =^> { >> models\User.js
echo       const query = ` >> models\User.js
echo         INSERT INTO users (student_id, name, email, password_hash, role_id) >> models\User.js
echo         VALUES (?, ?, ?, ?, ?) >> models\User.js
echo       ` >> models\User.js
echo       this.db.run(query, [userData.student_id, userData.name, userData.email, userData.password_hash, userData.role_id], >> models\User.js
echo         function(err) { >> models\User.js
echo           if (err) reject(err) >> models\User.js
echo           else resolve(this.lastID) >> models\User.js
echo         }) >> models\User.js
echo     }) >> models\User.js
echo   } >> models\User.js
echo. >> models\User.js
echo   async updateLastLogin(userId) { >> models\User.js
echo     return new Promise((resolve, reject) =^> { >> models\User.js
echo       const query = 'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?' >> models\User.js
echo       this.db.run(query, [userId], (err) =^> { >> models\User.js
echo         if (err) reject(err) >> models\User.js
echo         else resolve() >> models\User.js
echo       }) >> models\User.js
echo     }) >> models\User.js
echo   } >> models\User.js
echo } >> models\User.js
echo. >> models\User.js
echo module.exports = User >> models\User.js

echo ✅ User 模型完成
echo.

REM models/Question.js
echo class Question { > models\Question.js
echo   constructor(db) { >> models\Question.js
echo     this.db = db >> models\Question.js
echo   } >> models\Question.js
echo. >> models\Question.js
echo   async getRandomQuestions(categoryId, count = 80) { >> models\Question.js
echo     return new Promise((resolve, reject) =^> { >> models\Question.js
echo       const query = ` >> models\Question.js
echo         SELECT q.*, tc.topic_name, c.category_name >> models\Question.js
echo         FROM questions q >> models\Question.js
echo         LEFT JOIN topic_categories tc ON q.topic_category_id = tc.id >> models\Question.js
echo         JOIN categories c ON q.category_id = c.id >> models\Question.js
echo         WHERE q.category_id = ? AND q.is_active = 1 >> models\Question.js
echo         ORDER BY RANDOM() >> models\Question.js
echo         LIMIT ? >> models\Question.js
echo       ` >> models\Question.js
echo       this.db.all(query, [categoryId, count], (err, rows) =^> { >> models\Question.js
echo         if (err) reject(err) >> models\Question.js
echo         else resolve(rows) >> models\Question.js
echo       }) >> models\Question.js
echo     }) >> models\Question.js
echo   } >> models\Question.js
echo. >> models\Question.js
echo   async getById(id) { >> models\Question.js
echo     return new Promise((resolve, reject) =^> { >> models\Question.js
echo       const query = ` >> models\Question.js
echo         SELECT q.*, tc.topic_name, c.category_name >> models\Question.js
echo         FROM questions q >> models\Question.js
echo         LEFT JOIN topic_categories tc ON q.topic_category_id = tc.id >> models\Question.js
echo         JOIN categories c ON q.category_id = c.id >> models\Question.js
echo         WHERE q.id = ? AND q.is_active = 1 >> models\Question.js
echo       ` >> models\Question.js
echo       this.db.get(query, [id], (err, row) =^> { >> models\Question.js
echo         if (err) reject(err) >> models\Question.js
echo         else resolve(row) >> models\Question.js
echo       }) >> models\Question.js
echo     }) >> models\Question.js
echo   } >> models\Question.js
echo. >> models\Question.js
echo   async create(questionData) { >> models\Question.js
echo     return new Promise((resolve, reject) =^> { >> models\Question.js
echo       const query = ` >> models\Question.js
echo         INSERT INTO questions ( >> models\Question.js
echo           question_number, exam_year, exam_semester, category_id, >> models\Question.js
echo           topic_category_id, question_text, option_a, option_b, >> models\Question.js
echo           option_c, option_d, correct_answer, explanation, >> models\Question.js
echo           image_url, difficulty_level, created_by >> models\Question.js
echo         ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) >> models\Question.js
echo       ` >> models\Question.js
echo       const values = [ >> models\Question.js
echo         questionData.question_number, questionData.exam_year, questionData.exam_semester, >> models\Question.js
echo         questionData.category_id, questionData.topic_category_id, questionData.question_text, >> models\Question.js
echo         questionData.option_a, questionData.option_b, questionData.option_c, questionData.option_d, >> models\Question.js
echo         questionData.correct_answer, questionData.explanation, questionData.image_url, >> models\Question.js
echo         questionData.difficulty_level, questionData.created_by >> models\Question.js
echo       ] >> models\Question.js
echo       this.db.run(query, values, function(err) { >> models\Question.js
echo         if (err) reject(err) >> models\Question.js
echo         else resolve(this.lastID) >> models\Question.js
echo       }) >> models\Question.js
echo     }) >> models\Question.js
echo   } >> models\Question.js
echo. >> models\Question.js
echo   async getQuestionCount(categoryId) { >> models\Question.js
echo     return new Promise((resolve, reject) =^> { >> models\Question.js
echo       const query = 'SELECT COUNT(*) as count FROM questions WHERE category_id = ? AND is_active = 1' >> models\Question.js
echo       this.db.get(query, [categoryId], (err, row) =^> { >> models\Question.js
echo         if (err) reject(err) >> models\Question.js
echo         else resolve(row.count) >> models\Question.js
echo       }) >> models\Question.js
echo     }) >> models\Question.js
echo   } >> models\Question.js
echo } >> models\Question.js
echo. >> models\Question.js
echo module.exports = Question >> models\Question.js

echo ✅ Question 模型完成
echo.

REM models/Category.js
echo class Category { > models\Category.js
echo   constructor(db) { >> models\Category.js
echo     this.db = db >> models\Category.js
echo   } >> models\Category.js
echo. >> models\Category.js
echo   async getAll() { >> models\Category.js
echo     return new Promise((resolve, reject) =^> { >> models\Category.js
echo       const query = 'SELECT * FROM categories WHERE is_active = 1 ORDER BY id' >> models\Category.js
echo       this.db.all(query, (err, rows) =^> { >> models\Category.js
echo         if (err) reject(err) >> models\Category.js
echo         else resolve(rows) >> models\Category.js
echo       }) >> models\Category.js
echo     }) >> models\Category.js
echo   } >> models\Category.js
echo. >> models\Category.js
echo   async getById(id) { >> models\Category.js
echo     return new Promise((resolve, reject) =^> { >> models\Category.js
echo       const query = 'SELECT * FROM categories WHERE id = ? AND is_active = 1' >> models\Category.js
echo       this.db.get(query, [id], (err, row) =^> { >> models\Category.js
echo         if (err) reject(err) >> models\Category.js
echo         else resolve(row) >> models\Category.js
echo       }) >> models\Category.js
echo     }) >> models\Category.js
echo   } >> models\Category.js
echo. >> models\Category.js
echo   async getTopicCategories(categoryId) { >> models\Category.js
echo     return new Promise((resolve, reject) =^> { >> models\Category.js
echo       const query = ` >> models\Category.js
echo         SELECT tc.*, c.category_name >> models\Category.js
echo         FROM topic_categories tc >> models\Category.js
echo         JOIN categories c ON tc.category_id = c.id >> models\Category.js
echo         WHERE tc.category_id = ? AND tc.is_active = 1 >> models\Category.js
echo         ORDER BY tc.topic_name >> models\Category.js
echo       ` >> models\Category.js
echo       this.db.all(query, [categoryId], (err, rows) =^> { >> models\Category.js
echo         if (err) reject(err) >> models\Category.js
echo         else resolve(rows) >> models\Category.js
echo       }) >> models\Category.js
echo     }) >> models\Category.js
echo   } >> models\Category.js
echo } >> models\Category.js
echo. >> models\Category.js
echo module.exports = Category >> models\Category.js

echo ✅ Category 模型完成
echo.

echo 🧪 測試資料庫初始化...
npm install
if %ERRORLEVEL% EQU 0 (
    echo ✅ 套件安裝成功
    node database/init.js
    if %ERRORLEVEL% EQU 0 (
        echo ✅ 資料庫初始化成功
    ) else (
        echo ❌ 資料庫初始化失敗
    )
) else (
    echo ❌ 套件安裝失敗
)

echo.

echo 🏗️ 建立第三階段批次檔...

REM 建立第三階段批次檔
echo @echo off > ..\azure-backend-stage3.bat
echo chcp 65001 ^>nul >> ..\azure-backend-stage3.bat
echo echo Azure 後端系統 - 第三階段 >> ..\azure-backend-stage3.bat
echo echo 建立 API 控制器和路由... >> ..\azure-backend-stage3.bat
echo cd backend >> ..\azure-backend-stage3.bat

echo ✅ 第二階段完成！
echo.

echo 📋 第二階段建立內容：
echo ✅ 資料庫初始化腳本 (database/init.js)
echo ✅ User 模型 (models/User.js)
echo ✅ Question 模型 (models/Question.js)
echo ✅ Category 模型 (models/Category.js)
echo ✅ 套件安裝和資料庫初始化測試
echo.

echo 🚀 下一步：
echo 1. 執行 azure-backend-stage3.bat 建立 API 控制器
echo 2. 執行 azure-backend-stage4.bat 建立服務器和部署設定
echo.

echo 🎯 預設帳號：
echo 管理員 - 學號：ADMIN，密碼：admin123
echo 學生 - 學號：DEMO001，密碼：demo123
echo.

echo ====================================
echo Azure 後端第二階段完成！
echo ====================================
pause