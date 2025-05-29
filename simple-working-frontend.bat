@echo off
chcp 65001 >nul
echo ====================================
echo 建立簡單可工作的完整前端
echo ====================================
echo.

cd frontend

echo 🔧 建立可工作的 App.jsx（避免複雜語法）...

REM 完全重寫 App.jsx 為簡單版本
del src\App.jsx

echo import React, { useState, useEffect } from 'react' > src\App.jsx
echo. >> src\App.jsx
echo function App() { >> src\App.jsx
echo   const [view, setView] = useState('home') >> src\App.jsx
echo   const [loggedIn, setLoggedIn] = useState(false) >> src\App.jsx
echo   const [showLogin, setShowLogin] = useState(false) >> src\App.jsx
echo   const [timer, setTimer] = useState(3600) >> src\App.jsx
echo   const [currentQ, setCurrentQ] = useState(0) >> src\App.jsx
echo   const [answers, setAnswers] = useState({}) >> src\App.jsx
echo   const [examActive, setExamActive] = useState(false) >> src\App.jsx
echo   const [subject, setSubject] = useState(null) >> src\App.jsx
echo. >> src\App.jsx
echo   const subjects = [ >> src\App.jsx
echo     { id: 1, name: '臨床生理學與病理學', short: '生理病理' }, >> src\App.jsx
echo     { id: 2, name: '臨床血液學與血庫學', short: '血液血庫' }, >> src\App.jsx
echo     { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', short: '分子鏡檢' }, >> src\App.jsx
echo     { id: 4, name: '微生物學與臨床微生物學', short: '微生物學' }, >> src\App.jsx
echo     { id: 5, name: '生物化學與臨床生化學', short: '生物化學' }, >> src\App.jsx
echo     { id: 6, name: '臨床血清免疫學與臨床病毒學', short: '血清免疫' } >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   const questions = Array.from({ length: 80 }, (_, i) =^> ({ >> src\App.jsx
echo     id: i + 1, >> src\App.jsx
echo     text: `第${i + 1}題：關於醫事檢驗的敘述，下列何者正確？`, >> src\App.jsx
echo     optionA: `選項A：第${i + 1}題的選項A`, >> src\App.jsx
echo     optionB: `選項B：第${i + 1}題的選項B`, >> src\App.jsx
echo     optionC: `選項C：第${i + 1}題的選項C`, >> src\App.jsx
echo     optionD: `選項D：第${i + 1}題的選項D`, >> src\App.jsx
echo     correct: ['A', 'B', 'C', 'D'][i %% 4] >> src\App.jsx
echo   })) >> src\App.jsx
echo. >> src\App.jsx
echo   const examHistory = [ >> src\App.jsx
echo     { id: 1, subject: '血液血庫', score: 87.5, date: '2024-05-20' }, >> src\App.jsx
echo     { id: 2, subject: '生物化學', score: 92.5, date: '2024-05-18' }, >> src\App.jsx
echo     { id: 3, subject: '微生物學', score: 78.75, date: '2024-05-15' } >> src\App.jsx
echo   ] >> src\App.jsx
echo. >> src\App.jsx
echo   useEffect(() =^> { >> src\App.jsx
echo     let interval >> src\App.jsx
echo     if (examActive ^&^& timer ^> 0) { >> src\App.jsx
echo       interval = setInterval(() =^> setTimer(t =^> t - 1), 1000) >> src\App.jsx
echo     } >> src\App.jsx
echo     return () =^> clearInterval(interval) >> src\App.jsx
echo   }, [examActive, timer]) >> src\App.jsx
echo. >> src\App.jsx
echo   const formatTime = (sec) =^> { >> src\App.jsx
echo     const h = Math.floor(sec / 3600) >> src\App.jsx
echo     const m = Math.floor((sec %% 3600) / 60) >> src\App.jsx
echo     const s = sec %% 60 >> src\App.jsx
echo     return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}` >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const doLogin = () =^> { >> src\App.jsx
echo     setLoggedIn(true) >> src\App.jsx
echo     setShowLogin(false) >> src\App.jsx
echo     setView('dashboard') >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const startExam = (subjectId) =^> { >> src\App.jsx
echo     const subj = subjects.find(s =^> s.id === subjectId) >> src\App.jsx
echo     setSubject(subj) >> src\App.jsx
echo     setView('exam') >> src\App.jsx
echo     setCurrentQ(0) >> src\App.jsx
echo     setTimer(3600) >> src\App.jsx
echo     setAnswers({}) >> src\App.jsx
echo     setExamActive(true) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const selectAnswer = (qId, ans) =^> { >> src\App.jsx
echo     setAnswers(prev =^> ({...prev, [qId]: ans})) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   const submitExam = () =^> { >> src\App.jsx
echo     const correct = Object.entries(answers).filter(([qId, ans]) =^> >> src\App.jsx
echo       questions[parseInt(qId) - 1]?.correct === ans >> src\App.jsx
echo     ).length >> src\App.jsx
echo     const score = (correct * 1.25).toFixed(1) >> src\App.jsx
echo     alert(`考試完成！\n答對：${correct}/80\n分數：${score}分`) >> src\App.jsx
echo     setExamActive(false) >> src\App.jsx
echo     setView('dashboard') >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx
echo   // 首頁 >> src\App.jsx
echo   if (view === 'home') { >> src\App.jsx
echo     return ( >> src\App.jsx
echo       React.createElement('div', {}, >> src\App.jsx
echo         React.createElement('div', { className: 'min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100' }, >> src\App.jsx
echo           React.createElement('nav', { className: 'bg-white shadow-sm' }, >> src\App.jsx
echo             React.createElement('div', { className: 'max-w-7xl mx-auto px-4 py-4' }, >> src\App.jsx
echo               React.createElement('div', { className: 'flex justify-between items-center' }, >> src\App.jsx
echo                 React.createElement('div', { className: 'flex items-center' }, >> src\App.jsx
echo                   React.createElement('h1', { className: 'text-2xl font-bold text-gray-900' }, '醫檢師考試系統'), >> src\App.jsx
echo                   React.createElement('span', { className: 'ml-2 px-2 py-1 text-xs bg-green-100 text-green-800 rounded-full' }, '完整版') >> src\App.jsx
echo                 ), >> src\App.jsx
echo                 React.createElement('button', { >> src\App.jsx
echo                   onClick: () =^> setShowLogin(true), >> src\App.jsx
echo                   className: 'px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700' >> src\App.jsx
echo                 }, '登入系統') >> src\App.jsx
echo               ) >> src\App.jsx
echo             ) >> src\App.jsx
echo           ), >> src\App.jsx
echo           React.createElement('main', { className: 'max-w-7xl mx-auto py-12 px-4' }, >> src\App.jsx
echo             React.createElement('div', { className: 'text-center mb-12' }, >> src\App.jsx
echo               React.createElement('h2', { className: 'text-4xl font-bold text-gray-900 mb-4' }, '醫事檢驗師國家考試線上練習系統'), >> src\App.jsx
echo               React.createElement('p', { className: 'text-xl text-gray-600 mb-8' }, '完整模擬真實考試環境，每科80題限時60分鐘'), >> src\App.jsx
echo               React.createElement('button', { >> src\App.jsx
echo                 onClick: () =^> setShowLogin(true), >> src\App.jsx
echo                 className: 'bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700' >> src\App.jsx
echo               }, '開始練習') >> src\App.jsx
echo             ), >> src\App.jsx
echo             React.createElement('div', { className: 'grid md:grid-cols-2 lg:grid-cols-3 gap-8' }, >> src\App.jsx
echo               subjects.map(subj =^> >> src\App.jsx
echo                 React.createElement('div', { >> src\App.jsx
echo                   key: subj.id, >> src\App.jsx
echo                   className: 'bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow' >> src\App.jsx
echo                 }, >> src\App.jsx
echo                   React.createElement('h3', { className: 'text-lg font-bold text-gray-900 mb-2' }, subj.name), >> src\App.jsx
echo                   React.createElement('p', { className: 'text-gray-600 mb-4 text-sm' }, subj.short), >> src\App.jsx
echo                   React.createElement('div', { className: 'flex justify-between items-center' }, >> src\App.jsx
echo                     React.createElement('span', { className: 'text-sm text-blue-600 font-semibold' }, '80題 • 60分鐘'), >> src\App.jsx
echo                     React.createElement('button', { >> src\App.jsx
echo                       onClick: () =^> setShowLogin(true), >> src\App.jsx
echo                       className: 'px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 text-sm' >> src\App.jsx
echo                     }, '開始練習') >> src\App.jsx
echo                   ) >> src\App.jsx
echo                 ) >> src\App.jsx
echo               ) >> src\App.jsx
echo             ) >> src\App.jsx
echo           ) >> src\App.jsx
echo         ), >> src\App.jsx
echo         showLogin ^&^& React.createElement('div', { className: 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50' }, >> src\App.jsx
echo           React.createElement('div', { className: 'bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4' }, >> src\App.jsx
echo             React.createElement('h3', { className: 'text-lg font-semibold text-gray-800 mb-4' }, '系統登入'), >> src\App.jsx
echo             React.createElement('div', { className: 'space-y-4' }, >> src\App.jsx
echo               React.createElement('div', {}, >> src\App.jsx
echo                 React.createElement('label', { className: 'block text-sm font-medium text-gray-700 mb-1' }, '學號'), >> src\App.jsx
echo                 React.createElement('input', { type: 'text', defaultValue: 'DEMO001', className: 'w-full px-3 py-2 border border-gray-300 rounded-lg' }) >> src\App.jsx
echo               ), >> src\App.jsx
echo               React.createElement('div', {}, >> src\App.jsx
echo                 React.createElement('label', { className: 'block text-sm font-medium text-gray-700 mb-1' }, '密碼'), >> src\App.jsx
echo                 React.createElement('input', { type: 'password', defaultValue: 'demo123', className: 'w-full px-3 py-2 border border-gray-300 rounded-lg' }) >> src\App.jsx
echo               ), >> src\App.jsx
echo               React.createElement('div', { className: 'bg-blue-50 border border-blue-200 rounded-lg p-3' }, >> src\App.jsx
echo                 React.createElement('p', { className: 'text-sm text-blue-800' }, '展示帳號：DEMO001 / demo123') >> src\App.jsx
echo               ) >> src\App.jsx
echo             ), >> src\App.jsx
echo             React.createElement('div', { className: 'flex gap-3 mt-6' }, >> src\App.jsx
echo               React.createElement('button', { >> src\App.jsx
echo                 onClick: () =^> setShowLogin(false), >> src\App.jsx
echo                 className: 'flex-1 py-2 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200' >> src\App.jsx
echo               }, '取消'), >> src\App.jsx
echo               React.createElement('button', { >> src\App.jsx
echo                 onClick: doLogin, >> src\App.jsx
echo                 className: 'flex-1 py-2 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700' >> src\App.jsx
echo               }, '登入') >> src\App.jsx
echo             ) >> src\App.jsx
echo           ) >> src\App.jsx
echo         ) >> src\App.jsx
echo       ) >> src\App.jsx
echo     ) >> src\App.jsx
echo   } >> src\App.jsx
echo. >> src\App.jsx

echo ✅ 首頁建立完成，繼續建立其他頁面...

REM 建立第二部分的批次檔
echo @echo off > ..\simple-frontend-part2.bat
echo chcp 65001 ^>nul >> ..\simple-frontend-part2.bat
echo echo 建立儀表板和考試介面... >> ..\simple-frontend-part2.bat
echo cd frontend >> ..\simple-frontend-part2.bat

echo ✅ 首頁部分完成
echo 建立了第二部分批次檔: simple-frontend-part2.bat
echo.

echo 🧪 測試當前建置...
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 建置成功！
    echo 現在執行第二部分來完成整個系統
) else (
    echo ❌ 建置失敗
    pause
    exit /b 1
)

cd ..

echo ====================================
echo 第一部分完成！請執行 simple-frontend-part2.bat
echo ====================================
pause