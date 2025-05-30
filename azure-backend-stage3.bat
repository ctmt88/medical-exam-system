@echo off
chcp 65001 >nul
echo ====================================
echo Azure 後端系統 - 第三階段
echo 建立 API 控制器和路由
echo ====================================
echo.

cd backend

echo 🔧 建立中間件...

REM middleware/auth.js
echo const jwt = require('jsonwebtoken') > middleware\auth.js
echo const config = require('../config/config') >> middleware\auth.js
echo. >> middleware\auth.js
echo const authenticateToken = (req, res, next) =^> { >> middleware\auth.js
echo   const authHeader = req.headers['authorization'] >> middleware\auth.js
echo   const token = authHeader ^&^& authHeader.split(' ')[1] >> middleware\auth.js
echo. >> middleware\auth.js
echo   if (!token) { >> middleware\auth.js
echo     return res.status(401).json({ >> middleware\auth.js
echo       success: false, >> middleware\auth.js
echo       error: { message: '需要認證 token' } >> middleware\auth.js
echo     }) >> middleware\auth.js
echo   } >> middleware\auth.js
echo. >> middleware\auth.js
echo   jwt.verify(token, config.jwtSecret, (err, user) =^> { >> middleware\auth.js
echo     if (err) { >> middleware\auth.js
echo       return res.status(403).json({ >> middleware\auth.js
echo         success: false, >> middleware\auth.js
echo         error: { message: 'Token 無效或已過期' } >> middleware\auth.js
echo       }) >> middleware\auth.js
echo     } >> middleware\auth.js
echo     req.user = user >> middleware\auth.js
echo     next() >> middleware\auth.js
echo   }) >> middleware\auth.js
echo } >> middleware\auth.js
echo. >> middleware\auth.js
echo const requireRole = (role) =^> { >> middleware\auth.js
echo   return (req, res, next) =^> { >> middleware\auth.js
echo     if (req.user.role !== role) { >> middleware\auth.js
echo       return res.status(403).json({ >> middleware\auth.js
echo         success: false, >> middleware\auth.js
echo         error: { message: '權限不足' } >> middleware\auth.js
echo       }) >> middleware\auth.js
echo     } >> middleware\auth.js
echo     next() >> middleware\auth.js
echo   } >> middleware\auth.js
echo } >> middleware\auth.js
echo. >> middleware\auth.js
echo module.exports = { authenticateToken, requireRole } >> middleware\auth.js

echo ✅ 認證中間件完成
echo.

REM middleware/validation.js
echo const Joi = require('joi') > middleware\validation.js
echo. >> middleware\validation.js
echo const validate = (schema) =^> { >> middleware\validation.js
echo   return (req, res, next) =^> { >> middleware\validation.js
echo     const { error } = schema.validate(req.body) >> middleware\validation.js
echo     if (error) { >> middleware\validation.js
echo       return res.status(400).json({ >> middleware\validation.js
echo         success: false, >> middleware\validation.js
echo         error: { >> middleware\validation.js
echo           message: '輸入資料驗證失敗', >> middleware\validation.js
echo           details: error.details.map(d =^> d.message) >> middleware\validation.js
echo         } >> middleware\validation.js
echo       }) >> middleware\validation.js
echo     } >> middleware\validation.js
echo     next() >> middleware\validation.js
echo   } >> middleware\validation.js
echo } >> middleware\validation.js
echo. >> middleware\validation.js
echo // 驗證規則 >> middleware\validation.js
echo const schemas = { >> middleware\validation.js
echo   login: Joi.object({ >> middleware\validation.js
echo     student_id: Joi.string().required(), >> middleware\validation.js
echo     password: Joi.string().required() >> middleware\validation.js
echo   }), >> middleware\validation.js
echo. >> middleware\validation.js
echo   startExam: Joi.object({ >> middleware\validation.js
echo     category_id: Joi.number().integer().min(1).max(6).required() >> middleware\validation.js
echo   }), >> middleware\validation.js
echo. >> middleware\validation.js
echo   submitAnswer: Joi.object({ >> middleware\validation.js
echo     session_id: Joi.number().integer().required(), >> middleware\validation.js
echo     question_id: Joi.number().integer().required(), >> middleware\validation.js
echo     answer: Joi.string().valid('A', 'B', 'C', 'D').allow(null), >> middleware\validation.js
echo     is_marked: Joi.boolean().default(false) >> middleware\validation.js
echo   }) >> middleware\validation.js
echo } >> middleware\validation.js
echo. >> middleware\validation.js
echo module.exports = { validate, schemas } >> middleware\validation.js

echo ✅ 驗證中間件完成
echo.

echo 🎛️ 建立控制器...

