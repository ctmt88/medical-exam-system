import React from 'react' 
 
function App() { 
  return ( 
    <div className="min-h-screen bg-blue-50 flex items-center justify-center"> 
      <div className="text-center"> 
        <h1 className="text-4xl font-bold text-blue-600 mb-4"> 
          醫事檢驗師考試系統 
        </h1> 
        <p className="text-xl text-gray-600 mb-8"> 
          GitHub Pages 部署成功！ 
        </p> 
        <div className="bg-white rounded-lg shadow-lg p-8 max-w-2xl"> 
          <h2 className="text-2xl font-semibold mb-4">系統功能</h2> 
          <div className="grid grid-cols-2 gap-4 text-left"> 
            <div className="p-3 border rounded">臨床生理學與病理學</div> 
            <div className="p-3 border rounded">臨床血液學與血庫學</div> 
            <div className="p-3 border rounded">醫學分子檢驗學</div> 
            <div className="p-3 border rounded">微生物學</div> 
            <div className="p-3 border rounded">生物化學</div> 
            <div className="p-3 border rounded">血清免疫學</div> 
          </div> 
        </div> 
      </div> 
    </div> 
  ) 
} 
 
export default App 
