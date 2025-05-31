/**
 * API服務類
 * 檔案名稱: ApiService.js
 * 處理所有與後端的通信
 */

class ApiService {
    constructor() {
        // 設置正確的API地址
        this.baseURL = 'https://starsport.tw/exam/api/';
        this.timeout = 15000; // 15秒超時
        
        console.log('✅ ApiService 初始化，API地址:', this.baseURL);
    }

    /**
     * 通用API請求方法
     */
    async makeRequest(action, data = {}) {
        const requestData = {
            action: action,
            ...data
        };

        console.log(`🚀 發送請求: ${action}`, requestData);

        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), this.timeout);

            const response = await fetch(this.baseURL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(requestData),
                signal: controller.signal
            });

            clearTimeout(timeoutId);

            console.log(`📡 回應狀態: ${response.status}`);

            if (!response.ok) {
                throw new Error(`HTTP錯誤: ${response.status} ${response.statusText}`);
            }

            const text = await response.text();
            console.log(`📥 回應內容長度: ${text.length}`);

            if (!text) {
                throw new Error('API回應為空');
            }

            let result;
            try {
                result = JSON.parse(text);
            } catch (parseError) {
                console.error('❌ JSON解析錯誤:', parseError);
                console.error('原始回應:', text.substring(0, 500));
                throw new Error('API回應格式錯誤');
            }

            if (result.success) {
                console.log(`✅ ${action} 請求成功`);
                return result;
            } else {
                console.warn(`⚠️ ${action} 請求失敗:`, result.message);
                throw new Error(result.message || 'API請求失敗');
            }

        } catch (error) {
            console.error(`❌ ${action} 請求錯誤:`, error);
            
            if (error.name === 'AbortError') {
                throw new Error('請求超時，請檢查網路連接');
            }
            
            throw error;
        }
    }

    /**
     * 登入
     */
    async login(username, password) {
        console.log('🔐 嘗試登入:', username);
        return await this.makeRequest('login', { username, password });
    }

    /**
     * 獲取科目列表
     */
    async getCategories() {
        console.log('📚 獲取科目列表');
        return await this.makeRequest('categories');
    }

    /**
     * 獲取題目
     */
    async getQuestions(categoryId, limit = 20) {
        console.log(`📝 獲取題目: 科目${categoryId}, 限制${limit}題`);
        return await this.makeRequest('questions', { 
            category_id: parseInt(categoryId), 
            limit: parseInt(limit) 
        });
    }

    /**
     * 提交考試結果
     */
    async submitExam(userId, categoryId, answers, score, totalQuestions) {
        console.log(`📤 提交考試: 用戶${userId}, 科目${categoryId}, 分數${score}`);
        return await this.makeRequest('submit', {
            user_id: parseInt(userId),
            category_id: parseInt(categoryId),
            answers: answers,
            score: parseInt(score),
            total_questions: parseInt(totalQuestions)
        });
    }

    /**
     * 獲取考試歷史記錄
     */
    async getHistory(userId) {
        console.log(`📊 獲取歷史記錄: 用戶${userId}`);
        return await this.makeRequest('history', { user_id: parseInt(userId) });
    }

    /**
     * 匯入題目
     */
    async importQuestions(questionsData, importSource = 'excel') {
        console.log('📤 開始匯入題目...', questionsData.length, '題');
        
        // 數據驗證
        if (!Array.isArray(questionsData) || questionsData.length === 0) {
            throw new Error('題目數據格式錯誤或為空');
        }

        // 驗證每個題目的基本格式
        for (let i = 0; i < questionsData.length; i++) {
            const q = questionsData[i];
            if (!q.question || !q.correctAnswer) {
                throw new Error(`第${i + 1}題格式錯誤：缺少題目或答案`);
            }
            if (!['A', 'B', 'C', 'D'].includes(q.correctAnswer?.toUpperCase())) {
                throw new Error(`第${i + 1}題答案格式錯誤：${q.correctAnswer}`);
            }
        }

        return await this.makeRequest('import_questions', {
            questions_data: questionsData,
            import_source: importSource
        });
    }

    /**
     * 健康檢查
     */
    async healthCheck() {
        console.log('🏥 執行健康檢查');
        return await this.makeRequest('health_check');
    }

    /**
     * 資料庫診斷檢查
     */
    async databaseCheck() {
        console.log('🔍 執行資料庫診斷');
        return await this.makeRequest('database_check');
    }

    /**
     * 刪除重複題目
     */
    async removeDuplicates(mode = 'check') {
        console.log(`🧹 處理重複題目: ${mode}`);
        return await this.makeRequest('remove_duplicates', { mode });
    }

    /**
     * 測試API連接
     */
    async testConnection() {
        try {
            console.log('🔗 測試API連接...');
            const result = await this.healthCheck();
            console.log('✅ API連接正常');
            return { success: true, data: result };
        } catch (error) {
            console.error('❌ API連接失敗:', error);
            return { success: false, error: error.message };
        }
    }

    /**
     * 批量測試API功能
     */
    async runFullTest() {
        const results = {};
        
        try {
            // 測試健康檢查
            console.log('=== 開始完整API測試 ===');
            
            results.health = await this.healthCheck();
            console.log('✅ 健康檢查通過');
            
            // 測試科目獲取
            results.categories = await this.getCategories();
            console.log('✅ 科目獲取通過');
            
            // 測試登入
            results.login = await this.login('DEMO001', 'demo123');
            console.log('✅ 登入測試通過');
            
            // 測試題目獲取
            if (results.categories.data && results.categories.data.length > 0) {
                const firstCategoryId = results.categories.data[0].id;
                results.questions = await this.getQuestions(firstCategoryId, 5);
                console.log('✅ 題目獲取通過');
            }
            
            // 測試資料庫診斷
            results.diagnostic = await this.databaseCheck();
            console.log('✅ 資料庫診斷通過');
            
            console.log('🎉 完整API測試成功！');
            return { success: true, results };
            
        } catch (error) {
            console.error('❌ API測試失敗:', error);
            return { success: false, error: error.message, partialResults: results };
        }
    }
}

// 創建全局實例
const apiService = new ApiService();

// 導出API服務
export default apiService;

// 在開發環境下，將API服務添加到window對象供調試使用
if (process.env.NODE_ENV === 'development' || window.location.hostname === 'localhost') {
    window.apiService = apiService;
    window.testAPI = () => apiService.runFullTest();
    console.log('💡 開發模式：可在控制台使用 window.apiService 和 testAPI()');
}