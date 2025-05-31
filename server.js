const express = require('express') 
const cors = require('cors') 
const sqlite3 = require('sqlite3').verbose() 
const bcrypt = require('bcryptjs') 
const jwt = require('jsonwebtoken') 
 
const app = express() 
const PORT = process.env.PORT || 3000 
const JWT_SECRET = 'your-jwt-secret-key' 
 
// 中間件 
app.use(cors()) 
app.use(express.json()) 
 
// 資料庫連線 
const db = new sqlite3.Database('./database/exam_system.db', (err) => { 
  if (err) { 
    console.error('❌ 資料庫連線失敗:', err.message) 
  } else { 
    console.log('✅ 資料庫連線成功') 
  } 
}) 
 
// 登入 API 
app.post('/api/auth/login', (req, res) => { 
  const { student_id, password } = req.body 
ECHO is off.
  db.get('SELECT * FROM users WHERE student_id = ?', [student_id], (err, user) => { 
    if (err) { 
      return res.status(500).json({ success: false, error: { message: '伺服器錯誤' } }) 
    } 
    if (!user) { 
      return res.status(401).json({ success: false, error: { message: '學號或密碼錯誤' } }) 
    } 
ECHO is off.
    bcrypt.compare(password, user.password_hash, (err, isValid) => { 
      if (err || !isValid) { 
        return res.status(401).json({ success: false, error: { message: '學號或密碼錯誤' } }) 
      } 
ECHO is off.
      const token = jwt.sign({ userId: user.id, studentId: user.student_id }, JWT_SECRET, { expiresIn: '24h' }) 
      res.json({ 
        success: true, 
        data: { 
          token, 
          user: { id: user.id, student_id: user.student_id, name: user.name } 
        } 
      }) 
    }) 
  }) 
}) 
 
// 取得科目 API 
app.get('/api/exam/categories', (req, res) => { 
  db.all('SELECT * FROM categories WHERE is_active = 1', (err, categories) => { 
    if (err) { 
      return res.status(500).json({ success: false, error: { message: '伺服器錯誤' } }) 
    } 
    res.json({ success: true, data: { categories } }) 
  }) 
}) 
 
// 啟動服務器 
app.listen(PORT, () => { 
  console.log(`🚀 服務器啟動成功！`) 
  console.log(`📡 API 地址: http://localhost:${PORT}`) 
  console.log(`🔑 測試帳號: DEMO001 / demo123`) 
}) 
