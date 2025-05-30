const sqlite3 = require('sqlite3').verbose() 
const path = require('path') 
 
console.log('🚀 開始初始化資料庫...') 
 
const dbPath = './database/exam_system.db' 
console.log('資料庫路徑:', dbPath) 
 
const db = new sqlite3.Database(dbPath, (err) => { 
  if (err) { 
    console.error('❌ 資料庫連線失敗:', err.message) 
    process.exit(1) 
  } else { 
    console.log('✅ 資料庫連線成功') 
    initTables() 
  } 
}) 
 
function initTables() { 
  console.log('📝 建立資料表...') 
 
  // 建立角色表 
  db.run(`CREATE TABLE IF NOT EXISTS user_roles ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    role_name VARCHAR(50) NOT NULL UNIQUE, 
    description TEXT, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
  )`, (err) => { 
    if (err) console.error('角色表建立失敗:', err) 
    else console.log('✅ 角色表建立成功') 
  }) 
 
  // 建立使用者表 
  db.run(`CREATE TABLE IF NOT EXISTS users ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    student_id VARCHAR(20) UNIQUE, 
    name VARCHAR(100) NOT NULL, 
    email VARCHAR(255) UNIQUE, 
    password_hash VARCHAR(255) NOT NULL, 
    role_id INTEGER NOT NULL, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    last_login DATETIME 
  )`, (err) => { 
    if (err) console.error('使用者表建立失敗:', err) 
    else console.log('✅ 使用者表建立成功') 
  }) 
 
  // 建立科目表 
  db.run(`CREATE TABLE IF NOT EXISTS categories ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    category_code VARCHAR(10) NOT NULL UNIQUE, 
    category_name VARCHAR(200) NOT NULL, 
    description TEXT, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
  )`, (err) => { 
    if (err) console.error('科目表建立失敗:', err) 
    else console.log('✅ 科目表建立成功') 
    initData() 
  }) 
} 
 
function initData() { 
  console.log('📊 初始化基礎資料...') 
 
  // 插入角色 
  db.run(`INSERT OR IGNORE INTO user_roles (role_name, description) VALUES 
    ('admin', '系統管理員'), ('student', '學生')`, (err) => { 
    if (err) console.error('角色資料插入失敗:', err) 
    else console.log('✅ 角色資料初始化完成') 
  }) 
 
  // 插入科目 
  db.run(`INSERT OR IGNORE INTO categories (category_code, category_name, description) VALUES 
    ('PHYS', '臨床生理學與病理學', '包含生理學、病理學相關內容'), 
    ('HEMA', '臨床血液學與血庫學', '包含血液學、血庫學相關內容'), 
    ('MOLE', '醫學分子檢驗學與臨床鏡檢學', '包含分子檢驗、鏡檢相關內容'), 
    ('MICR', '微生物學與臨床微生物學', '包含微生物學相關內容'), 
    ('BIOC', '生物化學與臨床生化學', '包含生物化學相關內容'), 
    ('SERO', '臨床血清免疫學與臨床病毒學', '包含血清免疫學相關內容')`, (err) => { 
    if (err) console.error('科目資料插入失敗:', err) 
    else console.log('✅ 科目資料初始化完成') 
  }) 
 
  // 建立測試使用者 
  const bcrypt = require('bcryptjs') 
  const password = bcrypt.hashSync('demo123', 10) 
  db.run(`INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) VALUES 
    ('DEMO001', '展示學生', 'demo@test.com', '${password}', 2)`, (err) => { 
    if (err) console.error('測試使用者建立失敗:', err) 
    else console.log('✅ 測試使用者建立完成') 
    console.log('🎉 資料庫初始化完成！') 
    console.log('測試帳號：DEMO001 / demo123') 
    db.close() 
  }) 
} 
