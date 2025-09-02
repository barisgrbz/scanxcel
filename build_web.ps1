Write-Host "========================================" -ForegroundColor Green
Write-Host "ScanXcel Web Build ve Docs Guncelleme" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "1. Flutter web build aliniyor..." -ForegroundColor Yellow
flutter build web --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "HATA: Web build basarisiz!" -ForegroundColor Red
    Read-Host "Devam etmek icin Enter'a basin"
    exit 1
}

Write-Host ""
Write-Host "2. Docs klasoru temizleniyor..." -ForegroundColor Yellow
if (Test-Path "docs") {
    Remove-Item -Recurse -Force "docs"
}

Write-Host ""
Write-Host "3. Yeni docs klasoru olusturuluyor..." -ForegroundColor Yellow
New-Item -ItemType Directory -Name "docs"

Write-Host ""
Write-Host "4. Build dosyalari docs klasorune kopyalaniyor..." -ForegroundColor Yellow
Copy-Item "build\web\*" "docs\" -Recurse -Force

Write-Host ""
Write-Host "5. Base href guncelleniyor..." -ForegroundColor Yellow
$indexContent = Get-Content "docs\index.html" -Raw
$indexContent = $indexContent -replace 'base href="/"', 'base href="/scanxcel/"'
Set-Content "docs\index.html" $indexContent

Write-Host ""
Write-Host "6. Start URL guncelleniyor..." -ForegroundColor Yellow
$manifestContent = Get-Content "docs\manifest.json" -Raw
$manifestContent = $manifestContent -replace '"start_url": "."', '"start_url": "/scanxcel/"'
Set-Content "docs\manifest.json" $manifestContent

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "TAMAMLANDI! Docs klasoru guncellendi." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Simdi GitHub'a push edebilirsiniz:" -ForegroundColor Cyan
Write-Host "git add docs/" -ForegroundColor White
Write-Host "git commit -m 'Web build guncellendi'" -ForegroundColor White
Write-Host "git push origin main" -ForegroundColor White
Write-Host ""
Read-Host "Devam etmek icin Enter'a basin"
