// src/services/apiService.js - 整合真實 bigcloud API
class RealApiService {
  constructor() {
    // 你的 bigcloud API 基礎網址
    this.baseURL = 'https://starsport.tw/exam/api';
    this.token = localStorage.getItem('auth_token');
    
    // 初始化時顯示連接資訊
    console.log('🌐 API Service initialized:', this.baseURL);
  }

  // 通用請求方法 - 使用參數方式
  async request(route = '', options = {}) {
    const url = route ? `${this.baseURL}/?route=${route}` : this.baseURL;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    };

    // 添加認證 token
    if (this.token) {
      config.headers.Authorization = `Bearer ${this.token}`;
    }

    try {
      console.log(`🚀 API Request: ${config.method || 'GET'} ${url}`);
      const response = await fetch(url, config);
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      const data = await response.json();
      console.log(`✅ API Response:`, data);

      if (!data.success) {
        throw new Error(data.error?.message || '請求失敗');
      }

      return data;
    } catch (error) {
      console.error(`❌ API Error:`, error);
      
      // 用戶友善的錯誤處理
      if (error.message.includes('Failed to fetch')) {
        throw new Error('網路連線失敗，請檢查網路連接');
      }
      if (error.message.includes('CORS')) {
        throw new Error('跨域請求失敗，請聲告系統管理員');
      }
      
      throw error;
    }
  }

  // 測試 API 連線
  async testConnection() {
    try {
      const response = await this.request('test');
      return {
        success: true,
        message: 'API 連線成功',
        data: response.data
      };
    } catch (error) {
      return {
        success: false,
        message: 'API 連線失敗',
        error: error.message
      };
    }
  }

  // 使用者登入
  async login(studentId, password) {
    try {
      const response = await this.request('login', {
        method: 'POST',
        body: JSON.stringify({
          student_id: studentId,
          password: password
        })
      });

      // 儲存 token 和使用者資料
      if (response.data.token) {
        this.token = response.data.token;
        localStorage.setItem('auth_token', this.token);
        localStorage.setItem('user_data', JSON.stringify(response.data.user));
        console.log('✅ 登入成功，token 已儲存');
      }

      return {
        success: true,
        message: '登入成功',
        user: response.data.user,
        token: response.data.token
      };
    } catch (error) {
      throw new Error(error.message || '登入失敗');
    }
  }

  // 登出
  logout() {
    this.token = null;
    localStorage.removeItem('auth_token');
    localStorage.removeItem('user_data');
    console.log('📤 已登出，清除本地資料');
    
    return {
      success: true,
      message: '已登出'
    };
  }

  // 取得考試科目
  async getCategories() {
    try {
      const response = await this.request('categories');
      
      return {
        success: true,
        categories: response.data.categories || [],
        message: `取得 ${response.data.categories?.length || 0} 個科目`
      };
    } catch (error) {
      throw new Error('取得科目失敗: ' + error.message);
    }
  }

  // 開始考試
  async startExam(categoryId) {
    try {
      if (!this.token) {
        throw new Error('請先登入');
      }

      const response = await this.request('start-exam', {
        method: 'POST',
        body: JSON.stringify({
          category_id: parseInt(categoryId)
        })
      });

      return {
        success: true,
        sessionId: response.data.session_id,
        categoryName: response.data.category?.category_name || '未知科目',
        questions: response.data.questions || [],
        timeLimit: 60, // 60 分鐘
        totalQuestions: response.data.questions?.length || 0,
        maxScore: 100,
        scorePerQuestion: 1.25,
        message: '考試開始成功'
      };
    } catch (error) {
      throw new Error('開始考試失敗: ' + error.message);
    }
  }

  // 儲存答案 (目前後端還沒實作，先回傳成功)
  async saveAnswer(sessionId, questionId, answer, isMarked = false) {
    try {
      // 暫時儲存到本地，等後端實作完成
      const key = `answer_${sessionId}_${questionId}`;
      localStorage.setItem(key, JSON.stringify({
        answer,
        isMarked,
        timestamp: Date.now()
      }));
      
      console.log(`💾 答案已暫存: 題目${questionId} = ${answer}`);
      
      return {
        success: true,
        message: '答案已儲存'
      };
    } catch (error) {
      throw new Error('儲存答案失敗: ' + error.message);
    }
  }

  // 提交考試 (目前後端還沒實作，先回傳模擬結果)
  async submitExam(sessionId, answers) {
    try {
      // 模擬計算成績 (等後端實作完成後修改)
      const totalQuestions = Object.keys(answers).length;
      const correctCount = Math.floor(Math.random() * totalQuestions * 0.3) + Math.floor(totalQuestions * 0.5);
      const totalScore = correctCount * 1.25;
      
      console.log(`📊 模擬成績計算: ${correctCount}/${totalQuestions} 正確，${totalScore} 分`);
      
      return {
        success: true,
        totalScore: totalScore,
        correctCount: correctCount,
        totalQuestions: totalQuestions,
        scorePerQuestion: 1.25,
        message: '考試提交成功 (模擬結果)',
        note: '此為前端模擬結果，實際成績請等待後端實作'
      };
    } catch (error) {
      throw new Error('提交考試失敗: ' + error.message);
    }
  }

  // 取得考試歷史 (暫時回傳空資料)
  async getExamHistory() {
    try {
      return {
        success: true,
        exams: [],
        message: '考試歷史功能開發中'
      };
    } catch (error) {
      throw new Error('取得考試歷史失敗: ' + error.message);
    }
  }

  // 取得使用者資料
  getCurrentUser() {
    const userData = localStorage.getItem('user_data');
    return userData ? JSON.parse(userData) : null;
  }

  // 檢查登入狀態
  isLoggedIn() {
    return !!this.token && !!this.getCurrentUser();
  }

  // 取得本地儲存的答案 (用於考試恢復)
  getLocalAnswers(sessionId) {
    const answers = {};
    const keys = Object.keys(localStorage).filter(key => key.startsWith(`answer_${sessionId}_`));
    
    keys.forEach(key => {
      const questionId = key.split('_')[2];
      const data = JSON.parse(localStorage.getItem(key));
      answers[questionId] = data.answer;
    });
    
    return answers;
  }

  // 清除本地答案快取
  clearLocalAnswers(sessionId) {
    const keys = Object.keys(localStorage).filter(key => key.startsWith(`answer_${sessionId}_`));
    keys.forEach(key => localStorage.removeItem(key));
    console.log(`🗑️ 已清除 ${keys.length} 個本地答案快取`);
  }
}

// 建立全域實例
const realApiService = new RealApiService();

// 自動測試連線 (可選)
realApiService.testConnection().then(result => {
  if (result.success) {
    console.log('🎉 API 自動連線測試成功');
  } else {
    console.warn('⚠️ API 自動連線測試失敗:', result.error);
  }
});

// 匯出供其他模組使用
export default realApiService;

// 如果在瀏覽器環境，也可以掛載到 window
if (typeof window !== 'undefined') {
  window.realApiService = realApiService;
}

// 相容性匯出 (如果你的前端使用舊的模擬服務)
export { realApiService as apiService };