REM controllers/authController.js
echo const bcrypt = require('bcryptjs') > controllers\authController.js
echo const jwt = require('jsonwebtoken') >> controllers\authController.js
echo const User = require('../models/User') >> controllers\authController.js
echo const database = require('../config/database') >> controllers\authController.js
echo const config = require('../config/config') >> controllers\authController.js
echo. >> controllers\authController.js
echo class AuthController { >> controllers\authController.js
echo   constructor() { >> controllers\authController.js
echo     this.userModel = new User(database.getDb()) >> controllers\authController.js
echo   } >> controllers\authController.js
echo. >> controllers\authController.js
echo   async login(req, res) { >> controllers\authController.js
echo     try { >> controllers\authController.js
echo       const { student_id, password } = req.body >> controllers\authController.js
echo. >> controllers\authController.js
echo       // 查找使用者 >> controllers\authController.js
echo       const user = await this.userModel.findByStudentId(student_id) >> controllers\authController.js
echo       if (!user) { >> controllers\authController.js
echo         return res.status(401).json({ >> controllers\authController.js
echo           success: false, >> controllers\authController.js
echo           error: { message: '學號或密碼錯誤' } >> controllers\authController.js
echo         }) >> controllers\authController.js
echo       } >> controllers\authController.js
echo. >> controllers\authController.js
echo       // 驗證密碼 >> controllers\authController.js
echo       const isValidPassword = await bcrypt.compare(password, user.password_hash) >> controllers\authController.js
echo       if (!isValidPassword) { >> controllers\authController.js
echo         return res.status(401).json({ >> controllers\authController.js
echo           success: false, >> controllers\authController.js
echo           error: { message: '學號或密碼錯誤' } >> controllers\authController.js
echo         }) >> controllers\authController.js
echo       } >> controllers\authController.js
echo. >> controllers\authController.js
echo       // 更新最後登入時間 >> controllers\authController.js
echo       await this.userModel.updateLastLogin(user.id) >> controllers\authController.js
echo. >> controllers\authController.js
echo       // 生成 JWT token >> controllers\authController.js
echo       const token = jwt.sign( >> controllers\authController.js
echo         { >> controllers\authController.js
echo           userId: user.id, >> controllers\authController.js
echo           studentId: user.student_id, >> controllers\authController.js
echo           role: user.role_name >> controllers\authController.js
echo         }, >> controllers\authController.js
echo         config.jwtSecret, >> controllers\authController.js
echo         { expiresIn: '24h' } >> controllers\authController.js
echo       ) >> controllers\authController.js
echo. >> controllers\authController.js
echo       res.json({ >> controllers\authController.js
echo         success: true, >> controllers\authController.js
echo         data: { >> controllers\authController.js
echo           token, >> controllers\authController.js
echo           user: { >> controllers\authController.js
echo             id: user.id, >> controllers\authController.js
echo             student_id: user.student_id, >> controllers\authController.js
echo             name: user.name, >> controllers\authController.js
echo             email: user.email, >> controllers\authController.js
echo             role: user.role_name >> controllers\authController.js
echo           } >> controllers\authController.js
echo         } >> controllers\authController.js
echo       }) >> controllers\authController.js
echo     } catch (error) { >> controllers\authController.js
echo       console.error('登入錯誤:', error) >> controllers\authController.js
echo       res.status(500).json({ >> controllers\authController.js
echo         success: false, >> controllers\authController.js
echo         error: { message: '伺服器錯誤' } >> controllers\authController.js
echo       }) >> controllers\authController.js
echo     } >> controllers\authController.js
echo   } >> controllers\authController.js
echo. >> controllers\authController.js
echo   async getProfile(req, res) { >> controllers\authController.js
echo     try { >> controllers\authController.js
echo       const user = await this.userModel.findByStudentId(req.user.studentId) >> controllers\authController.js
echo       if (!user) { >> controllers\authController.js
echo         return res.status(404).json({ >> controllers\authController.js
echo           success: false, >> controllers\authController.js
echo           error: { message: '使用者不存在' } >> controllers\authController.js
echo         }) >> controllers\authController.js
echo       } >> controllers\authController.js
echo. >> controllers\authController.js
echo       res.json({ >> controllers\authController.js
echo         success: true, >> controllers\authController.js
echo         data: { >> controllers\authController.js
echo           user: { >> controllers\authController.js
echo             id: user.id, >> controllers\authController.js
echo             student_id: user.student_id, >> controllers\authController.js
echo             name: user.name, >> controllers\authController.js
echo             email: user.email, >> controllers\authController.js
echo             role: user.role_name >> controllers\authController.js
echo           } >> controllers\authController.js
echo         } >> controllers\authController.js
echo       }) >> controllers\authController.js
echo     } catch (error) { >> controllers\authController.js
echo       console.error('取得個人資料錯誤:', error) >> controllers\authController.js
echo       res.status(500).json({ >> controllers\authController.js
echo         success: false, >> controllers\authController.js
echo         error: { message: '伺服器錯誤' } >> controllers\authController.js
echo       }) >> controllers\authController.js
echo     } >> controllers\authController.js
echo   } >> controllers\authController.js
echo } >> controllers\authController.js
echo. >> controllers\authController.js
echo module.exports = AuthController >> controllers\authController.js

