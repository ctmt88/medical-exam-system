require('dotenv').config() 
 
module.exports = { 
  port: process.env.PORT || 3000, 
  nodeEnv: process.env.NODE_ENV || 'development', 
  jwtSecret: process.env.JWT_SECRET || 'default-secret-change-this', 
  dbPath: process.env.DB_PATH || './database/exam_system.db', 
  corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:5173', 
  uploadPath: process.env.UPLOAD_PATH || './uploads', 
  rateLimit: { 
    windowMs: 15 * 60 * 1000, // 15 分鐘 
    max: 100 // 每個 IP 最多 100 次請求 
  } 
} 
