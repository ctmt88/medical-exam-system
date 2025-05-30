class ApiService {
  constructor() {
    this.baseURL = 'https://starsport.tw/exam/api';
  }

  async request(endpoint, data = {}, useGet = false) {
    const config = {
      headers: {
        'Content-Type': 'application/json'
      }
    };

    const token = localStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    let url;
    
    if (useGet) {
      url = `${this.baseURL}?action=${endpoint}`;
      config.method = 'GET';
    } else {
      url = this.baseURL;
      config.method = 'POST';
      config.body = JSON.stringify({ action: endpoint, ...data });
    }

    try {
      const response = await fetch(url, config);
      const result = await response.json();
      if (!result.success) {
        throw new Error(result.error?.message || '請求失敗');
      }
      return result;
    } catch (error) {
      throw error;
    }
  }

  async login(studentId, password) {
    return this.request('login', {
      student_id: studentId,
      password: password
    });
  }

  async getCategories() {
    return this.request('categories', {}, true);
  }

  async startExam(categoryId) {
    return this.request('start_exam', {
      category_id: categoryId
    });
  }

  async saveAnswer(sessionId, questionId, answer) {
    return this.request('save_answer', {
      session_id: sessionId,
      question_id: questionId,
      answer: answer
    });
  }

  async submitExam(sessionId) {
    return this.request('submit_exam', {
      session_id: sessionId
    });
  }
}

export default new ApiService();