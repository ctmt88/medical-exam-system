const express = require('express'); 
const cors = require('cors'); 
const helmet = require('helmet'); 
const path = require('path'); 
const sqlite3 = require('sqlite3').verbose(); 
const bcrypt = require('bcryptjs'); 
const jwt = require('jsonwebtoken'); 
require('dotenv').config(); 
 
const app = express(); 
const PORT = process.env.PORT || 8000; 
const JWT_SECRET = process.env.JWT_SECRET || 'your-jwt-secret-key'; 
 
// 資料庫初始化 
const dbPath = process.env.NODE_ENV === 'production' ? 
  path.join(__dirname, 'database', 'exam_system.db') : 
  path.join(__dirname, 'database', 'exam_system.db'); 
 
const db = new sqlite3.Database(dbPath, (err) => { 
  if (err) { 
    console.error('❌ 資料庫連接失敗:', err.message); 
  } else { 
    console.log('✅ SQLite 資料庫連接成功'); 
  } 
}); 
 
// 中間件設定 
app.use(helmet()); 
app.use(cors({ 
  origin: ['https://ctmt88.github.io', 'http://localhost:5173'], 
  credentials: true 
})); 
app.use(express.json({ limit: '10mb' })); 
app.use(express.urlencoded({ extended: true })); 
 
// JWT 認證中間件 
const authenticateToken = (req, res, next) => { 
  const authHeader = req.headers['authorization']; 
 
  if (!token) { 
    return res.status(401).json({ success: false, error: { message: '需要認證 token' } }); 
  } 
 
  jwt.verify(token, JWT_SECRET, (err, user) => { 
    if (err) { 
      return res.status(403).json({ success: false, error: { message: 'Token 無效' } }); 
    } 
    req.user = user; 
    next(); 
  }); 
}; 
 
// 基本路由 
app.get('/', (req, res) => { 
  res.json({ 
    message: '醫檢師考試系統 API', 
    status: 'running', 
    version: '1.0.0', 
    endpoints: ['/api/auth/login', '/api/exam/categories', '/api/exam/start'] 
  }); 
}); 
 
// 登入 API 
app.post('/api/auth/login', (req, res) => { 
  const { student_id, password } = req.body; 
 
  // 驗證輸入 
  if (!student_id || !password) { 
    return res.status(400).json({ 
      success: false, 
      error: { message: '請提供學號和密碼' } 
    }); 
  } 
 
  // 查詢使用者 
  const sql = 'SELECT * FROM users WHERE student_id = ? AND is_active = 1'; 
  db.get(sql, [student_id], async (err, user) => { 
    if (err) { 
      console.error('資料庫查詢錯誤:', err); 
      return res.status(500).json({ 
        success: false, 
        error: { message: '伺服器錯誤' } 
      }); 
    } 
 
    if (!user) { 
      return res.status(401).json({ 
        success: false, 
        error: { message: '學號或密碼錯誤' } 
      }); 
    } 
 
    // 驗證密碼 
    const isValidPassword = await bcrypt.compare(password, user.password_hash); 
    if (!isValidPassword) { 
      return res.status(401).json({ 
        success: false, 
        error: { message: '學號或密碼錯誤' } 
      }); 
    } 
 
    // 生成 JWT token 
    const token = jwt.sign({ 
      id: user.id, 
      student_id: user.student_id, 
      role: user.role_id 
    }, JWT_SECRET, { expiresIn: '24h' }); 
 
    // 更新最後登入時間 
    db.run('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?', [user.id]); 
 
    res.json({ 
      success: true, 
      data: { 
        token, 
        user: { 
          id: user.id, 
          student_id: user.student_id, 
          name: user.name, 
          email: user.email 
        } 
      } 
    }); 
  }); 
}); 
 
// 取得科目列表 API 
app.get('/api/exam/categories', (req, res) => { 
  const sql = 'SELECT * FROM categories WHERE is_active = 1 ORDER BY id'; 
  db.all(sql, [], (err, categories) => { 
    if (err) { 
      console.error('查詢科目錯誤:', err); 
      return res.status(500).json({ 
        success: false, 
        error: { message: '伺服器錯誤' } 
      }); 
    } 
 
    res.json({ 
      success: true, 
      data: { categories } 
    }); 
  }); 
}); 
 
