import React, { useState, useEffect } from 'react'

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

  const subjects = [
    { id: 1, name: '臨床生理學與病理學', shortName: '生理病理', description: '心電圖、肺功能、腦波檢查等', questions: 80 },
    { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫', description: '血球計數、凝血功能、血型檢驗等', questions: 80 },
    { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢', description: 'PCR技術、基因定序、寄生蟲檢驗等', questions: 80 },
    { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學', description: '細菌培養、抗生素敏感性、黴菌檢驗等', questions: 80 },
    { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學', description: '肝功能、腎功能、血糖檢驗等', questions: 80 },
    { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫', description: '腫瘤標記、自體免疫、病毒檢驗等', questions: 80 }
  ]

  const mockQuestions = Array.from({ length: 80 }, (_, i) => ({
    id: i + 1,
    question: `第${i + 1}題：關於醫事檢驗的描述，下列何者正確？（這是模擬題目）`,
    options: {
      A: `選項A：這是第${i + 1}題的選項A，描述某個檢驗方法的特點。`,
      B: `選項B：這是第${i + 1}題的選項B，說明另一種檢驗技術。`,
      C: `選項C：這是第${i + 1}題的選項C，解釋相關的生理機制。`,
      D: `選項D：這是第${i + 1}題的選項D，描述臨床應用情況。`
    },
    correctAnswer: ['A', 'B', 'C', 'D'][i % 4]
  }))

  useEffect(() => {
    let interval = null
    if (isExamActive && examTimer > 0) {
      interval = setInterval(() => {
        setExamTimer(timer => timer - 1)
      }, 1000)
    } else if (examTimer === 0) {
      setIsExamActive(false)
      alert('時間到！考試結束')
      setCurrentView('result')
    }
    return () => clearInterval(interval)
  }, [isExamActive, examTimer])

  const formatTime = (seconds) => {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  const handleLogin = () => {
    setLoading(true)
    setError('')
    setTimeout(() => {
      if (loginData.username === 'DEMO001' && loginData.password === 'demo123') {
        setCurrentUser({ id: 1, username: 'DEMO001', name: '展示用戶' })
        setIsLoggedIn(true)
        setShowLoginModal(false)
        if (selectedSubject) {
          startExam(selectedSubject.id)
        } else {
          setCurrentView('dashboard')
        }
      } else {
        setError('學號或密碼錯誤')
      }
      setLoading(false)
    }, 500)
  }

  const handleSubjectClick = (subjectId) => {
    if (isLoggedIn) {
      startExam(subjectId)
    } else {
      setSelectedSubject(subjects.find(s => s.id === subjectId))
      setShowLoginModal(true)
    }
  }

  const startExam = (subjectId) => {
    const subject = subjects.find(s => s.id === subjectId)
    setSelectedSubject(subject)
    setCurrentView('exam')
    setCurrentQuestion(0)
    setExamTimer(3600)
    setUserAnswers({})
    setMarkedQuestions(new Set())
    setIsExamActive(true)
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

  const submitExam = () => {
    const correctCount = Object.entries(userAnswers).filter(([questionId, answer]) =>
      mockQuestions[parseInt(questionId) - 1]?.correctAnswer === answer
    ).length
    setIsExamActive(false)
    setCurrentView('result')
    setShowSubmitModal(false)
  }

  if (currentView === 'home') {
    return (
      <div>
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
          <nav className="bg-white shadow-sm">
            <div className="max-w-7xl mx-auto px-4 py-4">
              <div className="flex justify-between items-center">
                <div className="flex items-center">
                  <h1 className="text-2xl font-bold text-gray-900">醫檢師考試系統</h1>
                  <span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full">免登入瀏覽</span>
                </div>
                {isLoggedIn ? (
                  <div className="flex items-center space-x-4">
                    <span className="text-gray-700">歡迎，{currentUser?.username}</span>
                    <button onClick={() => setCurrentView('dashboard')} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">進入系統</button>
                    <button onClick={() => { setIsLoggedIn(false); setCurrentUser(null) }} className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200">登出</button>
                  </div>
                ) : (
                  <button onClick={() => setShowLoginModal(true)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">登入系統</button>
                )}
              </div>
            </div>
          </nav>

          <main className="max-w-7xl mx-auto py-12 px-4">
            <div className="text-center mb-12">
              <h2 className="text-4xl font-bold text-gray-900 mb-4">醫事檢驗師國家考試線上練習系統</h2>
              <p className="text-xl text-gray-600 mb-8">提供完整的六大科目練習，可免登入瀏覽，登入後開始考試</p>
              <div className="flex justify-center space-x-4">
                {isLoggedIn ? (
                  <button onClick={() => setCurrentView('dashboard')} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700">進入考試系統</button>
                ) : (
                  <button onClick={() => setShowLoginModal(true)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700">登入開始練習</button>
                )}
              </div>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
              {subjects.map(subject => (
                <div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{subject.name}</h3>
                  <p className="text-gray-600 mb-4 text-sm">{subject.description}</p>
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-blue-600 font-semibold">{subject.questions}題 • 60分鐘</span>
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

            <div className="bg-white rounded-lg shadow-lg p-8 text-center">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">系統特色</h2>
              <div className="grid md:grid-cols-3 gap-8">
                <div>
                  <div className="text-4xl mb-2">👀</div>
                  <h3 className="text-lg font-semibold mb-2">免登入瀏覽</h3>
                  <p className="text-gray-600">可先瀏覽所有科目內容，決定後再登入考試</p>
                </div>
                <div>
                  <div className="text-4xl mb-2">⏱️</div>
                  <h3 className="text-lg font-semibold mb-2">真實考試體驗</h3>
                  <p className="text-gray-600">60分鐘限時作答，完全模擬考場環境</p>
                </div>
                <div>
                  <div className="text-4xl mb-2">📚</div>
                  <h3 className="text-lg font-semibold mb-2">完整題庫</h3>
                  <p className="text-gray-600">六大科目，每科80題，涵蓋考試重點</p>
                </div>
              </div>
            </div>
          </main>
        </div>

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
      </div>
    )
  }

  if (currentView === 'dashboard') {
    return (
      <div className="min-h-screen bg-gray-50">
        <nav className="bg-white shadow-sm">
          <div className="max-w-7xl mx-auto px-4 py-4">
            <div className="flex justify-between items-center">
              <h1 className="text-xl font-bold text-gray-900">醫檢師考試系統</h1>
              <div className="flex items-center space-x-4">
                <span className="text-gray-700">歡迎，{currentUser?.username}</span>
                <button onClick={() => setCurrentView('home')} className="text-blue-600 hover:text-blue-700">返回首頁</button>
                <button onClick={() => { setIsLoggedIn(false); setCurrentUser(null); setCurrentView('home') }} className="text-gray-500 hover:text-gray-700">登出</button>
              </div>
            </div>
          </div>
        </nav>

        <div className="max-w-7xl mx-auto py-8 px-4">
          <div className="grid lg:grid-cols-4 gap-6 mb-8">
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">最佳成績</h4>
              <p className="text-2xl font-bold text-yellow-600">95.0</p>
            </div>
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">平均分數</h4>
              <p className="text-2xl font-bold text-blue-600">85.3</p>
            </div>
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">考試次數</h4>
              <p className="text-2xl font-bold text-green-600">15</p>
            </div>
            <div className="bg-white rounded-lg shadow p-6">
              <h4 className="text-sm text-gray-600">學習狀態</h4>
              <p className="text-2xl font-bold text-purple-600">活躍</p>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-6">選擇考試科目</h2>
            <div className="grid md:grid-cols-2 gap-4">
              {subjects.map(subject => (
                <div key={subject.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors">
                  <h3 className="font-semibold text-gray-900 mb-2">{subject.name}</h3>
                  <p className="text-sm text-gray-600 mb-4">{subject.description}</p>
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-500">{subject.questions}題 • 60分鐘 • 100分</span>
                    <button onClick={() => startExam(subject.id)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm">開始考試</button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (currentView === 'exam') {
    return (
      <div className="min-h-screen bg-gray-50">
        <nav className="bg-white shadow-sm border-b">
          <div className="max-w-7xl mx-auto px-4 py-3">
            <div className="flex items-center justify-between">
              <h1 className="text-xl font-semibold text-gray-800">{selectedSubject?.name}</h1>
              <div className="flex items-center gap-6">
                <div className="flex items-center gap-2 text-gray-600">
                  <span>已答: {Object.keys(userAnswers).length}/80</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className={`font-mono text-lg ${examTimer < 600 ? 'text-red-600 font-bold' : 'text-gray-700'}`}>
                    {formatTime(examTimer)}
                  </span>
                </div>
                <button onClick={() => setShowSubmitModal(true)} className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700">提交</button>
              </div>
            </div>
          </div>
        </nav>

        <div className="max-w-7xl mx-auto px-4 py-6">
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div className="lg:col-span-1">
              <div className="bg-white rounded-lg shadow-sm p-4">
                <h3 className="font-semibold text-gray-800 mb-3">題目導航</h3>
                <div className="grid grid-cols-8 gap-1">
                  {mockQuestions.map((_, index) => {
                    const isAnswered = userAnswers[index + 1]
                    const isCurrent = index === currentQuestion
                    const isMarked = markedQuestions.has(index + 1)
                    return (
                      <button
                        key={index}
                        onClick={() => setCurrentQuestion(index)}
                        className={`
                          w-8 h-8 text-xs rounded border text-center transition-colors relative
                          ${isCurrent ? 'ring-2 ring-blue-500' : ''}
                          ${isAnswered ? 'bg-green-100 border-green-300 text-green-700' : 'bg-gray-100 border-gray-300 text-gray-700'}
                          hover:bg-blue-50
                        `}
                      >
                        {index + 1}
                        {isMarked && <div className="absolute -top-1 -right-1 w-2 h-2 bg-yellow-400 rounded-full"></div>}
                      </button>
                    )
                  })}
                </div>
              </div>
            </div>

            <div className="lg:col-span-3">
              <div className="bg-white rounded-lg shadow-sm p-6">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-lg font-semibold text-gray-800">第 {currentQuestion + 1} 題</h2>
                  <button
                    onClick={() => toggleMark(currentQuestion + 1)}
                    className={`px-3 py-1 rounded text-sm ${markedQuestions.has(currentQuestion + 1) ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-700'}`}
                  >
                    {markedQuestions.has(currentQuestion + 1) ? '已標記' : '標記'}
                  </button>
                </div>

                <div className="mb-6">
                  <p className="text-gray-800 leading-relaxed mb-4">
                    {mockQuestions[currentQuestion]?.question}
                  </p>
                </div>

                <div className="space-y-3 mb-6">
                  {Object.entries(mockQuestions[currentQuestion]?.options || {}).map(([key, value]) => (
                    <button
                      key={key}
                      onClick={() => selectAnswer(currentQuestion + 1, key)}
                      className={`
                        w-full p-4 text-left rounded-lg border transition-colors
                        ${userAnswers[currentQuestion + 1] === key
                          ? 'bg-blue-100 border-blue-300 text-blue-800'
                          : 'bg-gray-50 border-gray-200 text-gray-800 hover:bg-gray-100'}
                      `}
                    >
                      <span className="font-semibold mr-3">({key})</span>
                      {value}
                    </button>
                  ))}
                </div>

                <div className="flex items-center justify-between">
                  <button
                    onClick={() => setCurrentQuestion(Math.max(0, currentQuestion - 1))}
                    disabled={currentQuestion === 0}
                    className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    上一題
                  </button>
                  <span className="text-gray-600">{currentQuestion + 1} / 80</span>
                  <button
                    onClick={() => setCurrentQuestion(Math.min(79, currentQuestion + 1))}
                    disabled={currentQuestion === 79}
                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    下一題
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        {showSubmitModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">確認提交</h3>
              <p className="text-gray-600 mb-6">您已作答 {Object.keys(userAnswers).length}/80 題，確定要提交嗎？</p>
              <div className="flex gap-3">
                <button onClick={() => setShowSubmitModal(false)} className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">取消</button>
                <button onClick={submitExam} className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">確認提交</button>
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }

  if (currentView === 'result') {
    const correctCount = Object.entries(userAnswers).filter(([questionId, answer]) =>
      mockQuestions[parseInt(questionId) - 1]?.correctAnswer === answer
    ).length
    const score = (correctCount * 1.25).toFixed(1)
    const percentage = ((correctCount / 80) * 100).toFixed(1)

    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="bg-white rounded-lg shadow-xl p-8 max-w-2xl w-full mx-4">
          <div className="text-center mb-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">考試完成！</h2>
            <p className="text-xl text-gray-600">{selectedSubject?.name}</p>
          </div>

          <div className="grid grid-cols-2 gap-8 mb-8">
            <div className="text-center">
              <div className="text-4xl font-bold text-blue-600 mb-2">{score}</div>
              <div className="text-gray-600">總分 (滿分100)</div>
            </div>
            <div className="text-center">
              <div className="text-4xl font-bold text-green-600 mb-2">{correctCount}/80</div>
              <div className="text-gray-600">答對題數</div>
            </div>
          </div>

          <div className="mb-8">
            <div className="bg-gray-200 rounded-full h-4 mb-2">
              <div className="bg-blue-600 h-4 rounded-full transition-all duration-1000" style={{width: `${percentage}%`}}></div>
            </div>
            <div className="text-center text-gray-600">答對率: {percentage}%</div>
          </div>

          <div className="border-t pt-6">
            <div className="text-center mb-4">
              {parseFloat(score) >= 80 ? (
                <div className="text-green-600 font-semibold">🎉 優秀！已達到優良標準</div>
              ) : parseFloat(score) >= 60 ? (
                <div className="text-yellow-600 font-semibold">👍 良好！達到及格標準</div>
              ) : (
                <div className="text-red-600 font-semibold">💪 繼續努力！多加練習</div>
              )}
            </div>
          </div>

          <div className="flex gap-4">
            <button
              onClick={() => setCurrentView('dashboard')}
              className="flex-1 py-3 px-6 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold"
            >
              返回首頁
            </button>
            <button
              onClick={() => startExam(selectedSubject.id)}
              className="flex-1 py-3 px-6 bg-green-600 text-white rounded-lg hover:bg-green-700 font-semibold"
            >
              重新考試
            </button>
          </div>
        </div>
      </div>
    )
  }

  return null
}

export default App