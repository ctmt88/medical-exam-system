-- 醫檢師考試系統資料庫 Schema 
-- SQLite 版本 
 
PRAGMA foreign_keys = ON; 
 
-- 使用者角色表 
CREATE TABLE IF NOT EXISTS user_roles ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    role_name VARCHAR(50) NOT NULL UNIQUE, 
    description TEXT, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
); 
 
-- 使用者表 
CREATE TABLE IF NOT EXISTS users ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    student_id VARCHAR(20) UNIQUE, 
    name VARCHAR(100) NOT NULL, 
    email VARCHAR(255) UNIQUE, 
    password_hash VARCHAR(255) NOT NULL, 
    role_id INTEGER NOT NULL DEFAULT 2, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    last_login DATETIME, 
    FOREIGN KEY (role_id) REFERENCES user_roles(id) 
); 
 
-- 科目分類表 
CREATE TABLE IF NOT EXISTS categories ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    category_code VARCHAR(10) NOT NULL UNIQUE, 
    category_name VARCHAR(200) NOT NULL, 
    description TEXT, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
); 
 
-- 題目表 
CREATE TABLE IF NOT EXISTS questions ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    category_id INTEGER NOT NULL, 
    question_text TEXT NOT NULL, 
    option_a TEXT NOT NULL, 
    option_b TEXT NOT NULL, 
    option_c TEXT NOT NULL, 
    option_d TEXT NOT NULL, 
    correct_answer CHAR(1) NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D')), 
    explanation TEXT, 
    image_url VARCHAR(500), 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (category_id) REFERENCES categories(id) 
); 
 
-- 考試場次表 
CREATE TABLE IF NOT EXISTS exam_sessions ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    user_id INTEGER NOT NULL, 
    category_id INTEGER NOT NULL, 
    total_questions INTEGER DEFAULT 80, 
    time_limit_minutes INTEGER DEFAULT 60, 
    max_score REAL DEFAULT 100.0, 
    score_per_question REAL DEFAULT 1.25, 
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP, 
    end_time DATETIME, 
    is_completed BOOLEAN DEFAULT 0, 
    is_submitted BOOLEAN DEFAULT 0, 
    total_score REAL, 
    correct_count INTEGER DEFAULT 0, 
    FOREIGN KEY (user_id) REFERENCES users(id), 
    FOREIGN KEY (category_id) REFERENCES categories(id) 
); 
 
-- 答題記錄表 
CREATE TABLE IF NOT EXISTS user_answers ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    session_id INTEGER NOT NULL, 
    question_id INTEGER NOT NULL, 
    user_answer CHAR(1) CHECK (user_answer IN ('A', 'B', 'C', 'D')), 
    is_marked BOOLEAN DEFAULT 0, 
    answer_time DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (session_id) REFERENCES exam_sessions(id), 
    FOREIGN KEY (question_id) REFERENCES questions(id), 
    UNIQUE(session_id, question_id) 
); 
 
-- 初始化資料 
INSERT OR IGNORE INTO user_roles (role_name, description) VALUES 
('admin', '系統管理員'), 
('student', '學生'); 
 
INSERT OR IGNORE INTO categories (category_code, category_name, description) VALUES 
('PHYS', '臨床生理學與病理學', '心電圖、肺功能、腦波檢查等'), 
('HEMA', '臨床血液學與血庫學', '血球計數、凝血功能、血型檢驗等'), 
('MOLE', '醫學分子檢驗學與臨床鏡檢學', 'PCR技術、基因定序、寄生蟲檢驗等'), 
('MICR', '微生物學與臨床微生物學', '細菌培養、抗生素敏感性、黴菌檢驗等'), 
('BIOC', '生物化學與臨床生化學', '肝功能、腎功能、血糖檢驗等'), 
('SERO', '臨床血清免疫學與臨床病毒學', '腫瘤標記、自體免疫、病毒檢驗等'); 
 
-- 建立示範管理員帳號 (密碼: admin123) 
INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) VALUES 
(NULL, '系統管理員', 'admin@medical-exam.com', '$2b$10$rQZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ', 1); 
 
-- 建立示範學生帳號 (密碼: student123) 
INSERT OR IGNORE INTO users (student_id, name, email, password_hash, role_id) VALUES 
('DEMO001', '展示學生', 'student@medical-exam.com', '$2b$10$rQZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ9qZ', 2); 
