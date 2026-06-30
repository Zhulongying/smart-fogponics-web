# ================================
# Smart Fogponics One-Click Deploy
# ================================

Write-Host "🚀 开始一键部署 Flutter Web..." -ForegroundColor Green

# 1. 生成版本号（防缓存核心）
$version = Get-Date -Format "yyyyMMdd_HHmm"
Write-Host "📦 当前版本: $version" -ForegroundColor Cyan

# 2. 清理旧构建
Write-Host "🧹 清理旧 build..." -ForegroundColor Yellow
flutter clean

# 3. 获取依赖
Write-Host "📦 获取依赖..." -ForegroundColor Yellow
flutter pub get

# 4. 构建 Web
Write-Host "🌐 构建 Web..." -ForegroundColor Yellow
flutter build web

# 5. Git 操作
Write-Host "📤 提交代码..." -ForegroundColor Yellow
git add .

git commit -m "deploy: $version"

Write-Host "🚀 推送到 GitHub..." -ForegroundColor Yellow
git push

# 6. 输出访问地址
Write-Host ""
Write-Host "✅ 部署完成！" -ForegroundColor Green
Write-Host "🌍 访问地址：" -ForegroundColor Cyan
Write-Host "https://zhulongying.github.io/smart-fogponics-web/?v=$version" -ForegroundColor Magenta