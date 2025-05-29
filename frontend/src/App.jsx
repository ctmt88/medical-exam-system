import React, { useState } from 'react' 
 
function App() { 
  const [showLogin, setShowLogin] = useState(false) 
  const [isLoggedIn, setIsLoggedIn] = useState(false) 
 
  const subjects = [ 
    '臨床生理學與病理學', 
    '臨床血液學與血庫學', 
    '醫學分子檢驗學與臨床鏡檢學', 
    '微生物學與臨床微生物學', 
    '生物化學與臨床生化學', 
    '臨床血清免疫學與臨床病毒學' 
  ] 
 
  const handleLogin = () => { 
    setIsLoggedIn(true) 
    setShowLogin(false) 
  } 
 
  const startExam = (subject) => { 
    alert(`準備開始 ${subject} 考試！\n\n這是展示版本，完整功能開發中...`) 
  } 
 
  if (!isLoggedIn) { 
    return ( 
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"> 
        <nav className="bg-white shadow-sm"> 
          <div className="max-w-7xl mx-auto px-4 py-4"> 
            <div className="flex justify-between items-center"> 
              <div className="flex items-center"> 
                <h1 className="text-2xl font-bold text-gray-900">醫檢師考試系統</h1> 
                <span className="ml-2 px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded-full">互動展示版</span> 
              </div> 
              <button 
                onClick={() => setShowLogin(true)} 
                className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors" 
              > 
                登入系統 
              </button> 
            </div> 
          </div> 
        </nav> 
 
        <main className="max-w-7xl mx-auto py-12 px-4"> 
          <div className="text-center mb-12"> 
            <h2 className="text-4xl font-bold text-gray-900 mb-4"> 
              醫事檢驗師國家考試線上練習系統 
            </h2> 
            <p className="text-xl text-gray-600 mb-8"> 
              互動展示版 - 點擊登入體驗完整功能 
            </p> 
            <button 
              onClick={() => setShowLogin(true)} 
              className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors" 
            > 
              立即體驗 
            </button> 
          </div> 
 
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8"> 
            {subjects.map((subject, index) => ( 
              <div key={index} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"> 
                <h3 className="text-lg font-bold text-gray-900 mb-2">{subject}</h3> 
                <p className="text-gray-600 mb-4 text-sm">80題 • 60分鐘 • 滿分100分</p> 
                <button 
                  onClick={() => setShowLogin(true)} 
                  className="w-full px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm font-medium" 
                > 
                  開始練習 
                </button> 
              </div> 
            ))} 
          </div> 
        </main> 
 
        {showLogin && ( 
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"> 
            <div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4"> 
              <h3 className="text-lg font-semibold text-gray-800 mb-4">系統登入</h3> 
              <div className="space-y-4"> 
                <div> 
                  <label className="block text-sm font-medium text-gray-700 mb-1">學號</label> 
                  <input 
                    type="text" 
                    defaultValue="DEMO001" 
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" 
                  /> 
                </div> 
                <div> 
                  <label className="block text-sm font-medium text-gray-700 mb-1">密碼</label> 
                  <input 
                    type="password" 
                    defaultValue="demo123" 
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" 
                  /> 
                </div> 
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-3"> 
                  <p className="text-sm text-blue-800"> 
                    展示帳號：學號 DEMO001，密碼 demo123 
                  </p> 
                </div> 
              </div> 
              <div className="flex gap-3 mt-6"> 
                <button 
                  onClick={() => setShowLogin(false)} 
                  className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors" 
                > 
                  取消 
                </button> 
                <button 
                  onClick={handleLogin} 
                  className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors" 
                > 
                  登入 
                </button> 
              </div> 
            </div> 
          </div> 
        )} 
      </div> 
    ) 
  } 
 
  return ( 
    <div className="min-h-screen bg-gray-50"> 
      <nav className="bg-white shadow-sm"> 
        <div className="max-w-7xl mx-auto px-4 py-4"> 
          <div className="flex justify-between items-center"> 
            <h1 className="text-xl font-bold text-gray-900">醫檢師考試系統</h1> 
            <div className="flex items-center space-x-4"> 
              <span className="text-gray-700">歡迎，展示使用者</span> 
              <button 
                onClick={() => setIsLoggedIn(false)} 
                className="text-gray-500 hover:text-gray-700 transition-colors" 
              > 
                登出 
              </button> 
            </div> 
          </div> 
        </div> 
      </nav> 
 
      <div className="max-w-7xl mx-auto py-8 px-4"> 
        <div className="grid lg:grid-cols-4 gap-6 mb-8"> 
          <div className="bg-white rounded-lg shadow p-6 text-center"> 
            <h4 className="text-sm text-gray-600 mb-2">最佳成績</h4> 
            <p className="text-2xl font-bold text-yellow-600">95.0</p> 
          </div> 
          <div className="bg-white rounded-lg shadow p-6 text-center"> 
            <h4 className="text-sm text-gray-600 mb-2">平均分數</h4> 
            <p className="text-2xl font-bold text-blue-600">85.3</p> 
          </div> 
          <div className="bg-white rounded-lg shadow p-6 text-center"> 
            <h4 className="text-sm text-gray-600 mb-2">考試次數</h4> 
            <p className="text-2xl font-bold text-green-600">15</p> 
          </div> 
          <div className="bg-white rounded-lg shadow p-6 text-center"> 
            <h4 className="text-sm text-gray-600 mb-2">學習狀態</h4> 
            <p className="text-2xl font-bold text-purple-600">活躍</p> 
          </div> 
        </div> 
 
        <div className="bg-white rounded-lg shadow p-6"> 
          <h2 className="text-lg font-semibold text-gray-900 mb-6">選擇考試科目</h2> 
          <div className="grid md:grid-cols-2 gap-4"> 
            {subjects.map((subject, index) => ( 
              <div key={index} className="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors"> 
                <h3 className="font-semibold text-gray-900 mb-2">{subject}</h3> 
                <p className="text-sm text-gray-600 mb-4">80題 • 60分鐘 • 滿分100分</p> 
                <button 
                  onClick={() => startExam(subject)} 
                  className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium" 
                > 
                  開始考試 
                </button> 
              </div> 
            ))} 
          </div> 
        </div> 
      </div> 
    </div> 
  ) 
} 
 
export default App 
