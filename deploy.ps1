Write-Host "=============================="
Write-Host "Smart Fogponics Deploy Start"
Write-Host "=============================="

# version
$version = Get-Date -Format "yyyyMMdd_HHmm"
Write-Host "Version: $version"

# clean
flutter clean

# get deps
flutter pub get

# build web
flutter build web

# git add
git add .

# commit
git commit -m "deploy $version"

# push
git push

# url
$url = "https://zhulongying.github.io/smart-fogponics-web/?v=$version"

Write-Host "Deploy Success"
Write-Host $url