echo ✅ 認證控制器完成
echo.

REM controllers/examController.js (簡化版，檔案會很長)
echo const ExamSession = require('../models/ExamSession') > controllers\examController.js
echo const Question = require('../models/Question') >> controllers\examController.js
echo const Category = require('../models/Category') >> controllers\examController.js
echo const database = require('../config/database') >> controllers\examController.js
echo. >> controllers\examController.js
echo class ExamController { >> controllers\examController.js
echo   constructor() { >> controllers\examController.js
echo     const db = database.getDb() >> controllers\examController.js
echo     this.questionModel = new Question(db) >> controllers\examController.js
echo     this.categoryModel = new Category(db) >> controllers\examController.js
echo   } >> controllers\examController.js
echo. >> controllers\examController.js
echo   async startExam(req, res) { >> controllers\examController.js
echo     try { >> controllers\examController.js
echo       const { category_id } = req.body >> controllers\examController.js
echo       const userId = req.user.userId >> controllers\examController.js
echo. >> controllers\examController.js
echo       // 驗證科目是否存在 >> controllers\examController.js
echo       const category = await this.categoryModel.getById(category_id) >> controllers\examController.js
echo       if (!category) { >> controllers\examController.js
echo         return res.status(404).json({ >> controllers\examController.js
echo           success: false, >> controllers\examController.js
echo           error: { message: '找不到指定科目' } >> controllers\examController.js
echo         }) >> controllers\examController.js
echo       } >> controllers\examController.js
echo. >> controllers\examController.js
echo       // 檢查題目數量是否足夠 >> controllers\examController.js
echo       const questionCount = await this.questionModel.getQuestionCount(category_id) >> controllers\examController.js
echo       if (questionCount ^< 80) { >> controllers\examController.js
echo         return res.status(400).json({ >> controllers\examController.js
echo           success: false, >> controllers\examController.js
echo           error: { message: `該科目題目數量不足，目前只有 ${questionCount} 題` } >> controllers\examController.js
echo         }) >> controllers\examController.js
echo       } >> controllers\examController.js
echo. >> controllers\examController.js
echo       // 隨機抽選 80 題 >> controllers\examController.js
echo       const questions = await this.questionModel.getRandomQuestions(category_id, 80) >> controllers\examController.js
echo. >> controllers\examController.js
echo       // 格式化題目回應 >> controllers\examController.js
echo       const formattedQuestions = questions.map((q, index) =^> ({ >> controllers\examController.js
echo         id: q.id, >> controllers\examController.js
echo         order: index + 1, >> controllers\examController.js
echo         question_text: q.question_text, >> controllers\examController.js
echo         options: { >> controllers\examController.js
echo           A: q.option_a, >> controllers\examController.js
echo           B: q.option_b, >> controllers\examController.js
echo           C: q.option_c, >> controllers\examController.js
echo           D: q.option_d >> controllers\examController.js
echo         }, >> controllers\examController.js
echo         image_url: q.image_url, >> controllers\examController.js
echo         topic_name: q.topic_name >> controllers\examController.js
echo       })) >> controllers\examController.js
echo. >> controllers\examController.js
echo       res.json({ >> controllers\examController.js
echo         success: true, >> controllers\examController.js
echo         data: { >> controllers\examController.js
echo           session_id: Date.now(), // 簡化版本使用時間戳 >> controllers\examController.js
echo           category_name: category.category_name, >> controllers\examController.js
echo           questions: formattedQuestions, >> controllers\examController.js
echo           time_limit_minutes: 60, >> controllers\examController.js
echo           total_questions: 80, >> controllers\examController.js
echo           max_score: 100, >> controllers\examController.js
echo           score_per_question: 1.25 >> controllers\examController.js
echo         } >> controllers\examController.js
echo       }) >> controllers\examController.js
echo     } catch (error) { >> controllers\examController.js
echo       console.error('開始考試錯誤:', error) >> controllers\examController.js
echo       res.status(500).json({ >> controllers\examController.js
echo         success: false, >> controllers\examController.js
echo         error: { message: '伺服器錯誤' } >> controllers\examController.js
echo       }) >> controllers\examController.js
echo     } >> controllers\examController.js
echo   } >> controllers\examController.js
echo. >> controllers\examController.js
echo   async getCategories(req, res) { >> controllers\examController.js
echo     try { >> controllers\examController.js
echo       const categories = await this.categoryModel.getAll() >> controllers\examController.js
echo       res.json({ >> controllers\examController.js
echo         success: true, >> controllers\examController.js
echo         data: { categories } >> controllers\examController.js
echo       }) >> controllers\examController.js
echo     } catch (error) { >> controllers\examController.js
echo       console.error('取得科目錯誤:', error) >> controllers\examController.js
echo       res.status(500).json({ >> controllers\examController.js
echo         success: false, >> controllers\examController.js
echo         error: { message: '伺服器錯誤' } >> controllers\examController.js
echo       }) >> controllers\examController.js
echo     } >> controllers\examController.js
echo   } >> controllers\examController.js
echo } >> controllers\examController.js
echo. >> controllers\examController.js
echo module.exports = ExamController >> controllers\examController.js

