const sqlite3 = require('sqlite3').verbose() 
const path = require('path') 
require('dotenv').config() 
 
const dbPath = process.env.DB_PATH || './database/exam_system.db' 
 
class Database { 
  constructor() { 
    this.db = null 
  } 
 
  connect() { 
    return new Promise((resolve, reject) => { 
      this.db = new sqlite3.Database(dbPath, (err) => { 
        if (err) { 
          console.error('資料庫連線失敗:', err.message) 
          reject(err) 
        } else { 
          console.log('✅ SQLite 資料庫連線成功') 
          resolve(this.db) 
        } 
      }) 
    }) 
  } 
 
  getDb() { 
    return this.db 
  } 
 
  close() { 
    if (this.db) { 
      this.db.close() 
    } 
  } 
} 
 
module.exports = new Database() 
