Write-Host "========================================" -ForegroundColor Green
Write-Host "ScanXcel v1.3 Web Build ve Docs Guncelleme" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "1. Flutter dependencies guncelleniyor..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "2. Localization dosyalari generate ediliyor..." -ForegroundColor Yellow
flutter gen-l10n

Write-Host ""
Write-Host "3. Flutter web build aliniyor (v1.3)..." -ForegroundColor Yellow
flutter build web --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "HATA: Web build basarisiz!" -ForegroundColor Red
    Read-Host "Devam etmek icin Enter'a basin"
    exit 1
}

Write-Host ""
Write-Host "4. Docs klasoru temizleniyor..." -ForegroundColor Yellow
if (Test-Path "docs") {
    Remove-Item -Recurse -Force "docs"
}

Write-Host ""
Write-Host "5. Yeni docs klasoru olusturuluyor..." -ForegroundColor Yellow
New-Item -ItemType Directory -Name "docs"

Write-Host ""
Write-Host "6. Build dosyalari docs klasorune kopyalaniyor..." -ForegroundColor Yellow
Copy-Item "build\web\*" "docs\" -Recurse -Force

Write-Host ""
Write-Host "7. Build tamamlandi - ScanXcel v1.3 hazir!" -ForegroundColor Yellow

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "TAMAMLANDI! ScanXcel v1.3 docs klasoru guncellendi." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Yeni ozellikler:" -ForegroundColor Cyan
Write-Host "- Gelismis error handling" -ForegroundColor White
Write-Host "- Performance optimizasyonu" -ForegroundColor White
Write-Host "- Responsive design iyilestirmeleri" -ForegroundColor White
Write-Host "- Modern UI/UX" -ForegroundColor White
Write-Host ""
Write-Host "Simdi GitHub'a push edebilirsiniz:" -ForegroundColor Cyan
Write-Host "git add docs/" -ForegroundColor White
Write-Host "git commit -m 'ScanXcel v1.3 web build - Advanced features'" -ForegroundColor White
Write-Host "git push origin main" -ForegroundColor White
Write-Host ""
Read-Host "Devam etmek icin Enter'a basin"
