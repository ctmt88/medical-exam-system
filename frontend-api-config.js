const API_CONFIG = { 
  development: { 
    baseURL: 'http://localhost:8000/api', 
    useMockData: false 
  }, 
  production: { 
    baseURL: 'https://ctmt88.azurewebsites.net/api', 
    useMockData: false 
  }, 
  if (window.location.hostname === 'localhost') return 'development'; 
  if (window.location.hostname.includes('github.io')) return 'github_pages'; 
  return 'production'; 
}; 
 
export const config = API_CONFIG[getEnvironment()]; 
export const useMockData = config.useMockData; 