// 開始考試 API 
app.post('/api/exam/start', authenticateToken, (req, res) => { 
  const { category_id } = req.body; 
  const user_id = req.user.id; 
 
  if (!category_id) { 
    return res.status(400).json({ 
      success: false, 
      error: { message: '請選擇考試科目' } 
    }); 
  } 
 
  // 隨機抽取80題 
  const sql = `SELECT q.*, c.category_name 
               FROM questions q 
               JOIN categories c ON q.category_id = c.id 
               WHERE q.category_id = ? AND q.is_active = 1 
               ORDER BY RANDOM() LIMIT 80`; 
 
  db.all(sql, [category_id], (err, questions) => { 
    if (err) { 
      console.error('查詢題目錯誤:', err); 
      return res.status(500).json({ 
        success: false, 
        error: { message: '伺服器錯誤' } 
      }); 
    } 
 
    if (questions.length < 80) { 
      return res.status(400).json({ 
        success: false, 
        error: { message: '該科目題目數量不足80題' } 
      }); 
    } 
 
    // 建立考試場次 
    const createSessionSql = `INSERT INTO exam_sessions 
      (user_id, category_id, total_questions, time_limit_minutes, max_score, score_per_question, start_time) 
      VALUES (?, ?, 80, 60, 100, 1.25, CURRENT_TIMESTAMP)`; 
 
    db.run(createSessionSql, [user_id, category_id], function(err) { 
      if (err) { 
        console.error('建立考試場次錯誤:', err); 
        return res.status(500).json({ 
          success: false, 
          error: { message: '建立考試失敗' } 
        }); 
      } 
 
      const sessionId = this.lastID; 
 
      // 格式化題目資料 
      const formattedQuestions = questions.map((q, index) => ({ 
        id: q.id, 
        order: index + 1, 
        question_text: q.question_text, 
        options: { 
          A: q.option_a, 
          B: q.option_b, 
          C: q.option_c, 
          D: q.option_d 
        }, 
        image_url: q.image_url 
      })); 
 
      res.json({ 
        success: true, 
        data: { 
          session_id: sessionId, 
          category_name: questions[0].category_name, 
          questions: formattedQuestions, 
          time_limit_minutes: 60, 
          total_questions: 80, 
          max_score: 100, 
          score_per_question: 1.25 
        } 
      }); 
    }); 
  }); 
}); 
 
// 儲存答案 API 
app.post('/api/exam/save-answer', authenticateToken, (req, res) => { 
  const { session_id, question_id, answer, is_marked } = req.body; 
 
  const sql = `INSERT OR REPLACE INTO user_answers 
    (session_id, question_id, user_answer, is_marked, answer_time) 
    VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)`; 
 
  db.run(sql, [session_id, question_id, answer, is_marked || 0], function(err) { 
    if (err) { 
      console.error('儲存答案錯誤:', err); 
      return res.status(500).json({ 
        success: false, 
        error: { message: '儲存答案失敗' } 
      }); 
    } 
 
    res.json({ 
      success: true, 
      data: { message: '答案已儲存' } 
    }); 
  }); 
}); 
 
// 提交考試 API 
app.post('/api/exam/submit', authenticateToken, (req, res) => { 
  const { session_id } = req.body; 
 
  // 計算成績 
  const sql = `SELECT ua.*, q.correct_answer 
               FROM user_answers ua 
               JOIN questions q ON ua.question_id = q.id 
               WHERE ua.session_id = ?`; 
 
  db.all(sql, [session_id], (err, answers) => { 
    if (err) { 
      console.error('查詢答案錯誤:', err); 
      return res.status(500).json({ 
        success: false, 
        error: { message: '提交考試失敗' } 
      }); 
    } 
 
    let correctCount = 0; 
    answers.forEach(answer => { 
      if (answer.user_answer === answer.correct_answer) { 
        correctCount++; 
      } 
    }); 
 
    const totalScore = correctCount * 1.25; 
 
    // 更新考試場次 
    const updateSql = `UPDATE exam_sessions 
      SET is_completed = 1, is_submitted = 1, end_time = CURRENT_TIMESTAMP, 
          total_score = ?, correct_count = ? 
      WHERE id = ?`; 
 
    db.run(updateSql, [totalScore, correctCount, session_id], function(err) { 
      if (err) { 
        console.error('更新考試場次錯誤:', err); 
        return res.status(500).json({ 
          success: false, 
          error: { message: '提交考試失敗' } 
        }); 
      } 
 
      res.json({ 
        success: true, 
        data: { 
          total_score: totalScore, 
          correct_count: correctCount, 
          total_questions: 80, 
          score_per_question: 1.25 
        } 
      }); 
    }); 
  }); 
}); 
 
// 健康檢查 
app.get('/health', (req, res) => { 
  res.json({ status: 'healthy', timestamp: new Date().toISOString() }); 
}); 
 
// 啟動服務器 
app.listen(PORT, () => { 
  console.log(`🚀 服務器已啟動在 port ${PORT}`); 
  console.log(`📡 本地測試: http://localhost:${PORT}`); 
  console.log(`🌐 線上地址: https://ctmt88.azurewebsites.net`); 
}); 
 
// 優雅關閉 
process.on('SIGINT', () => { 
  console.log('收到 SIGINT 信號，正在關閉服務器...'); 
  db.close((err) => { 
    if (err) { 
      console.error('關閉資料庫時發生錯誤:', err.message); 
    } else { 
      console.log('資料庫連接已關閉'); 
    } 
    process.exit(0); 
  }); 
}); 
