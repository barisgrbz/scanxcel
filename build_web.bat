@echo off
echo ========================================
echo ScanXcel v1.3 Web Build ve Docs Guncelleme
echo ========================================

echo.
echo 1. Flutter dependencies guncelleniyor...
flutter pub get

echo.
echo 2. Localization dosyalari generate ediliyor...
flutter gen-l10n

echo.
echo 3. Flutter web build aliniyor (v1.3)...
flutter build web --release

if %errorlevel% neq 0 (
    echo HATA: Web build basarisiz!
    pause
    exit /b 1
)

echo.
echo 4. Docs klasoru temizleniyor...
if exist docs rmdir /s /q docs

echo.
echo 5. Yeni docs klasoru olusturuluyor...
mkdir docs

echo.
echo 6. Build dosyalari docs klasorune kopyalaniyor...
xcopy "build\web\*" "docs\" /E /I /H

echo.
echo 7. Build tamamlandi - ScanXcel v1.3 hazir!

echo.
echo ========================================
echo TAMAMLANDI! ScanXcel v1.3 docs klasoru guncellendi.
echo ========================================
echo.
echo Yeni ozellikler:
echo - Gelismis error handling
echo - Performance optimizasyonu
echo - Responsive design iyilestirmeleri
echo - Modern UI/UX
echo.
echo Simdi GitHub'a push edebilirsiniz:
echo git add docs/
echo git commit -m "ScanXcel v1.3 web build - Advanced features"
echo git push origin main
echo.
pause
