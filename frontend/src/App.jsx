import React, { useState, useEffect } from 'react' 
 
function App() { 
  const [view, setView] = useState('home') 
  const [loggedIn, setLoggedIn] = useState(false) 
  const [showLogin, setShowLogin] = useState(false) 
  const [timer, setTimer] = useState(3600) 
  const [currentQ, setCurrentQ] = useState(0) 
  const [answers, setAnswers] = useState({}) 
  const [examActive, setExamActive] = useState(false) 
  const [subject, setSubject] = useState(null) 
 
  const subjects = [ 
    { id: 1, name: '臨床生理學與病理學', short: '生理病理' }, 
    { id: 2, name: '臨床血液學與血庫學', short: '血液血庫' }, 
    { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', short: '分子鏡檢' }, 
    { id: 4, name: '微生物學與臨床微生物學', short: '微生物學' }, 
    { id: 5, name: '生物化學與臨床生化學', short: '生物化學' }, 
    { id: 6, name: '臨床血清免疫學與臨床病毒學', short: '血清免疫' } 
  ] 
 
  const questions = Array.from({ length: 80 }, (_, i) => ({ 
    id: i + 1, 
    text: `第${i + 1}題：關於醫事檢驗的敘述，下列何者正確？`, 
    optionA: `選項A：第${i + 1}題的選項A`, 
    optionB: `選項B：第${i + 1}題的選項B`, 
    optionC: `選項C：第${i + 1}題的選項C`, 
    optionD: `選項D：第${i + 1}題的選項D`, 
    correct: ['A', 'B', 'C', 'D'][i % 4] 
  })) 
 
  const examHistory = [ 
    { id: 1, subject: '血液血庫', score: 87.5, date: '2024-05-20' }, 
    { id: 2, subject: '生物化學', score: 92.5, date: '2024-05-18' }, 
    { id: 3, subject: '微生物學', score: 78.75, date: '2024-05-15' } 
  ] 
 
  useEffect(() => { 
    let interval 
    if (examActive && timer > 0) { 
      interval = setInterval(() => setTimer(t => t - 1), 1000) 
    } 
    return () => clearInterval(interval) 
  }, [examActive, timer]) 
 
  const formatTime = (sec) => { 
    const h = Math.floor(sec / 3600) 
    const m = Math.floor((sec % 3600) / 60) 
    const s = sec % 60 
    return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}` 
  } 
 
  const doLogin = () => { 
    setLoggedIn(true) 
    setShowLogin(false) 
    setView('dashboard') 
  } 
 
  const startExam = (subjectId) => { 
    const subj = subjects.find(s => s.id === subjectId) 
    setSubject(subj) 
    setView('exam') 
    setCurrentQ(0) 
    setTimer(3600) 
    setAnswers({}) 
    setExamActive(true) 
  } 
 
  const selectAnswer = (qId, ans) => { 
    setAnswers(prev => ({...prev, [qId]: ans})) 
  } 
 
  const submitExam = () => { 
    const correct = Object.entries(answers).filter(([qId, ans]) => 
      questions[parseInt(qId) - 1]?.correct === ans 
    ).length 
    const score = (correct * 1.25).toFixed(1) 
    alert(`考試完成！\n答對：${correct}/80\n分數：${score}分`) 
    setExamActive(false) 
    setView('dashboard') 
  } 
 
  // 首頁 
  if (view === 'home') { 
    return ( 
      React.createElement('div', {}, 
        React.createElement('div', { className: 'min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100' }, 
          React.createElement('nav', { className: 'bg-white shadow-sm' }, 
            React.createElement('div', { className: 'max-w-7xl mx-auto px-4 py-4' }, 
              React.createElement('div', { className: 'flex justify-between items-center' }, 
                React.createElement('div', { className: 'flex items-center' }, 
                  React.createElement('h1', { className: 'text-2xl font-bold text-gray-900' }, '醫檢師考試系統'), 
                  React.createElement('span', { className: 'ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full' }, '完整版') 
                ), 
                React.createElement('button', { 
                  onClick: () => setShowLogin(true), 
                  className: 'px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700' 
                }, '登入系統') 
              ) 
            ) 
          ), 
          React.createElement('main', { className: 'max-w-7xl mx-auto py-12 px-4' }, 
            React.createElement('div', { className: 'text-center mb-12' }, 
              React.createElement('h2', { className: 'text-4xl font-bold text-gray-900 mb-4' }, '醫事檢驗師國家考試線上練習系統'), 
              React.createElement('p', { className: 'text-xl text-gray-600 mb-8' }, '完整模擬真實考試環境，每科80題限時60分鐘'), 
              React.createElement('button', { 
                onClick: () => setShowLogin(true), 
                className: 'bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700' 
              }, '開始練習') 
            ), 
            React.createElement('div', { className: 'grid md:grid-cols-2 lg:grid-cols-3 gap-8' }, 
              subjects.map(subj => 
                React.createElement('div', { 
                  key: subj.id, 
                  className: 'bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow' 
                }, 
                  React.createElement('h3', { className: 'text-lg font-bold text-gray-900 mb-2' }, subj.name), 
                  React.createElement('p', { className: 'text-gray-600 mb-4 text-sm' }, subj.short), 
                  React.createElement('div', { className: 'flex justify-between items-center' }, 
                    React.createElement('span', { className: 'text-sm text-blue-600 font-semibold' }, '80題 • 60分鐘'), 
                    React.createElement('button', { 
                      onClick: () => setShowLogin(true), 
                      className: 'px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 text-sm' 
                    }, '開始練習') 
                  ) 
                ) 
              ) 
            ) 
          ) 
        ), 
        showLogin && React.createElement('div', { className: 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50' }, 
          React.createElement('div', { className: 'bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4' }, 
            React.createElement('h3', { className: 'text-lg font-semibold text-gray-800 mb-4' }, '系統登入'), 
            React.createElement('div', { className: 'space-y-4' }, 
              React.createElement('div', {}, 
                React.createElement('label', { className: 'block text-sm font-medium text-gray-700 mb-1' }, '學號'), 
                React.createElement('input', { type: 'text', defaultValue: 'DEMO001', className: 'w-full px-3 py-2 border border-gray-300 rounded-lg' }) 
              ), 
              React.createElement('div', {}, 
                React.createElement('label', { className: 'block text-sm font-medium text-gray-700 mb-1' }, '密碼'), 
                React.createElement('input', { type: 'password', defaultValue: 'demo123', className: 'w-full px-3 py-2 border border-gray-300 rounded-lg' }) 
              ), 
              React.createElement('div', { className: 'bg-blue-50 border border-blue-200 rounded-lg p-3' }, 
                React.createElement('p', { className: 'text-sm text-blue-800' }, '展示帳號：DEMO001 / demo123') 
              ) 
            ), 
            React.createElement('div', { className: 'flex gap-3 mt-6' }, 
              React.createElement('button', { 
                onClick: () => setShowLogin(false), 
                className: 'flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200' 
              }, '取消'), 
              React.createElement('button', { 
                onClick: doLogin, 
                className: 'flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700' 
              }, '登入') 
            ) 
          ) 
        ) 
      ) 
    ) 
  } 
 
