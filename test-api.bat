@echo off 
echo 🧪 測試 Azure API... 
echo. 
curl -X GET https://ctmt88.azurewebsites.net/ 
echo. 
echo. 
curl -X GET https://ctmt88.azurewebsites.net/health 
echo. 
echo. 
curl -X GET https://ctmt88.azurewebsites.net/api/exam/categories 
echo. 
pause 
