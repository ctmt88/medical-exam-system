-- 醫事檢驗師考試系統資料庫架構 
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
    role_id INTEGER NOT NULL, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    last_login DATETIME, 
    FOREIGN KEY (role_id) REFERENCES user_roles(id) 
); 
 
-- 六大科目分類表 
CREATE TABLE IF NOT EXISTS categories ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    category_code VARCHAR(10) NOT NULL UNIQUE, 
    category_name VARCHAR(200) NOT NULL, 
    description TEXT, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
); 
 
-- 主題分類表 
CREATE TABLE IF NOT EXISTS topic_categories ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    category_id INTEGER NOT NULL, 
    topic_name VARCHAR(200) NOT NULL, 
    topic_code VARCHAR(20), 
    description TEXT, 
    is_active BOOLEAN DEFAULT 1, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (category_id) REFERENCES categories(id) 
); 
 
-- 題目表 
CREATE TABLE IF NOT EXISTS questions ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    question_number VARCHAR(20), 
    exam_year INTEGER, 
    exam_semester VARCHAR(10), 
    category_id INTEGER NOT NULL, 
    topic_category_id INTEGER, 
    question_text TEXT NOT NULL, 
    option_a TEXT NOT NULL, 
    option_b TEXT NOT NULL, 
    option_c TEXT NOT NULL, 
    option_d TEXT NOT NULL, 
    correct_answer CHAR(1) NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D')), 
    explanation TEXT, 
    image_url VARCHAR(500), 
    difficulty_level INTEGER DEFAULT 1 CHECK (difficulty_level BETWEEN 1 AND 5), 
    frequency_weight REAL DEFAULT 1.0, 
    is_active BOOLEAN DEFAULT 1, 
    created_by INTEGER, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (category_id) REFERENCES categories(id), 
    FOREIGN KEY (topic_category_id) REFERENCES topic_categories(id), 
    FOREIGN KEY (created_by) REFERENCES users(id) 
); 
 
-- 考試場次表 
CREATE TABLE IF NOT EXISTS exam_sessions ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    user_id INTEGER NOT NULL, 
    category_id INTEGER NOT NULL, 
    session_name VARCHAR(200), 
    exam_type VARCHAR(50) DEFAULT 'single_subject', 
    total_questions INTEGER DEFAULT 80, 
    time_limit_minutes INTEGER DEFAULT 60, 
    max_score REAL DEFAULT 100.0, 
    score_per_question REAL DEFAULT 1.25, 
    start_time DATETIME, 
    end_time DATETIME, 
    submitted_time DATETIME, 
    time_remaining INTEGER, 
    is_completed BOOLEAN DEFAULT 0, 
    is_submitted BOOLEAN DEFAULT 0, 
    total_score REAL, 
    correct_count INTEGER DEFAULT 0, 
    marked_count INTEGER DEFAULT 0, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES users(id), 
    FOREIGN KEY (category_id) REFERENCES categories(id) 
); 
 
-- 考試題目表 
CREATE TABLE IF NOT EXISTS exam_questions ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    session_id INTEGER NOT NULL, 
    question_id INTEGER NOT NULL, 
    question_order INTEGER NOT NULL, 
    category_id INTEGER NOT NULL, 
    FOREIGN KEY (session_id) REFERENCES exam_sessions(id) ON DELETE CASCADE, 
    FOREIGN KEY (question_id) REFERENCES questions(id), 
    FOREIGN KEY (category_id) REFERENCES categories(id) 
); 
 
-- 學生答題記錄表 
CREATE TABLE IF NOT EXISTS user_answers ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    session_id INTEGER NOT NULL, 
    question_id INTEGER NOT NULL, 
    question_order INTEGER NOT NULL, 
    user_answer CHAR(1) CHECK (user_answer IN ('A', 'B', 'C', 'D')), 
    is_marked BOOLEAN DEFAULT 0, 
    is_correct BOOLEAN, 
    answer_time DATETIME, 
    time_spent INTEGER, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (session_id) REFERENCES exam_sessions(id) ON DELETE CASCADE, 
    FOREIGN KEY (question_id) REFERENCES questions(id), 
    UNIQUE(session_id, question_id) 
); 
 
-- 錯題收藏表 
CREATE TABLE IF NOT EXISTS bookmarked_questions ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    user_id INTEGER NOT NULL, 
    question_id INTEGER NOT NULL, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, 
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE, 
    UNIQUE(user_id, question_id) 
); 
 
-- 檔案上傳記錄表 
CREATE TABLE IF NOT EXISTS upload_logs ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    uploaded_by INTEGER NOT NULL, 
    file_name VARCHAR(255) NOT NULL, 
    file_size INTEGER, 
    record_count INTEGER, 
    error_count INTEGER DEFAULT 0, 
    upload_type VARCHAR(50), 
    status VARCHAR(20) DEFAULT 'processing', 
    error_log TEXT, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (uploaded_by) REFERENCES users(id) 
); 
 
-- 建立索引 
CREATE INDEX IF NOT EXISTS idx_questions_category ON questions(category_id); 
CREATE INDEX IF NOT EXISTS idx_questions_topic ON questions(topic_category_id); 
CREATE INDEX IF NOT EXISTS idx_questions_year ON questions(exam_year); 
CREATE INDEX IF NOT EXISTS idx_questions_active ON questions(is_active); 
CREATE INDEX IF NOT EXISTS idx_users_student_id ON users(student_id); 
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email); 
CREATE INDEX IF NOT EXISTS idx_exam_sessions_user ON exam_sessions(user_id); 
CREATE INDEX IF NOT EXISTS idx_user_answers_session ON user_answers(session_id); 
CREATE INDEX IF NOT EXISTS idx_user_answers_question ON user_answers(question_id); 
