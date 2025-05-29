import React, { useState, useEffect } from 'react' 
 
function App() { 
  const [currentView, setCurrentView] = useState('home') 
  const [isLoggedIn, setIsLoggedIn] = useState(false) 
  const [showLoginModal, setShowLoginModal] = useState(false) 
  const [selectedSubject, setSelectedSubject] = useState(null) 
  const [examTimer, setExamTimer] = useState(3600) // 60分鐘 
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
 
  // 生成80題模擬題目 
  const generateQuestions = (subjectId) => { 
    const subject = subjects.find(s => s.id === subjectId) 
    return Array.from({ length: 80 }, (_, i) => ({ 
      id: i + 1, 
      question: `【${subject.shortName}】第${i + 1}題：關於${subject.shortName}檢驗的敘述，下列何者正確？`, 
      options: { 
        A: `選項A：這是第${i + 1}題的第一個選項，描述${subject.shortName}的某個重要概念或檢驗方法。`, 
        B: `選項B：這是第${i + 1}題的第二個選項，說明${subject.shortName}的另一種技術或應用。`, 
        C: `選項C：這是第${i + 1}題的第三個選項，解釋${subject.shortName}相關的生理機制或病理變化。`, 
        D: `選項D：這是第${i + 1}題的第四個選項，描述${subject.shortName}的臨床意義或診斷價值。` 
      }, 
      correctAnswer: ['A', 'B', 'C', 'D'][i % 4], 
      explanation: `第${i + 1}題解析：正確答案是${['A', 'B', 'C', 'D'][i % 4]}。這題主要考察${subject.shortName}的基本概念，在實際工作中需要熟練掌握相關知識點。` 
    })) 
  } 
 
  const [examQuestions, setExamQuestions] = useState([]) 
 
  // 計時器效果 
  useEffect(() => { 
    let interval = null 
    if (isExamActive && examTimer > 0) { 
      interval = setInterval(() => { 
        setExamTimer(prev => { 
          if (prev <= 1) { 
            setIsExamActive(false) 
            handleAutoSubmit() 
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
 
  const handleAutoSubmit = () => { 
    alert('時間到！系統將自動提交您的答案。') 
    submitExam() 
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
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"> 
          <nav className="bg-white shadow-sm"> 
            <div className="max-w-7xl mx-auto px-4 py-4"> 
              <div className="flex justify-between items-center"> 
                <div className="flex items-center"> 
                  <h1 className="text-2xl font-bold text-gray-900">醫檢師考試系統</h1> 
                  <span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full">完整版</span> 
                </div> 
                <button onClick={() => setShowLoginModal(true)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">登入系統</button> 
              </div> 
            </div> 
          </nav> 
          <main className="max-w-7xl mx-auto py-12 px-4"> 
            <div className="text-center mb-12"> 
              <h2 className="text-4xl font-bold text-gray-900 mb-4">醫事檢驗師國家考試線上練習系統</h2> 
              <p className="text-xl text-gray-600 mb-8">完整模擬真實考試環境，每科80題限時60分鐘</p> 
              <div className="flex justify-center space-x-4"> 
                <button onClick={() => setShowLoginModal(true)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors">開始練習</button> 
                <button onClick={() => setCurrentView('demo')} className="bg-gray-100 text-gray-700 px-8 py-3 rounded-lg font-semibold hover:bg-gray-200 transition-colors">功能展示</button> 
              </div> 
            </div> 
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12"> 
              {subjects.map(subject => ( 
                <div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"> 
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{subject.name}</h3> 
                  <p className="text-gray-600 mb-4 text-sm">{subject.description}</p> 
                  <div className="flex justify-between items-center"> 
                    <span className="text-sm text-blue-600 font-semibold">80題 • 60分鐘</span> 
                    <button onClick={() => setShowLoginModal(true)} className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm">開始練習</button> 
                  </div> 
                </div> 
              ))} 
            </div> 
            <div className="bg-white rounded-lg shadow-lg p-8 text-center"> 
              <h2 className="text-2xl font-bold text-gray-900 mb-4">系統特色</h2> 
              <div className="grid md:grid-cols-3 gap-8"> 
                <div> 
                  <div className="text-4xl mb-2">⏱️</div> 
                  <h3 className="text-lg font-semibold mb-2">真實考試體驗</h3> 
                  <p className="text-gray-600">60分鐘限時作答，完全模擬考場環境</p> 
                </div> 
                <div> 
                  <div className="text-4xl mb-2">📊</div> 
                  <h3 className="text-lg font-semibold mb-2">詳細成績分析</h3> 
                  <p className="text-gray-600">即時計分，答對率統計，弱點分析</p> 
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
              <h3 className="text-lg font-semibold text-gray-800 mb-4">系統登入</h3> 
              <div className="space-y-4"> 
                <div> 
                  <label className="block text-sm font-medium text-gray-700 mb-1">學號</label> 
                  <input type="text" defaultValue="DEMO001" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /> 
                </div> 
                <div> 
                  <label className="block text-sm font-medium text-gray-700 mb-1">密碼</label> 
                  <input type="password" defaultValue="demo123" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /> 
                </div> 
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-3"> 
                  <p className="text-sm text-blue-800"><strong>展示帳號</strong><br />學號：DEMO001 <br />密碼：demo123</p> 
                </div> 
              </div> 
              <div className="flex gap-3 mt-6"> 
                <button onClick={() => setShowLoginModal(false)} className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">取消</button> 
                <button onClick={handleLogin} className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">登入</button> 
              </div> 
            </div> 
          </div> 
        )} 
      </div> 
    ) 
  } 
 
@echo off
chcp 65001 >nul
echo ====================================
echo 完整前端系統 - 第二階段
echo 修正錯誤並建立學生儀表板
echo ====================================
echo.

cd frontend

echo 🔧 修正 App.jsx 語法錯誤並加入學生儀表板...

REM 先修正現有的語法錯誤，重新建立 App.jsx
echo 重新建立正確的 App.jsx...
echo import React, { useState, useEffect } from 'react' > src\App.jsx
echo. >> src\App.jsx
echo function App() { >> src\App.jsx
echo   const [currentView, setCurrentView] = useState('home') >> src\App.jsx
echo   const [isLoggedIn, setIsLoggedIn] = useState(false) >> src\App.jsx
echo   const [showLoginModal, setShowLoginModal] = useState(false) >> src\App.jsx
echo   const [selectedSubject, setSelectedSubject] = useState(null) >> src\App.jsx
echo   const [examTimer, setExamTimer] = useState(3600) >> src\App.jsx
echo   const [currentQuestion, setCurrentQuestion] = useState(0) >> src\App.jsx
echo   const [userAnswers, setUserAnswers] = useState({}) >> src\App.jsx
echo   const [markedQuestions, setMarkedQuestions] = useState(new Set()) >> src\App.jsx
echo   const [isExamActive, setIsExamActive] = useState(false) >> src\App.jsx
echo   const [showSubmitModal, setShowSubmitModal] = useState(false) >> src\App.jsx
echo   const [examResults, setExamResults] = useState(null) >> src\App.jsx
echo. >> src\App.jsx
echo   const subjects = [ >> src\App.jsx
echo     { id: 1, name: '臨床生理學與病理學', shortName: '生理病理', description: '心電圖、肺功能、腦波檢查等' }, >> src\App.jsx
echo     { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫', description: '血球計數、凝血功能、血型檢驗等' }, >> src\App.jsx
echo     { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢', description: 'PCR技術、基因定序、寄生蟲檢驗等' }, >> src\App.jsx
echo     { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學', description: '細菌培養、抗生素敏感性、黴菌檢驗等' }, >> src\App.jsx
echo     { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學', description: '肝功能、腎功能、血糖檢驗等' }, >> src\App.jsx
echo     { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫', description: '腫瘤標記、自體免疫、病毒檢驗等' } >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   const mockExamHistory = [ >> src\App.jsx
echo     { id: 1, subject: '臨床血液學與血庫學', score: 87.5, date: '2024-05-20', duration: 45, status: '已完成' }, >> src\App.jsx
echo     { id: 2, subject: '生物化學與臨床生化學', score: 92.5, date: '2024-05-18', duration: 52, status: '已完成' }, >> src\App.jsx
echo     { id: 3, subject: '微生物學與臨床微生物學', score: 78.75, date: '2024-05-15', duration: 58, status: '已完成' }, >> src\App.jsx
echo     { id: 4, subject: '臨床生理學與病理學', score: 85.0, date: '2024-05-12', duration: 48, status: '已完成' } >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   const generateQuestions = (subjectId) =^> { >> src\App.jsx
echo     const subject = subjects.find(s =^> s.id === subjectId) >> src\App.jsx
echo     return Array.from({ length: 80 }, (_, i) =^> ({ >> src\App.jsx
echo       id: i + 1, >> src\App.jsx
echo       question: `【${subject.shortName}】第${i + 1}題：關於${subject.shortName}檢驗的敘述，下列何者正確？`, >> src\App.jsx
echo       options: { >> src\App.jsx
echo         A: `選項A：第${i + 1}題選項A - ${subject.shortName}相關概念`, >> src\App.jsx
echo         B: `選項B：第${i + 1}題選項B - ${subject.shortName}技術應用`, >> src\App.jsx
echo         C: `選項C：第${i + 1}題選項C - ${subject.shortName}機制說明`, >> src\App.jsx
echo         D: `選項D：第${i + 1}題選項D - ${subject.shortName}臨床意義` >> src\App.jsx
echo       }, >> src\App.jsx
echo       correctAnswer: ['A', 'B', 'C', 'D'][i %% 4] >> src\App.jsx
echo     })) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const [examQuestions, setExamQuestions] = useState([]) >> src\App.jsx
echo. >> src\App.jsx
echo   useEffect(() =^> { >> src\App.jsx
echo     let interval = null >> src\App.jsx
echo     if (isExamActive ^&^& examTimer ^> 0) { >> src\App.jsx
echo       interval = setInterval(() =^> { >> src\App.jsx
echo         setExamTimer(prev =^> prev - 1) >> src\App.jsx
echo       }, 1000) >> src\App.jsx
echo     } else if (examTimer === 0 ^&^& isExamActive) { >> src\App.jsx
echo       setIsExamActive(false) >> src\App.jsx
echo       alert('時間到！') >> src\App.jsx
echo       submitExam() >> src\App.jsx
echo     } >> src\App.jsx
echo     return () =^> clearInterval(interval) >> src\App.jsx
echo   }, [isExamActive, examTimer]) >> src\App.jsx
echo. >> src\App.jsx
echo   const formatTime = (seconds) =^> { >> src\App.jsx
echo     const hours = Math.floor(seconds / 3600) >> src\App.jsx
echo     const minutes = Math.floor((seconds %% 3600) / 60) >> src\App.jsx
echo     const secs = seconds %% 60 >> src\App.jsx
echo     return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}` >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const handleLogin = () =^> { >> src\App.jsx
echo     setIsLoggedIn(true) >> src\App.jsx
echo     setShowLoginModal(false) >> src\App.jsx
echo     setCurrentView('dashboard') >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const startExam = (subjectId) =^> { >> src\App.jsx
echo     const subject = subjects.find(s =^> s.id === subjectId) >> src\App.jsx
echo     const questions = generateQuestions(subjectId) >> src\App.jsx
echo     setSelectedSubject(subject) >> src\App.jsx
echo     setExamQuestions(questions) >> src\App.jsx
echo     setCurrentView('exam') >> src\App.jsx
echo     setCurrentQuestion(0) >> src\App.jsx
echo     setExamTimer(3600) >> src\App.jsx
echo     setUserAnswers({}) >> src\App.jsx
echo     setMarkedQuestions(new Set()) >> src\App.jsx
echo     setIsExamActive(true) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const selectAnswer = (questionId, answer) =^> { >> src\App.jsx
echo     setUserAnswers(prev =^> ({...prev, [questionId]: answer})) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const submitExam = () =^> { >> src\App.jsx
echo     const correctCount = Object.entries(userAnswers).filter(([questionId, answer]) =^> >> src\App.jsx
echo       examQuestions[parseInt(questionId) - 1]?.correctAnswer === answer >> src\App.jsx
echo     ).length >> src\App.jsx
echo     const totalScore = (correctCount * 1.25).toFixed(1) >> src\App.jsx
echo. >> src\App.jsx
echo     setExamResults({ >> src\App.jsx
echo       correctCount, >> src\App.jsx
echo       totalScore, >> src\App.jsx
echo       totalQuestions: 80, >> src\App.jsx
echo       answeredCount: Object.keys(userAnswers).length >> src\App.jsx
echo     }) >> src\App.jsx
echo. >> src\App.jsx
echo     setIsExamActive(false) >> src\App.jsx
echo     setCurrentView('result') >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo ✅ 基礎邏輯修正完成
echo.

echo 🏠 建立首頁視圖...
echo   // 登入模態框 >> src\App.jsx
echo   const LoginModal = () =^> ( >> src\App.jsx
echo     ^<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"^> >> src\App.jsx
echo       ^<div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4"^> >> src\App.jsx
echo         ^<h3 className="text-lg font-semibold text-gray-800 mb-4"^>系統登入^</h3^> >> src\App.jsx
echo         ^<div className="space-y-4"^> >> src\App.jsx
echo           ^<div^> >> src\App.jsx
echo             ^<label className="block text-sm font-medium text-gray-700 mb-1"^>學號^</label^> >> src\App.jsx
echo             ^<input type="text" defaultValue="DEMO001" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div^> >> src\App.jsx
echo             ^<label className="block text-sm font-medium text-gray-700 mb-1"^>密碼^</label^> >> src\App.jsx
echo             ^<input type="password" defaultValue="demo123" className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" /^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo           ^<div className="bg-blue-50 border border-blue-200 rounded-lg p-3"^> >> src\App.jsx
echo             ^<p className="text-sm text-blue-800"^>展示帳號：DEMO001 / demo123^</p^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo         ^<div className="flex gap-3 mt-6"^> >> src\App.jsx
echo           ^<button onClick={() =^> setShowLoginModal(false)} className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200"^>取消^</button^> >> src\App.jsx
echo           ^<button onClick={handleLogin} className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700"^>登入^</button^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ) >> src\App.jsx
echo. >> src\App.jsx

echo   // 首頁視圖 >> src\App.jsx
echo   const HomePage = () =^> ( >> src\App.jsx
echo     ^<div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"^> >> src\App.jsx
echo       ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo           ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo             ^<div className="flex items-center"^> >> src\App.jsx
echo               ^<h1 className="text-2xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo               ^<span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full"^>完整版^</span^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<button onClick={() =^> setShowLoginModal(true)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"^>登入系統^</button^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</nav^> >> src\App.jsx
echo       ^<main className="max-w-7xl mx-auto py-12 px-4"^> >> src\App.jsx
echo         ^<div className="text-center mb-12"^> >> src\App.jsx
echo           ^<h2 className="text-4xl font-bold text-gray-900 mb-4"^>醫事檢驗師國家考試線上練習系統^</h2^> >> src\App.jsx
echo           ^<p className="text-xl text-gray-600 mb-8"^>完整模擬真實考試環境，每科80題限時60分鐘^</p^> >> src\App.jsx
echo           ^<button onClick={() =^> setShowLoginModal(true)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700"^>開始練習^</button^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo         ^<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12"^> >> src\App.jsx
echo           {subjects.map(subject =^> ( >> src\App.jsx
echo             ^<div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"^> >> src\App.jsx
echo               ^<h3 className="text-lg font-bold text-gray-900 mb-2"^>{subject.name}^</h3^> >> src\App.jsx
echo               ^<p className="text-gray-600 mb-4 text-sm"^>{subject.description}^</p^> >> src\App.jsx
echo               ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                 ^<span className="text-sm text-blue-600 font-semibold"^>80題 • 60分鐘^</span^> >> src\App.jsx
echo                 ^<button onClick={() =^> setShowLoginModal(true)} className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 text-sm"^>開始練習^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ))} >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo         ^<div className="bg-white rounded-lg shadow-lg p-8 text-center"^> >> src\App.jsx
echo           ^<h2 className="text-2xl font-bold text-gray-900 mb-4"^>系統特色^</h2^> >> src\App.jsx
echo           ^<div className="grid md:grid-cols-3 gap-8"^> >> src\App.jsx
echo             ^<div^> >> src\App.jsx
echo               ^<div className="text-4xl mb-2"^>⏱️^</div^> >> src\App.jsx
echo               ^<h3 className="text-lg font-semibold mb-2"^>真實考試體驗^</h3^> >> src\App.jsx
echo               ^<p className="text-gray-600"^>60分鐘限時作答，完全模擬考場環境^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div^> >> src\App.jsx
echo               ^<div className="text-4xl mb-2"^>📊^</div^> >> src\App.jsx
echo               ^<h3 className="text-lg font-semibold mb-2"^>詳細成績分析^</h3^> >> src\App.jsx
echo               ^<p className="text-gray-600"^>即時計分，答對率統計^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo             ^<div^> >> src\App.jsx
echo               ^<div className="text-4xl mb-2"^>📚^</div^> >> src\App.jsx
echo               ^<h3 className="text-lg font-semibold mb-2"^>完整題庫^</h3^> >> src\App.jsx
echo               ^<p className="text-gray-600"^>六大科目，每科80題^</p^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</main^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ) >> src\App.jsx
echo. >> src\App.jsx

echo ✅ 首頁視圖完成
echo.

echo 📊 建立學生儀表板...
echo   // 學生儀表板 >> src\App.jsx
echo   const Dashboard = () =^> ( >> src\App.jsx
echo     ^<div className="min-h-screen bg-gray-50"^> >> src\App.jsx
echo       ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo         ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo           ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo             ^<h1 className="text-xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo             ^<div className="flex items-center space-x-4"^> >> src\App.jsx
echo               ^<span className="text-gray-700"^>歡迎，展示使用者^</span^> >> src\App.jsx
echo               ^<button onClick={() =^> { setIsLoggedIn(false); setCurrentView('home') }} className="text-gray-500 hover:text-gray-700"^>登出^</button^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</nav^> >> src\App.jsx
echo. >> src\App.jsx
echo       ^<div className="max-w-7xl mx-auto py-8 px-4"^> >> src\App.jsx
echo         ^<div className="mb-8"^> >> src\App.jsx
echo           ^<h2 className="text-2xl font-bold text-gray-900 mb-2"^>學習儀表板^</h2^> >> src\App.jsx
echo           ^<p className="text-gray-600"^>追蹤您的學習進度和考試表現^</p^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo         ^<div className="grid lg:grid-cols-4 gap-6 mb-8"^> >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> src\App.jsx
echo             ^<div className="flex items-center"^> >> src\App.jsx
echo               ^<div className="flex-shrink-0"^> >> src\App.jsx
echo                 ^<div className="w-8 h-8 bg-yellow-100 rounded-lg flex items-center justify-center"^> >> src\App.jsx
echo                   ^<span className="text-yellow-600 font-bold text-lg"^>🏆^</span^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="ml-4"^> >> src\App.jsx
echo                 ^<p className="text-sm font-medium text-gray-600"^>最佳成績^</p^> >> src\App.jsx
echo                 ^<p className="text-2xl font-bold text-gray-900"^>95.0^</p^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> src\App.jsx
echo             ^<div className="flex items-center"^> >> src\App.jsx
echo               ^<div className="flex-shrink-0"^> >> src\App.jsx
echo                 ^<div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center"^> >> src\App.jsx
echo                   ^<span className="text-blue-600 font-bold text-lg"^>📊^</span^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="ml-4"^> >> src\App.jsx
echo                 ^<p className="text-sm font-medium text-gray-600"^>平均分數^</p^> >> src\App.jsx
echo                 ^<p className="text-2xl font-bold text-gray-900"^>85.9^</p^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> src\App.jsx
echo             ^<div className="flex items-center"^> >> src\App.jsx
echo               ^<div className="flex-shrink-0"^> >> src\App.jsx
echo                 ^<div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center"^> >> src\App.jsx
echo                   ^<span className="text-green-600 font-bold text-lg"^>📝^</span^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="ml-4"^> >> src\App.jsx
echo                 ^<p className="text-sm font-medium text-gray-600"^>考試次數^</p^> >> src\App.jsx
echo                 ^<p className="text-2xl font-bold text-gray-900"^>{mockExamHistory.length}^</p^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo           ^<div className="bg-white rounded-lg shadow p-6"^> >> src\App.jsx
echo             ^<div className="flex items-center"^> >> src\App.jsx
echo               ^<div className="flex-shrink-0"^> >> src\App.jsx
echo                 ^<div className="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center"^> >> src\App.jsx
echo                   ^<span className="text-purple-600 font-bold text-lg"^>⭐^</span^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="ml-4"^> >> src\App.jsx
echo                 ^<p className="text-sm font-medium text-gray-600"^>學習狀態^</p^> >> src\App.jsx
echo                 ^<p className="text-2xl font-bold text-green-600"^>活躍^</p^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo         ^<div className="grid lg:grid-cols-3 gap-8"^> >> src\App.jsx
echo           ^<div className="lg:col-span-2"^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow"^> >> src\App.jsx
echo               ^<div className="px-6 py-4 border-b border-gray-200"^> >> src\App.jsx
echo                 ^<h2 className="text-lg font-semibold text-gray-900"^>選擇考試科目^</h2^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="p-6"^> >> src\App.jsx
echo                 ^<div className="grid md:grid-cols-2 gap-4"^> >> src\App.jsx
echo                   {subjects.map(subject =^> ( >> src\App.jsx
echo                     ^<div key={subject.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors"^> >> src\App.jsx
echo                       ^<h3 className="font-semibold text-gray-900 mb-2"^>{subject.name}^</h3^> >> src\App.jsx
echo                       ^<p className="text-sm text-gray-600 mb-4"^>{subject.description}^</p^> >> src\App.jsx
echo                       ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                         ^<span className="text-xs text-gray-500"^>80題 • 60分鐘 • 100分^</span^> >> src\App.jsx
echo                         ^<button onClick={() =^> startExam(subject.id)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm"^>開始考試^</button^> >> src\App.jsx
echo                       ^</div^> >> src\App.jsx
echo                     ^</div^> >> src\App.jsx
echo                   ))} >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo           ^<div^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow"^> >> src\App.jsx
echo               ^<div className="px-6 py-4 border-b border-gray-200"^> >> src\App.jsx
echo                 ^<h2 className="text-lg font-semibold text-gray-900"^>最近考試記錄^</h2^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="p-6"^> >> src\App.jsx
echo                 ^<div className="space-y-4"^> >> src\App.jsx
echo                   {mockExamHistory.map(exam =^> ( >> src\App.jsx
echo                     ^<div key={exam.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"^> >> src\App.jsx
echo                       ^<div^> >> src\App.jsx
echo                         ^<p className="font-medium text-gray-900 text-sm"^>{exam.subject}^</p^> >> src\App.jsx
echo                         ^<p className="text-xs text-gray-500"^>{exam.date} • {exam.duration}分鐘^</p^> >> src\App.jsx
echo                       ^</div^> >> src\App.jsx
echo                       ^<div className="text-right"^> >> src\App.jsx
echo                         ^<p className="font-bold text-lg text-blue-600"^>{exam.score}^</p^> >> src\App.jsx
echo                         ^<p className="text-xs text-gray-500"^>分^</p^> >> src\App.jsx
echo                       ^</div^> >> src\App.jsx
echo                     ^</div^> >> src\App.jsx
echo                   ))} >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div className="mt-4 pt-4 border-t border-gray-200"^> >> src\App.jsx
echo                   ^<button className="w-full text-center text-blue-600 hover:text-blue-800 text-sm font-medium"^> >> src\App.jsx
echo                     查看全部記錄 >> src\App.jsx
echo                   ^</button^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ) >> src\App.jsx
echo. >> src\App.jsx

echo ✅ 學生儀表板完成
echo.

echo 🔧 建立主要渲染邏輯...
echo   // 主要渲染邏輯 >> src\App.jsx
echo   if (currentView === 'home') { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div^> >> src\App.jsx
echo         ^<HomePage /^> >> src\App.jsx
echo         {showLoginModal ^&^& ^<LoginModal /^>} >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   if (currentView === 'dashboard' ^&^& isLoggedIn) { >> src\App.jsx
echo     return ^<Dashboard /^> >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   if (currentView === 'exam' ^&^& isLoggedIn) { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div className="min-h-screen bg-gray-100 flex items-center justify-center"^> >> src\App.jsx
echo         ^<div className="text-center"^> >> src\App.jsx
echo           ^<h2 className="text-2xl font-bold text-gray-900 mb-4"^>考試功能開發中^</h2^> >> src\App.jsx
echo           ^<p className="text-gray-600 mb-6"^>完整的考試介面將在第三階段建立^</p^> >> src\App.jsx
echo           ^<button >> src\App.jsx
echo             onClick={() =^> setCurrentView('dashboard')} >> src\App.jsx
echo             className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700" >> src\App.jsx
echo           ^> >> src\App.jsx
echo             返回儀表板 >> src\App.jsx
echo           ^</button^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   if (currentView === 'result' ^&^& isLoggedIn ^&^& examResults) { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div className="min-h-screen bg-gray-100 flex items-center justify-center"^> >> src\App.jsx
echo         ^<div className="text-center"^> >> src\App.jsx
echo           ^<h2 className="text-2xl font-bold text-gray-900 mb-4"^>考試結果^</h2^> >> src\App.jsx
echo           ^<p className="text-gray-600 mb-6"^>結果頁面將在第四階段建立^</p^> >> src\App.jsx
echo           ^<button >> src\App.jsx
echo             onClick={() =^> setCurrentView('dashboard')} >> src\App.jsx
echo             className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700" >> src\App.jsx
echo           ^> >> src\App.jsx
echo             返回儀表板 >> src\App.jsx
echo           ^</button^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   return ( >> src\App.jsx
echo     ^<div className="min-h-screen bg-gray-100 flex items-center justify-center"^> >> src\App.jsx
echo       ^<div className="text-center"^> >> src\App.jsx
echo         ^<h1 className="text-2xl font-bold text-gray-900"^>載入中...^</h1^> >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ^</div^> >> src\App.jsx
echo   ) >> src\App.jsx
echo } >> src\App.jsx
echo. >> src\App.jsx
echo export default App >> src\App.jsx

echo ✅ 主要渲染邏輯完成
echo.

echo 🧪 測試建置...
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 第二階段建置成功！
) else (
    echo ❌ 建置失敗，請檢查錯誤
    pause
    exit /b 1
)

cd ..

echo 🚀 部署第二階段...
git add .
git commit -m "Complete stage 2: Add student dashboard with exam history and statistics"
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 第二階段部署成功！
    echo.
    echo 📋 第二階段完成內容：
    echo ✅ 修正了語法錯誤
    echo ✅ 完整的首頁視圖
    echo ✅ 功能完整的登入系統
    echo ✅ 美觀的學生儀表板
    echo ✅ 統計卡片顯示
    echo ✅ 考試歷史記錄
    echo ✅ 科目選擇界面
    echo ✅ 可點擊的考試按鈕
    echo.
    echo 🌐 等待 3-5 分鐘後訪問：
    echo https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 🎯 測試功能：
    echo 1. 點擊「登入系統」
    echo 2. 使用 DEMO001/demo123 登入
    echo 3. 查看美觀的儀表板
    echo 4. 查看統計卡片和考試記錄
    echo 5. 點擊任一科目的「開始考試」
    echo.
    echo 📱 現在你會看到：
    echo - 標題有「完整版」標籤
    echo - 現代化的統計卡片設計
    echo - 考試歷史記錄列表
    echo - 更專業的整體界面
    echo.
    echo 🚀 準備好執行第三階段了嗎？
    echo 第三階段將建立完整的80題考試介面！
) else (
    echo ❌ 部署失敗
)

echo.
echo ====================================
echo 第二階段完成！
echo ====================================
pause