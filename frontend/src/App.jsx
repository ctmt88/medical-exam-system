import React, { useState, useEffect } from 'react'
import ExcelImport from './ExcelImport' // 取消註釋

// ApiService類保持不變...
class ApiService {
  constructor() {
    this.baseURL = 'https://starsport.tw/exam/api/'
    this.fallbackMode = false
    this.connectionTested = false
  }

  async testConnection() {
    try {
      const response = await fetch(this.baseURL + '?action=categories', {
        method: 'GET',
        mode: 'cors',
        credentials: 'omit',
        headers: {
          'Accept': 'application/json',
        }
      })
      this.connectionTested = true
      return response.ok
    } catch (error) {
      console.error('API連線測試失敗:', error)
      this.connectionTested = true
      return false
    }
  }

  async request(params, retries = 2) {
    for (let i = 0; i <= retries; i++) {
      try {
        const url = new URL(this.baseURL)
        Object.keys(params).forEach(key => {
          if (params[key] !== undefined && params[key] !== null) {
            url.searchParams.append(key, params[key])
          }
        })

        console.log('API請求:', url.toString())

        const response = await fetch(url, {
          method: 'GET',
          mode: 'cors',
          credentials: 'omit',
          headers: {
            'Accept': 'application/json',
            'Cache-Control': 'no-cache',
          }
        })

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`)
        }

        const text = await response.text()
        console.log('API回應:', text)

        try {
          return JSON.parse(text)
        } catch (jsonError) {
          throw new Error('API回應格式錯誤: ' + text.substring(0, 100))
        }

      } catch (error) {
        console.error(`API請求失敗 (嘗試 ${i + 1}/${retries + 1}):`, error)
        if (i === retries) {
          if (!this.fallbackMode) {
            this.fallbackMode = true
            console.log('切換到離線模式')
          }
          throw new Error(`API連線失敗: ${error.message}`)
        }
        await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)))
      }
    }
  }

  async login(username, password) {
    try {
      const result = await this.request({
        action: 'login',
        username: username.trim(),
        password: password.trim()
      })
      return result
    } catch (error) {
      console.error('登入API錯誤:', error)
      if (username === 'DEMO001' && password === 'demo123') {
        console.log('使用離線模式登入')
        this.fallbackMode = true
        return {
          success: true,
          user: { id: 1, username: 'DEMO001', name: '展示用戶', role: 'admin' }, // 添加admin角色
          message: '離線模式登入成功'
        }
      }
      throw error
    }
  }

  async getCategories() {
    try {
      if (this.fallbackMode) throw new Error('使用離線模式')
      return await this.request({ action: 'categories' })
    } catch (error) {
      console.log('使用預設科目資料')
      this.fallbackMode = true
      return {
        success: true,
        data: [
          { id: 1, name: '臨床生理學與病理學', description: '心電圖、肺功能、腦波檢查等' },
          { id: 2, name: '臨床血液學與血庫學', description: '血球計數、凝血功能、血型檢驗等' },
          { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', description: 'PCR技術、基因定序、寄生蟲檢驗等' },
          { id: 4, name: '微生物學與臨床微生物學', description: '細菌培養、抗生素敏感性、黴菌檢驗等' },
          { id: 5, name: '生物化學與臨床生化學', description: '肝功能、腎功能、血糖檢驗等' },
          { id: 6, name: '臨床血清免疫學與臨床病毒學', description: '腫瘤標記、自體免疫、病毒檢驗等' }
        ]
      }
    }
  }

  async getQuestions(categoryId) {
    try {
      if (this.fallbackMode) throw new Error('使用離線模式')
      return await this.request({
        action: 'questions',
        category_id: categoryId
      })
    } catch (error) {
      console.log('使用模擬題目')
      this.fallbackMode = true
      const mockQuestions = Array.from({ length: 20 }, (_, i) => ({
        id: i + 1,
        question: `第${i + 1}題：關於醫事檢驗的描述，下列何者正確？`,
        option_a: `選項A：這是第${i + 1}題的選項A`,
        option_b: `選項B：這是第${i + 1}題的選項B`,
        option_c: `選項C：這是第${i + 1}題的選項C`,
        option_d: `選項D：這是第${i + 1}題的選項D`,
        correct_answer: ['A', 'B', 'C', 'D'][i % 4]
      }))
      return { success: true, data: mockQuestions }
    }
  }

  async submitExam(examData) {
    try {
      if (this.fallbackMode) throw new Error('使用離線模式')
      return await this.request({
        action: 'submit',
        user_id: examData.userId,
        category_id: examData.categoryId,
        answers: JSON.stringify(examData.answers),
        score: examData.score
      })
    } catch (error) {
      console.log('離線模式：成績未儲存到伺服器')
      return {
        success: false,
        message: '離線模式：成績未儲存'
      }
    }
  }

  async getExamHistory(userId) {
    try {
      if (this.fallbackMode) throw new Error('使用離線模式')
      return await this.request({
        action: 'history',
        user_id: userId
      })
    } catch (error) {
      console.log('離線模式：無歷史記錄')
      return {
        success: true,
        data: [
          { id: 1, category_id: 1, score: 85, exam_date: new Date().toISOString() },
          { id: 2, category_id: 2, score: 78, exam_date: new Date(Date.now() - 86400000).toISOString() }
        ]
      }
    }
  }

  async importQuestions(questionsData) {
    try {
      if (this.fallbackMode) throw new Error('離線模式不支援題目匯入')
      
      return await this.request({
        action: 'import_questions',
        questions_data: JSON.stringify(questionsData)
      })
    } catch (error) {
      console.error('題目匯入失敗:', error)
      return {
        success: false,
        message: '離線模式不支援題目匯入功能'
      }
    }
  }
}

const apiService = new ApiService()

function App() {
  const [currentView, setCurrentView] = useState('home')
  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [showLoginModal, setShowLoginModal] = useState(false)
  const [selectedSubject, setSelectedSubject] = useState(null)
  const [examTimer, setExamTimer] = useState(3600)
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [userAnswers, setUserAnswers] = useState({})
  const [markedQuestions, setMarkedQuestions] = useState(new Set())
  const [isExamActive, setIsExamActive] = useState(false)
  const [showSubmitModal, setShowSubmitModal] = useState(false)
  const [loginData, setLoginData] = useState({ username: 'DEMO001', password: 'demo123' })
  const [currentUser, setCurrentUser] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [subjects, setSubjects] = useState([])
  const [examQuestions, setExamQuestions] = useState([])
  const [examHistory, setExamHistory] = useState([])
  const [connectionStatus, setConnectionStatus] = useState('checking')
  
  // 新增：Excel匯入相關狀態
  const [showExcelImport, setShowExcelImport] = useState(false)

  // 檢查是否為管理員
  const isAdmin = () => {
    return currentUser && (currentUser.role === 'admin' || currentUser.username === 'DEMO001')
  }

  useEffect(() => {
    checkConnectionAndLoadData()
  }, [])

  useEffect(() => {
    let interval = null
    if (isExamActive && examTimer > 0) {
      interval = setInterval(() => {
        setExamTimer(timer => timer - 1)
      }, 1000)
    } else if (examTimer === 0) {
      setIsExamActive(false)
      alert('時間到！考試結束')
      handleAutoSubmit()
    }
    return () => clearInterval(interval)
  }, [isExamActive, examTimer])

  const checkConnectionAndLoadData = async () => {
    try {
      setLoading(true)
      setConnectionStatus('checking')
      
      const isConnected = await apiService.testConnection()
      setConnectionStatus(isConnected ? 'online' : 'offline')
      
      const data = await apiService.getCategories()
      if (data.success) {
        setSubjects(data.data)
      }
    } catch (error) {
      console.error('初始化失敗:', error)
      setConnectionStatus('offline')
    } finally {
      setLoading(false)
    }
  }

  const formatTime = (seconds) => {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  const handleLogin = async () => {
    try {
      setLoading(true)
      setError('')

      console.log('嘗試登入:', loginData.username)
      const data = await apiService.login(loginData.username, loginData.password)

      if (data.success) {
        setCurrentUser(data.user)
        setIsLoggedIn(true)
        setShowLoginModal(false)
        
        setError('')
        setSelectedSubject(null)
        
        setCurrentView('dashboard')
        
        await loadExamHistory(data.user.id)
        if (data.message) {
          console.log('登入訊息:', data.message)
        }
      } else {
        setError(data.message || '登入失敗')
      }
    } catch (error) {
      console.error('登入錯誤詳情:', error)
      setError(`連線錯誤: ${error.message}`)
    } finally {
      setLoading(false)
    }
  }

  const loadExamHistory = async (userId) => {
    try {
      const data = await apiService.getExamHistory(userId)
      if (data.success) {
        setExamHistory(data.data)
      }
    } catch (error) {
      console.error('載入考試記錄失敗:', error)
    }
  }

  const handleSubjectClick = (subjectId) => {
    if (isLoggedIn) {
      startExam(subjectId)
    } else {
      setSelectedSubject(subjects.find(s => s.id === subjectId))
      setShowLoginModal(true)
    }
  }

  const startExam = async (subjectId) => {
    try {
      setLoading(true)
      const subject = subjects.find(s => s.id === subjectId)
      const questionsData = await apiService.getQuestions(subjectId)

      if (questionsData.success && questionsData.data.length > 0) {
        setSelectedSubject(subject)
        setExamQuestions(questionsData.data)
        setCurrentView('exam')
        setCurrentQuestion(0)
        setExamTimer(3600)
        setUserAnswers({})
        setMarkedQuestions(new Set())
        setIsExamActive(true)
      } else {
        alert('載入題目失敗，請稍後再試')
      }
    } catch (error) {
      alert('載入題目失敗：' + error.message)
      console.error('載入題目錯誤:', error)
    } finally {
      setLoading(false)
    }
  }

  const selectAnswer = (questionId, answer) => {
    setUserAnswers(prev => ({...prev, [questionId]: answer}))
  }

  const toggleMark = (questionId) => {
    setMarkedQuestions(prev => {
      const newMarked = new Set(prev)
      if (newMarked.has(questionId)) {
        newMarked.delete(questionId)
      } else {
        newMarked.add(questionId)
      }
      return newMarked
    })
  }

  const handleAutoSubmit = () => {
    alert('時間到！系統將自動提交您的答案。')
    submitExam()
  }

  const submitExam = async () => {
    try {
      setLoading(true)
      const correctCount = Object.entries(userAnswers).filter(([questionId, answer]) => {
        const question = examQuestions.find(q => q.id === parseInt(questionId))
        return question && question.correct_answer === answer
      }).length

      const totalScore = Math.round((correctCount / examQuestions.length) * 100)

      const examData = {
        userId: currentUser.id,
        categoryId: selectedSubject.id,
        answers: userAnswers,
        score: totalScore
      }

      const submitResult = await apiService.submitExam(examData)

      setIsExamActive(false)
      setCurrentView('result')
      setShowSubmitModal(false)

      if (submitResult.success) {
        await loadExamHistory(currentUser.id)
      }
    } catch (error) {
      alert('提交失敗，請稍後再試')
      console.error('提交錯誤:', error)
    } finally {
      setLoading(false)
    }
  }

  // 新增：處理Excel匯入成功後的回調
  const handleImportSuccess = () => {
    setShowExcelImport(false)
    // 重新載入科目資料
    checkConnectionAndLoadData()
    alert('Excel題目匯入成功！')
  }

  const getConnectionStatusDisplay = () => {
    switch (connectionStatus) {
      case 'checking':
        return { text: '檢測中...', color: 'bg-yellow-100 text-yellow-800' }
      case 'online':
        return { text: 'MySQL連線', color: 'bg-green-100 text-green-800' }
      case 'offline':
        return { text: '離線模式', color: 'bg-red-100 text-red-800' }
      default:
        return { text: '未知狀態', color: 'bg-gray-100 text-gray-800' }
    }
  }

  // 主頁面渲染 - 添加Excel匯入按鈕
  if (currentView === 'home') {
    const statusDisplay = getConnectionStatusDisplay()
    
    return (
      <div>
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
          <nav className="bg-white shadow-sm">
            <div className="max-w-7xl mx-auto px-4 py-4">
              <div className="flex justify-between items-center">
                <div className="flex items-center">
                  <h1 className="text-2xl font-bold text-gray-900">醫檢師考試系統</h1>
                  <span className={`ml-2 px-2 py-1 text-xs rounded-full ${statusDisplay.color}`}>
                    {statusDisplay.text}
                  </span>
                  {connectionStatus === 'checking' && (
                    <div className="ml-2 animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600"></div>
                  )}
                </div>
                {isLoggedIn ? (
                  <div className="flex items-center space-x-4">
                    <span className="text-gray-700">歡迎，{currentUser?.username}</span>
                    {/* 新增：管理員Excel匯入按鈕 */}
                    {isAdmin() && (
                      <button 
                        onClick={() => setShowExcelImport(true)} 
                        className="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm"
                      >
                        📊 匯入題目
                      </button>
                    )}
                    <button onClick={() => setCurrentView('dashboard')} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">進入系統</button>
                    <button onClick={() => { setIsLoggedIn(false); setCurrentUser(null) }} className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200">登出</button>
                  </div>
                ) : (
                  <div className="flex items-center space-x-2">
                    <button onClick={() => setShowLoginModal(true)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">登入系統</button>
                    <button 
                      onClick={() => {
                        console.log('調試狀態:', { currentView, isLoggedIn, currentUser })
                        alert(`狀態: ${currentView}, 登入: ${isLoggedIn}, 用戶: ${currentUser?.username || '無'}`)
                      }}
                      className="px-2 py-1 bg-gray-200 text-gray-600 rounded text-xs hover:bg-gray-300"
                    >
                      🐛
                    </button>
                  </div>
                )}
              </div>
            </div>
          </nav>

          <main className="max-w-7xl mx-auto py-12 px-4">
            <div className="text-center mb-12">
              <h2 className="text-4xl font-bold text-gray-900 mb-4">醫事檢驗師國家考試線上練習系統</h2>
              <p className="text-xl text-gray-600 mb-8">
                {connectionStatus === 'online' ? '連接MySQL資料庫，提供真實考試體驗' : 
                 connectionStatus === 'offline' ? '目前為離線模式，使用模擬題目' : 
                 '正在連接資料庫...'}
              </p>
              <div className="flex justify-center space-x-4">
                {isLoggedIn ? (
                  <>
                    <button onClick={() => setCurrentView('dashboard')} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700">進入考試系統</button>
                    <button 
                      onClick={() => {
                        console.log('強制跳轉Dashboard')
                        setCurrentView('dashboard')
                      }}
                      className="bg-green-600 text-white px-4 py-3 rounded-lg font-semibold hover:bg-green-700"
                    >
                      強制進入Dashboard
                    </button>
                  </>
                ) : (
                  <button onClick={() => setShowLoginModal(true)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700">登入開始練習</button>
                )}
              </div>
            </div>

            {loading && connectionStatus === 'checking' ? (
              <div className="text-center py-8">
                <div className="inline-flex items-center space-x-3">
                  <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
                  <span className="text-gray-600">正在連接MySQL資料庫...</span>
                </div>
              </div>
            ) : (
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
                {subjects.map(subject => (
                  <div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                    <h3 className="text-lg font-bold text-gray-900 mb-2">{subject.name}</h3>
                    <p className="text-gray-600 mb-4 text-sm">{subject.description}</p>
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-blue-600 font-semibold">
                        {connectionStatus === 'online' ? '題庫練習' : '模擬練習'} • 60分鐘
                      </span>
                      <button
                        onClick={() => handleSubjectClick(subject.id)}
                        className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm"
                      >
                        {isLoggedIn ? '開始考試' : '登入考試'}
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}

            <div className="bg-white rounded-lg shadow-lg p-8 text-center">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">系統特色</h2>
              <div className="grid md:grid-cols-3 gap-8">
                <div>
                  <div className="text-4xl mb-2">🔗</div>
                  <h3 className="text-lg font-semibold mb-2">自動連線</h3>
                  <p className="text-gray-600">自動嘗試連接MySQL，失敗時切換離線模式</p>
                </div>
                <div>
                  <div className="text-4xl mb-2">⏱️</div>
                  <h3 className="text-lg font-semibold mb-2">真實考試體驗</h3>
                  <p className="text-gray-600">60分鐘限時作答，完全模擬考場環境</p>
                </div>
                <div>
                  <div className="text-4xl mb-2">📚</div>
                  <h3 className="text-lg font-semibold mb-2">完整題庫</h3>
                  <p className="text-gray-600">六大科目，涵蓋考試重點</p>
                </div>
              </div>
              
              {/* 新增：管理員專區 */}
              {isLoggedIn && isAdmin() && (
                <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                  <h3 className="text-lg font-semibold text-yellow-800 mb-2">🔧 管理員專區</h3>
                  <div className="flex justify-center space-x-4">
                    <button 
                      onClick={() => setShowExcelImport(true)}
                      className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
                    >
                      📊 Excel題目匯入
                    </button>
                    <button 
                      onClick={() => alert('題目管理功能開發中...')}
                      className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700"
                    >
                      📝 題目管理
                    </button>
                  </div>
                </div>
              )}
            </div>
          </main>
        </div>

        {/* Excel匯入彈窗 */}
        {showExcelImport && (
          <ExcelImport 
            apiService={apiService}
            onClose={() => setShowExcelImport(false)}
            onSuccess={handleImportSuccess}
          />
        )}

        {/* 原有的登入彈窗等保持不變... */}
        {showLoginModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">
                {selectedSubject ? `開始「${selectedSubject.name}」考試` : '系統登入'}
              </h3>
              {error && <div className="bg-red-50 border border-red-200 text-red-700 px-3 py-2 rounded mb-4">{error}</div>}
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">學號</label>
                  <input
                    type="text"
                    value={loginData.username}
                    onChange={(e) => setLoginData({...loginData, username: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">密碼</label>
                  <input
                    type="password"
                    value={loginData.password}
                    onChange={(e) => setLoginData({...loginData, password: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
                  <p className="text-sm text-blue-800">展示帳號：學號 DEMO001，密碼 demo123</p>
                  <p className="text-xs text-blue-600 mt-1">
                    目前狀態：{getConnectionStatusDisplay().text}
                  </p>
                  <p className="text-xs text-green-600 mt-1">
                    💡 DEMO001 擁有管理員權限，可使用Excel匯入功能
                  </p>
                </div>
              </div>
              <div className="flex gap-3 mt-6">
                <button
                  onClick={() => { setShowLoginModal(false); setSelectedSubject(null); setError('') }}
                  className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200"
                >
                  取消
                </button>
                <button
                  onClick={handleLogin}
                  disabled={loading}
                  className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50"
                >
                  {loading ? '登入中...' : (selectedSubject ? '登入並開始考試' : '登入')}
                </button>
              </div>
            </div>
          </div>
        )}

        {loading && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg p-6">
              <div className="flex items-center space-x-3">
                <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
                <span>處理中...</span>
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }

  if (currentView === 'dashboard') {
    const bestScore = examHistory.length > 0 ? Math.max(...examHistory.map(h => h.score)) : 0
    const avgScore = examHistory.length > 0 ? (examHistory.reduce((sum, h) => sum + h.score, 0) / examHistory.length).toFixed(1) : 0
    const statusDisplay = getConnectionStatusDisplay()

    return (
      <div className="min-h-screen bg-gray-50">
        <nav className="bg-white shadow-sm">
          <div className="max-w-7xl mx-auto px-4 py-4">
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <h1 className="text-xl font-bold text-gray-900">醫檢師考試系統</h1>
                <span className={`ml-2 px-2 py-1 text-xs rounded-full ${statusDisplay.color}`}>
                  {statusDisplay.text}
                </span>
              </div>
              <div className="flex items-center space-x-4">
                <span className="text-gray-700">歡迎，{currentUser?.username}</span>
                {/* Dashboard中也添加Excel匯入按鈕 */}
                {isAdmin() && (
                  <button 
                    onClick={() => setShowExcelImport(true)} 
                    className="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm"
                  >
                    📊 匯入題目
                  </button>
                )}
                <button onClick={() => setCurrentView('home')} className="text-blue-600 hover:text-blue-700">返回首頁</button>
                <button 
                  onClick={() => {
                    console.log('Dashboard狀態:', { currentView, isLoggedIn, currentUser, examHistory })
                    alert(`Dashboard狀態正常 - 用戶: ${currentUser?.username}`)
                  }}
                  className="px-2 py-1 bg-gray-200 text-gray-600 rounded text-xs hover:bg-gray-300"
                >
                  🐛
                </button>
                <button onClick={() => { setIsLoggedIn(false); setCurrentUser(null); setCurrentView('home') }} className="text-gray-500 hover:text-gray-700">登出</button>
              </div>
            </div>
          </div>
        </nav>

        <div className="max-w-7xl mx-auto py-8 px-4">
          <div className="grid lg:grid-cols-4 gap-6 mb-8">
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">最佳成績</h4>
              <p className="text-2xl font-bold text-yellow-600">{bestScore}</p>
            </div>
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">平均分數</h4>
              <p className="text-2xl font-bold text-blue-600">{avgScore}</p>
            </div>
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">考試次數</h4>
              <p className="text-2xl font-bold text-green-600">{examHistory.length}</p>
            </div>
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">學習狀態</h4>
              <p className="text-2xl font-bold text-purple-600">{examHistory.length > 0 ? '活躍' : '新手'}</p>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6 mb-8">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-lg font-semibold text-gray-900">選擇考試科目</h2>
              {/* 管理員快捷操作 */}
              {isAdmin() && (
                <div className="flex space-x-2">
                  <button 
                    onClick={() => setShowExcelImport(true)}
                    className="px-3 py-1 bg-green-100 text-green-700 rounded text-sm hover:bg-green-200"
                  >
                    📊 匯入題目
                  </button>
                </div>
              )}
            </div>
            {loading ? (
              <div className="text-center py-8">
                <div className="text-gray-600">載入中...</div>
              </div>
            ) : (
              <div className="grid md:grid-cols-2 gap-4">
                {subjects.map(subject => (
                  <div key={subject.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors">
                    <h3 className="font-semibold text-gray-900 mb-2">{subject.name}</h3>
                    <p className="text-sm text-gray-600 mb-4">{subject.description}</p>
                    <div className="flex justify-between items-center">
                      <span className="text-xs text-gray-500">
                        {connectionStatus === 'online' ? '題庫練習' : '模擬練習'} • 60分鐘
                      </span>
                      <button onClick={() => startExam(subject.id)} disabled={loading} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm disabled:opacity-50">開始考試</button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          {examHistory.length > 0 && (
            <div className="bg-white rounded-lg shadow p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-6">考試記錄</h2>
              <div className="space-y-3">
                {examHistory.slice(0, 5).map((record, index) => {
                  const subject = subjects.find(s => s.id === record.category_id)
                  return (
                    <div key={index} className="flex justify-between items-center py-2 border-b border-gray-100">
                      <div>
                        <div className="font-medium">{subject?.name || '未知科目'}</div>
                        <div className="text-sm text-gray-500">{new Date(record.exam_date).toLocaleDateString()}</div>
                      </div>
                      <div className="text-right">
                        <div className={`font-semibold ${record.score >= 80 ? 'text-green-600' : record.score >= 60 ? 'text-yellow-600' : 'text-red-600'}`}>{record.score}分</div>
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>
          )}
        </div>

        {/* Dashboard中的Excel匯入彈窗 */}
        {showExcelImport && (
          <ExcelImport 
            apiService={apiService}
            onClose={() => setShowExcelImport(false)}
            onSuccess={handleImportSuccess}
          />
        )}
      </div>
    )
  }

  // 其他視圖(exam, result)保持不變...
  // [其餘代碼保持原樣，包括考試視圖和結果視圖]

  // 默認返回首頁
  return (
    <div>
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">系統載入中...</h1>
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
        </div>
      </div>
    </div>
  )
}

export default App