echo ✅ 考試控制器完成
echo.

echo 🛣️ 建立路由...

REM routes/auth.js
echo const express = require('express') > routes\auth.js
echo const AuthController = require('../controllers/authController') >> routes\auth.js
echo const { validate, schemas } = require('../middleware/validation') >> routes\auth.js
echo const { authenticateToken } = require('../middleware/auth') >> routes\auth.js
echo. >> routes\auth.js
echo const router = express.Router() >> routes\auth.js
echo const authController = new AuthController() >> routes\auth.js
echo. >> routes\auth.js
echo // 登入 >> routes\auth.js
echo router.post('/login', validate(schemas.login), (req, res) =^> { >> routes\auth.js
echo   authController.login(req, res) >> routes\auth.js
echo }) >> routes\auth.js
echo. >> routes\auth.js
echo // 取得個人資料 >> routes\auth.js
echo router.get('/profile', authenticateToken, (req, res) =^> { >> routes\auth.js
echo   authController.getProfile(req, res) >> routes\auth.js
echo }) >> routes\auth.js
echo. >> routes\auth.js
echo module.exports = router >> routes\auth.js

echo ✅ 認證路由完成
echo.

REM routes/exam.js
echo const express = require('express') > routes\exam.js
echo const ExamController = require('../controllers/examController') >> routes\exam.js
echo const { validate, schemas } = require('../middleware/validation') >> routes\exam.js
echo const { authenticateToken } = require('../middleware/auth') >> routes\exam.js
echo. >> routes\exam.js
echo const router = express.Router() >> routes\exam.js
echo const examController = new ExamController() >> routes\exam.js
echo. >> routes\exam.js
echo // 取得科目列表 >> routes\exam.js
echo router.get('/categories', (req, res) =^> { >> routes\exam.js
echo   examController.getCategories(req, res) >> routes\exam.js
echo }) >> routes\exam.js
echo. >> routes\exam.js
echo // 開始考試 >> routes\exam.js
echo router.post('/start', authenticateToken, validate(schemas.startExam), (req, res) =^> { >> routes\exam.js
echo   examController.startExam(req, res) >> routes\exam.js
echo }) >> routes\exam.js
echo. >> routes\exam.js
echo module.exports = router >> routes\exam.js

echo ✅ 考試路由完成
echo.

echo 🏗️ 建立第四階段批次檔...

REM 建立第四階段批次檔
echo @echo off > ..\azure-backend-stage4.bat
echo chcp 65001 ^>nul >> ..\azure-backend-stage4.bat
echo echo Azure 後端系統 - 第四階段 >> ..\azure-backend-stage4.bat
echo echo 建立服務器和完成設定... >> ..\azure-backend-stage4.bat
echo cd backend >> ..\azure-backend-stage4.bat

echo ✅ 第三階段完成！
echo.

echo 📋 第三階段建立內容：
echo ✅ 認證中間件 (middleware/auth.js)
echo ✅ 驗證中間件 (middleware/validation.js)
echo ✅ 認證控制器 (controllers/authController.js)
echo ✅ 考試控制器 (controllers/examController.js)
echo ✅ 認證路由 (routes/auth.js)
echo ✅ 考試路由 (routes/exam.js)
echo.

echo 🚀 API 端點：
echo POST /api/auth/login - 使用者登入
echo GET  /api/auth/profile - 取得個人資料
echo GET  /api/exam/categories - 取得科目列表
echo POST /api/exam/start - 開始考試
echo.

echo 🔑 測試帳號：
echo 學號：DEMO001，密碼：demo123
echo 學號：ADMIN，密碼：admin123
echo.

echo ⏭️ 下一步：
echo 執行 azure-backend-stage4.bat 建立服務器並完成設定
echo.

echo ====================================
echo Azure 後端第三階段完成！
echo ====================================
pause