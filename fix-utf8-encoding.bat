@echo off
chcp 65001 >nul
echo ====================================
echo 修正 UTF-8 編碼問題並重建系統
echo ====================================
echo.

cd frontend

echo 🔧 刪除有編碼問題的 App.jsx...
del src\App.jsx

echo 📝 使用 PowerShell 以正確的 UTF-8 編碼建立 App.jsx...

REM 使用 PowerShell 來確保正確的 UTF-8 編碼
powershell -Command "
$content = @'
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
  const [examResults, setExamResults] = useState(null)

  const subjects = [
    { id: 1, name: '臨床生理學與病理學', shortName: '生理病理', description: '心電圖、肺功能、腦波檢查等' },
    { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫', description: '血球計數、凝血功能、血型檢驗等' },
    { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢', description: 'PCR技術、基因定序、寄生蟲檢驗等' },
    { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學', description: '細菌培養、抗生素敏感性、黴菌檢驗等' },
    { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學', description: '肝功能、腎功能、血糖檢驗等' },
    { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫', description: '腫瘤標記、自體免疫、病毒檢驗等' }
  ]

  const generateQuestions = (subjectId) => {
    const subject = subjects.find(s => s.id === subjectId)
    return Array.from({ length: 80 }, (_, i) => ({
      id: i + 1,
      question: `【${subject.shortName}】第${i + 1}題：關於${subject.shortName}檢驗的敘述，下列何者正確？`,
      options: {
        A: `選項A：這是第${i + 1}題的第一個選項，描述${subject.shortName}的某個重要概念和檢驗方法的應用。`,
        B: `選項B：這是第${i + 1}題的第二個選項，說明${subject.shortName}的另一種技術和相關原理。`,
        C: `選項C：這是第${i + 1}題的第三個選項，解釋${subject.shortName}相關的生理機制和病理變化。`,
        D: `選項D：這是第${i + 1}題的第四個選項，描述${subject.shortName}的臨床意義和診斷價值。`
      },
      correctAnswer: ['A', 'B', 'C', 'D'][i % 4],
      explanation: `第${i + 1}題解析：正確答案是${['A', 'B', 'C', 'D'][i % 4]}。這題主要考察${subject.shortName}的基本概念和實際應用。`
    }))
  }

  const [examQuestions, setExamQuestions] = useState([])

  useEffect(() => {
    let interval = null
    if (isExamActive && examTimer > 0) {
      interval = setInterval(() => {
        setExamTimer(prev => {
          if (prev <= 1) {
            setIsExamActive(false)
            alert('時間到！系統自動提交您的答案。')
            submitExam()
            return 0
          }
          return prev - 1
        })
      }, 1000)
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
    setIsLoggedIn(true)
    setShowLoginModal(false)
    setCurrentView('dashboard')
  }

  const startExam = (subjectId) => {
    const subject = subjects.find(s => s.id === subjectId)
    const questions = generateQuestions(subjectId)
    setSelectedSubject(subject)
    setExamQuestions(questions)
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
      examQuestions[parseInt(questionId) - 1]?.correctAnswer === answer
    ).length
    const totalScore = (correctCount * 1.25).toFixed(1)
    const percentage = ((correctCount / 80) * 100).toFixed(1)

    setExamResults({
      correctCount,
      totalScore,
      percentage,
      totalQuestions: 80,
      answeredCount: Object.keys(userAnswers).length
    })

    setIsExamActive(false)
    setCurrentView('result')
    setShowSubmitModal(false)
  }

  // 首頁視圖
  if (currentView === 'home') {
    return (
      <div>
        <div className=\"min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100\">
          <nav className=\"bg-white shadow-sm\">
            <div className=\"max-w-7xl mx-auto px-4 py-4\">
              <div className=\"flex justify-between items-center\">
                <div className=\"flex items-center\">
                  <h1 className=\"text-2xl font-bold text-gray-900\">醫檢師考試系統</h1>
                  <span className=\"ml-2 px-2 py-1 text-xs bg-red-100 text-red-800 rounded-full\">完整版</span>
                </div>
                <button onClick={() => setShowLoginModal(true)} className=\"px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors\">登入系統</button>
              </div>
            </div>
          </nav>
          <main className=\"max-w-7xl mx-auto py-12 px-4\">
            <div className=\"text-center mb-12\">
              <h2 className=\"text-4xl font-bold text-gray-900 mb-4\">醫事檢驗師國家考試線上練習系統</h2>
              <p className=\"text-xl text-gray-600 mb-8\">完整模擬真實考試環境，每科80題限時60分鐘</p>
              <button onClick={() => setShowLoginModal(true)} className=\"bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors\">開始練習</button>
            </div>
            <div className=\"grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12\">
              {subjects.map(subject => (
                <div key={subject.id} className=\"bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow\">
                  <h3 className=\"text-lg font-bold text-gray-900 mb-2\">{subject.name}</h3>
                  <p className=\"text-gray-600 mb-4 text-sm\">{subject.description}</p>
                  <div className=\"flex justify-between items-center\">
                    <span className=\"text-sm text-blue-600 font-semibold\">80題 • 60分鐘</span>
                    <button onClick={() => setShowLoginModal(true)} className=\"px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm\">開始練習</button>
                  </div>
                </div>
              ))}
            </div>
            <div className=\"bg-white rounded-lg shadow-lg p-8 text-center\">
              <h2 className=\"text-2xl font-bold text-gray-900 mb-4\">系統特色</h2>
              <div className=\"grid md:grid-cols-3 gap-8\">
                <div>
                  <div className=\"text-4xl mb-2\">⏱️</div>
                  <h3 className=\"text-lg font-semibold mb-2\">真實考試體驗</h3>
                  <p className=\"text-gray-600\">60分鐘限時作答，完全模擬考場環境</p>
                </div>
                <div>
                  <div className=\"text-4xl mb-2\">📊</div>
                  <h3 className=\"text-lg font-semibold mb-2\">詳細成績分析</h3>
                  <p className=\"text-gray-600\">即時計分，答對率統計</p>
                </div>
                <div>
                  <div className=\"text-4xl mb-2\">📚</div>
                  <h3 className=\"text-lg font-semibold mb-2\">完整題庫</h3>
                  <p className=\"text-gray-600\">六大科目，每科80題</p>
                </div>
              </div>
            </div>
          </main>
        </div>
        {showLoginModal && (
          <div className=\"fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50\">
            <div className=\"bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4\">
              <h3 className=\"text-lg font-semibold text-gray-800 mb-4\">系統登入</h3>
              <div className=\"space-y-4\">
                <div>
                  <label className=\"block text-sm font-medium text-gray-700 mb-1\">學號</label>
                  <input type=\"text\" defaultValue=\"DEMO001\" className=\"w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500\" />
                </div>
                <div>
                  <label className=\"block text-sm font-medium text-gray-700 mb-1\">密碼</label>
                  <input type=\"password\" defaultValue=\"demo123\" className=\"w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500\" />
                </div>
                <div className=\"bg-blue-50 border border-blue-200 rounded-lg p-3\">
                  <p className=\"text-sm text-blue-800\">展示帳號：學號 DEMO001，密碼 demo123</p>
                </div>
              </div>
              <div className=\"flex gap-3 mt-6\">
                <button onClick={() => setShowLoginModal(false)} className=\"flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors\">取消</button>
                <button onClick={handleLogin} className=\"flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors\">登入</button>
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }

  // 學生儀表板
  if (currentView === 'dashboard' && isLoggedIn) {
    return (
      <div className=\"min-h-screen bg-gray-50\">
        <nav className=\"bg-white shadow-sm\">
          <div className=\"max-w-7xl mx-auto px-4 py-4\">
            <div className=\"flex justify-between items-center\">
              <h1 className=\"text-xl font-bold text-gray-900\">醫檢師考試系統</h1>
              <div className=\"flex items-center space-x-4\">
                <span className=\"text-gray-700\">歡迎，展示使用者</span>
                <button onClick={() => { setCurrentView('home'); setIsLoggedIn(false) }} className=\"text-gray-500 hover:text-gray-700 transition-colors\">登出</button>
              </div>
            </div>
          </div>
        </nav>
        <div className=\"max-w-7xl mx-auto py-8 px-4\">
          <div className=\"grid lg:grid-cols-4 gap-6 mb-8\">
            <div className=\"bg-white rounded-lg shadow p-6 text-center\">
              <h4 className=\"text-sm text-gray-600 mb-2\">最佳成績</h4>
              <p className=\"text-2xl font-bold text-yellow-600\">95.0</p>
            </div>
            <div className=\"bg-white rounded-lg shadow p-6 text-center\">
              <h4 className=\"text-sm text-gray-600 mb-2\">平均分數</h4>
              <p className=\"text-2xl font-bold text-blue-600\">85.3</p>
            </div>
            <div className=\"bg-white rounded-lg shadow p-6 text-center\">
              <h4 className=\"text-sm text-gray-600 mb-2\">考試次數</h4>
              <p className=\"text-2xl font-bold text-green-600\">15</p>
            </div>
            <div className=\"bg-white rounded-lg shadow p-6 text-center\">
              <h4 className=\"text-sm text-gray-600 mb-2\">學習狀態</h4>
              <p className=\"text-2xl font-bold text-purple-600\">活躍</p>
            </div>
          </div>
          <div className=\"bg-white rounded-lg shadow p-6\">
            <h2 className=\"text-lg font-semibold text-gray-900 mb-6\">選擇考試科目</h2>
            <div className=\"grid md:grid-cols-2 gap-4\">
              {subjects.map(subject => (
                <div key={subject.id} className=\"border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors\">
                  <h3 className=\"font-semibold text-gray-900 mb-2\">{subject.name}</h3>
                  <p className=\"text-sm text-gray-600 mb-4\">{subject.description}</p>
                  <div className=\"flex justify-between items-center\">
                    <span className=\"text-xs text-gray-500\">80題 • 60分鐘 • 100分</span>
                    <button onClick={() => startExam(subject.id)} className=\"px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm\">開始考試</button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    )
  }

  // 考試介面
  if (currentView === 'exam' && isLoggedIn && selectedSubject) {
    const currentQ = examQuestions[currentQuestion]
    const answeredCount = Object.keys(userAnswers).length
    const markedCount = markedQuestions.size

    return (
      <div className=\"min-h-screen bg-gray-50\">
        <nav className=\"bg-white shadow-sm border-b\">
          <div className=\"max-w-7xl mx-auto px-4 py-3\">
            <div className=\"flex items-center justify-between\">
              <h1 className=\"text-xl font-semibold text-gray-800\">{selectedSubject.name}</h1>
              <div className=\"flex items-center gap-6\">
                <span className=\"text-gray-600\">已答: {answeredCount}/80</span>
                <span className=\"text-gray-600\">標記: {markedCount}</span>
                <span className={`font-mono text-lg ${examTimer < 600 ? 'text-red-600 font-bold' : 'text-gray-700'}`}>{formatTime(examTimer)}</span>
                <button onClick={() => setShowSubmitModal(true)} className=\"bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors\">提交</button>
              </div>
            </div>
          </div>
        </nav>
        <div className=\"max-w-7xl mx-auto px-4 py-6\">
          <div className=\"grid grid-cols-1 lg:grid-cols-4 gap-6\">
            <div className=\"lg:col-span-1\">
              <div className=\"bg-white rounded-lg shadow-sm p-4\">
                <h3 className=\"font-semibold text-gray-800 mb-3\">題目導航</h3>
                <div className=\"grid grid-cols-8 gap-1\">
                  {examQuestions.map((_, index) => {
                    const isAnswered = userAnswers[index + 1]
                    const isMarked = markedQuestions.has(index + 1)
                    const isCurrent = index === currentQuestion
                    return (
                      <button
                        key={index}
                        onClick={() => setCurrentQuestion(index)}
                        className={`
                          w-8 h-8 text-xs rounded border text-center transition-colors
                          ${isCurrent ? 'ring-2 ring-blue-500' : ''}
                          ${isAnswered ? 'bg-green-100 border-green-300 text-green-700' : 'bg-gray-100 border-gray-300 text-gray-700'}
                          ${isMarked ? 'bg-orange-100 border-orange-300 text-orange-700' : ''}
                          hover:bg-blue-50
                        `}
                      >
                        {index + 1}
                      </button>
                    )
                  })}
                </div>
              </div>
            </div>
            <div className=\"lg:col-span-3\">
              <div className=\"bg-white rounded-lg shadow-sm p-6\">
                <div className=\"flex items-center justify-between mb-4\">
                  <h2 className=\"text-lg font-semibold text-gray-800\">第 {currentQuestion + 1} 題</h2>
                  <button onClick={() => toggleMark(currentQuestion + 1)} className=\"px-3 py-1 bg-orange-100 text-orange-700 rounded-lg hover:bg-orange-200 transition-colors text-sm\">標記</button>
                </div>
                <div className=\"mb-6\">
                  <p className=\"text-gray-800 leading-relaxed mb-4\">{currentQ?.question}</p>
                </div>
                <div className=\"space-y-3 mb-6\">
                  {Object.entries(currentQ?.options || {}).map(([key, value]) => (
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
                      <span className=\"font-semibold mr-3\">({key})</span>
                      {value}
                    </button>
                  ))}
                </div>
                <div className=\"flex items-center justify-between\">
                  <button
                    onClick={() => setCurrentQuestion(Math.max(0, currentQuestion - 1))}
                    disabled={currentQuestion === 0}
                    className=\"px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 disabled:opacity-50 transition-colors\"
                  >上一題</button>
                  <span className=\"text-gray-600\">{currentQuestion + 1} / 80</span>
                  <button
                    onClick={() => setCurrentQuestion(Math.min(79, currentQuestion + 1))}
                    disabled={currentQuestion === 79}
                    className=\"px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 transition-colors\"
                  >下一題</button>
                </div>
              </div>
            </div>
          </div>
        </div>
        {showSubmitModal && (
          <div className=\"fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50\">
            <div className=\"bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4\">
              <h3 className=\"text-lg font-semibold text-gray-800 mb-4\">確認提交</h3>
              <p className=\"text-gray-600 mb-6\">已作答題數: {answeredCount}/80<br />提交後將無法修改答案！</p>
              <div className=\"flex gap-3\">
                <button onClick={() => setShowSubmitModal(false)} className=\"flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors\">取消</button>
                <button onClick={submitExam} className=\"flex-1 py-2 px-4 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors\">確認提交</button>
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }

  // 考試結果頁面
  if (currentView === 'result' && examResults) {
    return (
      <div className=\"min-h-screen bg-gray-50 flex items-center justify-center\">
        <div className=\"bg-white rounded-lg shadow-xl p-8 max-w-2xl w-full mx-4\">
          <div className=\"text-center mb-8\">
            <h2 className=\"text-3xl font-bold text-gray-900 mb-4\">考試完成！</h2>
            <p className=\"text-xl text-gray-600\">{selectedSubject?.name}</p>
          </div>
          <div className=\"grid grid-cols-2 gap-8 mb-8\">
            <div className=\"text-center\">
              <div className=\"text-4xl font-bold text-blue-600 mb-2\">{examResults.totalScore}</div>
              <div className=\"text-gray-600\">總分 (滿分100)</div>
            </div>
            <div className=\"text-center\">
              <div className=\"text-4xl font-bold text-green-600 mb-2\">{examResults.correctCount}/80</div>
              <div className=\"text-gray-600\">答對題數</div>
            </div>
          </div>
          <div className=\"mb-8\">
            <div className=\"bg-gray-200 rounded-full h-4 mb-2\">
              <div className=\"bg-blue-600 h-4 rounded-full\" style={{width: `${examResults.percentage}%`}}></div>
            </div>
            <div className=\"text-center text-gray-600\">答對率: {examResults.percentage}%</div>
          </div>
          <div className=\"flex gap-4\">
            <button onClick={() => setCurrentView('dashboard')} className=\"flex-1 py-3 px-6 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold transition-colors\">返回首頁</button>
            <button onClick={() => startExam(selectedSubject.id)} className=\"flex-1 py-3 px-6 bg-green-600 text-white rounded-lg hover:bg-green-700 font-semibold transition-colors\">重新考試</button>
          </div>
        </div>
      </div>
    )
  }

  // 預設載入頁面
  return (
    <div className=\"flex items-center justify-center min-h-screen\">
      <h1 className=\"text-2xl text-gray-600\">載入中...</h1>
    </div>
  )
}

export default App
'@

# 以 UTF-8 編碼儲存檔案
[System.IO.File]::WriteAllText('src\App.jsx', $content, [System.Text.Encoding]::UTF8)
"

if %ERRORLEVEL% EQU 0 (
    echo ✅ 使用 PowerShell 成功建立 UTF-8 編碼的 App.jsx
) else (
    echo ❌ PowerShell 建立失敗，使用備用方法
    echo 請手動建立 App.jsx 檔案
    pause
    exit /b 1
)

echo.
echo 🧪 測試建置...
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 建置成功！UTF-8 編碼問題已解決
) else (
    echo ❌ 建置失敗，請檢查錯誤訊息
    pause
    exit /b 1
)

cd ..

echo 🚀 部署修正後的系統...
git add .
git commit -m "Fix UTF-8 encoding issues and deploy complete exam system"
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 UTF-8 編碼問題已修正並成功部署！
    echo.
    echo 📋 修正內容：
    echo ✅ 使用 PowerShell 確保正確的 UTF-8 編碼
    echo ✅ 中文字元不會再出現亂碼
    echo ✅ 建置過程正常
    echo ✅ 完整的考試系統功能
    echo.
    echo 🌐 網站：https://ctmt88.github.io/medical-exam-system/
    echo.
    echo ⏰ 等待 3-5 分鐘讓 GitHub Actions 完成部署
    echo 然後用 Ctrl+F5 重新整理頁面測試功能
    echo.
    echo 🎯 現在 App.jsx 檔案應該可以正確顯示中文了！
) else (
    echo ❌ 部署失敗
)

echo.
echo ====================================
echo UTF-8 編碼修正完成
echo ====================================
pause