// 以下為完整的 App.jsx，已改為從後端抽題，並保留答題暫存、標記與導覽功能

import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [currentView, setCurrentView] = useState('home');
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const [selectedSubject, setSelectedSubject] = useState(null);
  const [examTimer, setExamTimer] = useState(3600);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [userAnswers, setUserAnswers] = useState({});
  const [markedQuestions, setMarkedQuestions] = useState({});
  const [isExamActive, setIsExamActive] = useState(false);
  const [studentId, setStudentId] = useState('DEMO001');
  const [password, setPassword] = useState('demo123');
  const [questions, setQuestions] = useState([]);

  const subjects = [
    { id: 1, name: '臨床生理學與病理學', shortName: '生理病理' },
    { id: 2, name: '臨床血液學與血庫學', shortName: '血液血庫' },
    { id: 3, name: '醫學分子檢驗學與臨床鏡檢學', shortName: '分子鏡檢' },
    { id: 4, name: '微生物學與臨床微生物學', shortName: '微生物學' },
    { id: 5, name: '生物化學與臨床生化學', shortName: '生物化學' },
    { id: 6, name: '臨床血清免疫學與臨床病毒學', shortName: '血清免疫' }
  ];

  useEffect(() => {
    let interval = null;
    if (isExamActive) {
      interval = setInterval(() => {
        setExamTimer(t => {
          if (t <= 1) {
            clearInterval(interval);
            setIsExamActive(false);
            alert('時間到！考試結束');
            setCurrentView('result');
            return 0;
          }
          return t - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isExamActive]);

  const formatTime = sec => `${Math.floor(sec / 60)}:${(sec % 60).toString().padStart(2, '0')}`;

  const handleLogin = async () => {
    try {
      const res = await axios.post('https://starsport.tw/exam/api/?action=login', {
        student_id: studentId,
        password: password
      }, {
        headers: { 'Content-Type': 'application/json' }
      });
      if (res.data.success) {
        setIsLoggedIn(true);
        setShowLoginModal(false);
        setCurrentView('dashboard');
      } else {
        alert(res.data.error?.message || '登入失敗');
      }
    } catch (err) {
      alert('API 錯誤：' + err.message);
    }
  };

  const startExam = async (subjectId) => {
    const subject = subjects.find(s => s.id === subjectId);
    setSelectedSubject(subject);
    setCurrentQuestion(0);
    setUserAnswers({});
    setMarkedQuestions({});
    setExamTimer(3600);
    setIsExamActive(true);
    try {
      const res = await axios.post('https://starsport.tw/exam/api/?action=start_exam', {
        category_id: subjectId
      }, {
        headers: { 'Content-Type': 'application/json' }
      });
      if (res.data.success) {
        setQuestions(res.data.data.questions);
        setCurrentView('exam');
      } else {
        alert('取得題目失敗');
        setIsExamActive(false);
      }
    } catch (err) {
      alert('取得題目時發生錯誤');
      setIsExamActive(false);
    }
  };

  const toggleMark = (id) => {
    setMarkedQuestions(prev => ({ ...prev, [id]: !prev[id] }));
  };

  const QuestionNav = () => (
    <div className="grid grid-cols-10 gap-1 mt-4">
      {questions.map((q, i) => (
        <button
          key={q.id}
          onClick={() => setCurrentQuestion(i)}
          className={`text-sm rounded px-2 py-1 border ${currentQuestion === i ? 'bg-blue-500 text-white' : markedQuestions[q.id] ? 'bg-yellow-300' : userAnswers[q.id] ? 'bg-green-100' : 'bg-white'}`}
        >
          {i + 1}
        </button>
      ))}
    </div>
  );

  return (
    <div className="p-4">
      {showLoginModal && (
        <div className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center">
          <div className="bg-white p-6 rounded w-full max-w-sm">
            <h2 className="text-lg font-bold mb-4">登入</h2>
            <input className="w-full border p-2 mb-2" placeholder="學號" value={studentId} onChange={e => setStudentId(e.target.value)} />
            <input className="w-full border p-2 mb-4" type="password" placeholder="密碼" value={password} onChange={e => setPassword(e.target.value)} />
            <button className="w-full bg-blue-600 text-white py-2 rounded" onClick={handleLogin}>登入</button>
          </div>
        </div>
      )}

      {currentView === 'home' && (
        <div className="text-center mt-10">
          <h1 className="text-2xl font-bold mb-4">醫檢師考試系統</h1>
          <button className="bg-blue-500 text-white px-4 py-2 rounded" onClick={() => setShowLoginModal(true)}>登入</button>
        </div>
      )}

      {currentView === 'dashboard' && (
        <div>
          <h2 className="text-xl font-bold mb-4">選擇考試科目</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
            {subjects.map(s => (
              <button key={s.id} onClick={() => startExam(s.id)} className="border p-4 rounded hover:shadow">
                {s.name}
              </button>
            ))}
          </div>
        </div>
      )}

      {currentView === 'exam' && questions.length > 0 && (
        <div>
          <div className="flex justify-between items-center mb-4">
            <div className="text-lg font-bold">{selectedSubject?.name}</div>
            <div className="text-sm">倒數：{formatTime(examTimer)}</div>
          </div>
          <div className="mb-4">
            <p className="mb-2 font-semibold">{questions[currentQuestion].question_text}</p>
            {Object.entries(questions[currentQuestion].options).map(([key, val]) => (
              <div key={key}>
                <label className="block">
                  <input
                    type="radio"
                    name={`q_${currentQuestion}`}
                    checked={userAnswers[questions[currentQuestion].id] === key}
                    onChange={() => setUserAnswers(prev => ({ ...prev, [questions[currentQuestion].id]: key }))}
                  /> {key}. {val}
                </label>
              </div>
            ))}
          </div>
          <div className="flex justify-between mb-4">
            <button onClick={() => setCurrentQuestion(q => Math.max(0, q - 1))} className="bg-gray-200 px-3 py-1 rounded">上一題</button>
            <button onClick={() => setCurrentQuestion(q => Math.min(questions.length - 1, q + 1))} className="bg-gray-200 px-3 py-1 rounded">下一題</button>
            <button onClick={() => toggleMark(questions[currentQuestion].id)} className="bg-yellow-300 px-3 py-1 rounded">{markedQuestions[questions[currentQuestion].id] ? '取消標記' : '標記此題'}</button>
            <button onClick={() => setCurrentView('result')} className="bg-red-500 text-white px-3 py-1 rounded">交卷</button>
          </div>
          <QuestionNav />
        </div>
      )}

      {currentView === 'result' && (
        <div className="text-center mt-10">
          <h2 className="text-xl font-bold mb-4">考試完成</h2>
          <p className="mb-4">您已完成 {selectedSubject?.name} 考試。</p>
          <button className="bg-blue-500 text-white px-4 py-2 rounded" onClick={() => setCurrentView('dashboard')}>回主選單</button>
        </div>
      )}
    </div>
  );
}

export default App;
