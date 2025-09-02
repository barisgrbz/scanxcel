@echo off
echo ========================================
echo ScanXcel Web Build ve Docs Guncelleme
echo ========================================

echo.
echo 1. Flutter web build aliniyor...
flutter build web --release

if %errorlevel% neq 0 (
    echo HATA: Web build basarisiz!
    pause
    exit /b 1
)

echo.
echo 2. Docs klasoru temizleniyor...
if exist docs rmdir /s /q docs

echo.
echo 3. Yeni docs klasoru olusturuluyor...
mkdir docs

echo.
echo 4. Build dosyalari docs klasorune kopyalaniyor...
xcopy "build\web\*" "docs\" /E /I /H

echo.
echo 5. Build tamamlandi - Base href ve start_url otomatik ayarlandi

echo.
echo ========================================
echo TAMAMLANDI! Docs klasoru guncellendi.
echo ========================================
echo.
echo Simdi GitHub'a push edebilirsiniz:
echo git add docs/
echo git commit -m "Web build guncellendi"
echo git push origin main
echo.
pause
