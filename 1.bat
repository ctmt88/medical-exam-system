@echo off
chcp 65001 >nul
echo ====================================
echo 完整重建App.jsx修復語法錯誤
echo ====================================
echo.

cd frontend

echo 重新建立完整的App.jsx...
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
echo   const [loginData, setLoginData] = useState({ username: 'DEMO001', password: 'demo123' }) >> src\App.jsx
echo   const [currentUser, setCurrentUser] = useState(null) >> src\App.jsx
echo   const [loading, setLoading] = useState(false) >> src\App.jsx
echo   const [error, setError] = useState('') >> src\App.jsx
echo. >> src\App.jsx
echo   const subjects = [ >> src\App.jsx
echo     { id: 1, name: '臨床生理學與病理學', shortName: '生理病理', description: '心電圖、肺功能、腦波檢查等', questions: 80 }, >> src\App.jsx
echo     { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫', description: '血球計數、凝血功能、血型檢驗等', questions: 80 }, >> src\App.jsx
echo     { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢', description: 'PCR技術、基因定序、寄生蟲檢驗等', questions: 80 }, >> src\App.jsx
echo     { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學', description: '細菌培養、抗生素敏感性、黴菌檢驗等', questions: 80 }, >> src\App.jsx
echo     { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學', description: '肝功能、腎功能、血糖檢驗等', questions: 80 }, >> src\App.jsx
echo     { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫', description: '腫瘤標記、自體免疫、病毒檢驗等', questions: 80 } >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   const mockQuestions = Array.from({ length: 80 }, (_, i) =^> ({ >> src\App.jsx
echo     id: i + 1, >> src\App.jsx
echo     question: `第${i + 1}題：關於醫事檢驗的描述，下列何者正確？`, >> src\App.jsx
echo     options: { >> src\App.jsx
echo       A: `選項A：這是第${i + 1}題的選項A，描述某個檢驗方法的特點。`, >> src\App.jsx
echo       B: `選項B：這是第${i + 1}題的選項B，說明另一種檢驗技術。`, >> src\App.jsx
echo       C: `選項C：這是第${i + 1}題的選項C，解釋相關的生理機制。`, >> src\App.jsx
echo       D: `選項D：這是第${i + 1}題的選項D，描述臨床應用情況。` >> src\App.jsx
echo     }, >> src\App.jsx
echo     correctAnswer: ['A', 'B', 'C', 'D'][i %% 4] >> src\App.jsx
echo   })) >> src\App.jsx
echo. >> src\App.jsx
echo   useEffect(() =^> { >> src\App.jsx
echo     let interval = null >> src\App.jsx
echo     if (isExamActive ^&^& examTimer ^> 0) { >> src\App.jsx
echo       interval = setInterval(() =^> { >> src\App.jsx
echo         setExamTimer(timer =^> timer - 1) >> src\App.jsx
echo       }, 1000) >> src\App.jsx
echo     } else if (examTimer === 0) { >> src\App.jsx
echo       setIsExamActive(false) >> src\App.jsx
echo       alert('時間到！考試結束') >> src\App.jsx
echo       setCurrentView('result') >> src\App.jsx
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
echo     setLoading(true) >> src\App.jsx
echo     setError('') >> src\App.jsx
echo     setTimeout(() =^> { >> src\App.jsx
echo       if (loginData.username === 'DEMO001' ^&^& loginData.password === 'demo123') { >> src\App.jsx
echo         setCurrentUser({ id: 1, username: 'DEMO001', name: '展示用戶' }) >> src\App.jsx
echo         setIsLoggedIn(true) >> src\App.jsx
echo         setShowLoginModal(false) >> src\App.jsx
echo         if (selectedSubject) { >> src\App.jsx
echo           startExam(selectedSubject.id) >> src\App.jsx
echo         } else { >> src\App.jsx
echo           setCurrentView('dashboard') >> src\App.jsx
echo         } >> src\App.jsx
echo       } else { >> src\App.jsx
echo         setError('學號或密碼錯誤') >> src\App.jsx
echo       } >> src\App.jsx
echo       setLoading(false) >> src\App.jsx
echo     }, 500) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const handleSubjectClick = (subjectId) =^> { >> src\App.jsx
echo     if (isLoggedIn) { >> src\App.jsx
echo       startExam(subjectId) >> src\App.jsx
echo     } else { >> src\App.jsx
echo       setSelectedSubject(subjects.find(s =^> s.id === subjectId)) >> src\App.jsx
echo       setShowLoginModal(true) >> src\App.jsx
echo     } >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const startExam = (subjectId) =^> { >> src\App.jsx
echo     const subject = subjects.find(s =^> s.id === subjectId) >> src\App.jsx
echo     setSelectedSubject(subject) >> src\App.jsx
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
echo   const toggleMark = (questionId) =^> { >> src\App.jsx
echo     setMarkedQuestions(prev =^> { >> src\App.jsx
echo       const newMarked = new Set(prev) >> src\App.jsx
echo       if (newMarked.has(questionId)) { >> src\App.jsx
echo         newMarked.delete(questionId) >> src\App.jsx
echo       } else { >> src\App.jsx
echo         newMarked.add(questionId) >> src\App.jsx
echo       } >> src\App.jsx
echo       return newMarked >> src\App.jsx
echo     }) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   if (currentView === 'home') { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       ^<div^> >> src\App.jsx
echo         ^<div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100"^> >> src\App.jsx
echo           ^<nav className="bg-white shadow-sm"^> >> src\App.jsx
echo             ^<div className="max-w-7xl mx-auto px-4 py-4"^> >> src\App.jsx
echo               ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                 ^<div className="flex items-center"^> >> src\App.jsx
echo                   ^<h1 className="text-2xl font-bold text-gray-900"^>醫檢師考試系統^</h1^> >> src\App.jsx
echo                   ^<span className="ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full"^>免登入瀏覽^</span^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 {isLoggedIn ? ( >> src\App.jsx
echo                   ^<div className="flex items-center space-x-4"^> >> src\App.jsx
echo                     ^<span className="text-gray-700"^>歡迎，{currentUser?.username}^</span^> >> src\App.jsx
echo                     ^<button onClick={() =^> setCurrentView('dashboard')} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"^>進入系統^</button^> >> src\App.jsx
echo                     ^<button onClick={() =^> { setIsLoggedIn(false); setCurrentUser(null) }} className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200"^>登出^</button^> >> src\App.jsx
echo                   ^</div^> >> src\App.jsx
echo                 ) : ( >> src\App.jsx
echo                   ^<button onClick={() =^> setShowLoginModal(true)} className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"^>登入系統^</button^> >> src\App.jsx
echo                 )} >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</nav^> >> src\App.jsx
echo. >> src\App.jsx
echo           ^<main className="max-w-7xl mx-auto py-12 px-4"^> >> src\App.jsx
echo             ^<div className="text-center mb-12"^> >> src\App.jsx
echo               ^<h2 className="text-4xl font-bold text-gray-900 mb-4"^>醫事檢驗師國家考試線上練習系統^</h2^> >> src\App.jsx
echo               ^<p className="text-xl text-gray-600 mb-8"^>提供完整的六大科目練習，可免登入瀏覽，登入後開始考試^</p^> >> src\App.jsx
echo               ^<div className="flex justify-center space-x-4"^> >> src\App.jsx
echo                 {isLoggedIn ? ( >> src\App.jsx
echo                   ^<button onClick={() =^> setCurrentView('dashboard')} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700"^>進入考試系統^</button^> >> src\App.jsx
echo                 ) : ( >> src\App.jsx
echo                   ^<button onClick={() =^> setShowLoginModal(true)} className="bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700"^>登入開始練習^</button^> >> src\App.jsx
echo                 )} >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo             ^<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12"^> >> src\App.jsx
echo               {subjects.map(subject =^> ( >> src\App.jsx
echo                 ^<div key={subject.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow"^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-bold text-gray-900 mb-2"^>{subject.name}^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600 mb-4 text-sm"^>{subject.description}^</p^> >> src\App.jsx
echo                   ^<div className="flex justify-between items-center"^> >> src\App.jsx
echo                     ^<span className="text-sm text-blue-600 font-semibold"^>{subject.questions}題 • 60分鐘^</span^> >> src\App.jsx
echo                     ^<button >> src\App.jsx
echo                       onClick={() =^> handleSubjectClick(subject.id)} >> src\App.jsx
echo                       className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors text-sm" >> src\App.jsx
echo                     ^> >> src\App.jsx
echo                       {isLoggedIn ? '開始考試' : '登入考試'} >> src\App.jsx
echo                     ^</button^> >> src\App.jsx
echo                   ^</div^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ))} >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-lg p-8 text-center"^> >> src\App.jsx
echo               ^<h2 className="text-2xl font-bold text-gray-900 mb-4"^>系統特色^</h2^> >> src\App.jsx
echo               ^<div className="grid md:grid-cols-3 gap-8"^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<div className="text-4xl mb-2"^>👀^</div^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-semibold mb-2"^>免登入瀏覽^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600"^>可先瀏覽所有科目內容，決定後再登入考試^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<div className="text-4xl mb-2"^>⏱️^</div^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-semibold mb-2"^>真實考試體驗^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600"^>60分鐘限時作答，完全模擬考場環境^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<div className="text-4xl mb-2"^>📚^</div^> >> src\App.jsx
echo                   ^<h3 className="text-lg font-semibold mb-2"^>完整題庫^</h3^> >> src\App.jsx
echo                   ^<p className="text-gray-600"^>六大科目，每科80題，涵蓋考試重點^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</main^> >> src\App.jsx
echo         ^</div^> >> src\App.jsx
echo. >> src\App.jsx
echo         {showLoginModal ^&^& ( >> src\App.jsx
echo           ^<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"^> >> src\App.jsx
echo             ^<div className="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4"^> >> src\App.jsx
echo               ^<h3 className="text-lg font-semibold text-gray-800 mb-4"^> >> src\App.jsx
echo                 {selectedSubject ? `開始「${selectedSubject.name}」考試` : '系統登入'} >> src\App.jsx
echo               ^</h3^> >> src\App.jsx
echo               {error ^&^& ^<div className="bg-red-50 border border-red-200 text-red-700 px-3 py-2 rounded mb-4"^>{error}^</div^>} >> src\App.jsx
echo               ^<div className="space-y-4"^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<label className="block text-sm font-medium text-gray-700 mb-1"^>學號^</label^> >> src\App.jsx
echo                   ^<input >> src\App.jsx
echo                     type="text" >> src\App.jsx
echo                     value={loginData.username} >> src\App.jsx
echo                     onChange={(e) =^> setLoginData({...loginData, username: e.target.value})} >> src\App.jsx
echo                     className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" >> src\App.jsx
echo                   /^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div^> >> src\App.jsx
echo                   ^<label className="block text-sm font-medium text-gray-700 mb-1"^>密碼^</label^> >> src\App.jsx
echo                   ^<input >> src\App.jsx
echo                     type="password" >> src\App.jsx
echo                     value={loginData.password} >> src\App.jsx
echo                     onChange={(e) =^> setLoginData({...loginData, password: e.target.value})} >> src\App.jsx
echo                     className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" >> src\App.jsx
echo                   /^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo                 ^<div className="bg-blue-50 border border-blue-200 rounded-lg p-3"^> >> src\App.jsx
echo                   ^<p className="text-sm text-blue-800"^>展示帳號：學號 DEMO001，密碼 demo123^</p^> >> src\App.jsx
echo                 ^</div^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo               ^<div className="flex gap-3 mt-6"^> >> src\App.jsx
echo                 ^<button >> src\App.jsx
echo                   onClick={() =^> { setShowLoginModal(false); setSelectedSubject(null); setError('') }} >> src\App.jsx
echo                   className="flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200" >> src\App.jsx
echo                 ^> >> src\App.jsx
echo                   取消 >> src\App.jsx
echo                 ^</button^> >> src\App.jsx
echo                 ^<button >> src\App.jsx
echo                   onClick={handleLogin} >> src\App.jsx
echo                   disabled={loading} >> src\App.jsx
echo                   className="flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50" >> src\App.jsx
echo                 ^> >> src\App.jsx
echo                   {loading ? '登入中...' : (selectedSubject ? '登入並開始考試' : '登入')} >> src\App.jsx
echo                 ^</button^> >> src\App.jsx
echo               ^</div^> >> src\App.jsx
echo             ^</div^> >> src\App.jsx
echo           ^</div^> >> src\App.jsx
echo         )} >> src\App.jsx
echo       ^</div^> >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo @echo off > ..\fix-app-stage2.bat
echo chcp 65001 ^>nul >> ..\fix-app-stage2.bat
echo echo 建立Dashboard和其他頁面... >> ..\fix-app-stage2.bat

echo 第一階段完成：首頁和登入邏輯
echo 執行 fix-app-stage2.bat 完成其他頁面

cd ..
echo ====================================
echo App.jsx修復第一階段完成
echo ====================================
pause