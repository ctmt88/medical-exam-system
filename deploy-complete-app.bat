@echo off
chcp 65001 >nul
echo ====================================
echo 部署完整考試系統
echo ====================================
echo.

echo 🔧 請手動替換 App.jsx 內容...
echo.
echo 請按照以下步驟：
echo 1. 用文字編輯器開啟 frontend\src\App.jsx
echo 2. 刪除所有內容
echo 3. 複製貼上完整的 App.jsx 程式碼 ^(我會在下一步提供^)
echo 4. 儲存檔案
echo 5. 回來執行此批次檔的第二部分
echo.

pause

echo 📋 App.jsx 內容已準備好
echo 現在測試建置...

cd frontend
npm run build

if %ERRORLEVEL% EQU 0 (
    echo ✅ 建置成功！
) else (
    echo ❌ 建置失敗，請檢查 App.jsx 內容是否正確
    pause
    exit /b 1
)

cd ..

echo 🚀 部署到 GitHub...
git add .
git commit -m "Deploy complete exam system with full 80-question functionality"
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉🎉🎉 完整考試系統部署成功！ 🎉🎉🎉
    echo.
    echo 🌐 等待 3-5 分鐘後訪問：
    echo https://ctmt88.github.io/medical-exam-system/
    echo.
    echo 🎯 完整功能：
    echo ✅ 首頁 "完整版" 標籤
    echo ✅ 系統特色展示
    echo ✅ 登入系統 ^(DEMO001/demo123^)
    echo ✅ 學生儀表板
    echo ✅ 80題完整考試
    echo ✅ 60分鐘倒數計時器
    echo ✅ 題目導航網格
    echo ✅ 答題狀態和標記
    echo ✅ 考試結果分析
    echo ✅ 重考功能
    echo.
    echo 🏆 你現在有一個專業級的考試系統了！
) else (
    echo ❌ 部署失敗
)

echo.
echo ====================================
echo 部署完成
echo ====================================
pause