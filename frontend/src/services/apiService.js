// frontend/src/services/apiService.js
const API_BASE = 'https://starsport.tw/exam/api';

const apiService = {
  async login(studentId, password) {
    const response = await fetch(API_BASE, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        action: 'login',
        student_id: studentId,
        password: password
      })
    });
    
    const data = await response.json();
    if (!data.success) {
      throw new Error(data.error?.message || '登入失敗');
    }
    return data;
  },

  async getCategories() {
    const response = await fetch(`${API_BASE}?action=categories`);
    const data = await response.json();
    if (!data.success) {
      throw new Error(data.error?.message || '取得科目失敗');
    }
    return data;
  },

  async startExam(categoryId) {
    const response = await fetch(API_BASE, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        action: 'start_exam',
        category_id: categoryId
      })
    });
    
    const data = await response.json();
    if (!data.success) {
      throw new Error(data.error?.message || '開始考試失敗');
    }
    return data;
  }
};

window.apiService = apiService;