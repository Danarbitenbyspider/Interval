@echo off
echo ============================================
echo Flutter Installation Script (Simple Version)
echo ============================================
echo.

REM Check if Flutter already installed
if exist "C:\flutter\bin\flutter.bat" (
    echo Flutter sudah terinstall!
    C:\flutter\bin\flutter.bat --version
    goto :install_deps
)

echo Flutter belum terinstall.
echo.
echo Untuk install Flutter, Anda punya 2 pilihan:
echo.
echo PILIHAN 1 - Download Manual (Recommended):
echo   1. Buka browser dan download:
echo      https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip
echo   2. Extract ZIP ke C:\flutter
echo   3. Jalankan script ini lagi
echo.
echo PILIHAN 2 - Auto Download (Lambat, ~1GB):
echo   Tekan tombol apapun untuk mulai download otomatis...
echo.
pause

echo.
echo Downloading Flutter SDK (~1GB)...
echo Ini akan memakan waktu 5-15 menit tergantung internet...
echo.

powershell -Command "Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip' -OutFile '%TEMP%\flutter.zip'"

if errorlevel 1 (
    echo.
    echo Download gagal! Silakan download manual.
    pause
    exit /b 1
)

echo.
echo Extracting Flutter SDK ke C:\...
powershell -Command "Expand-Archive -Path '%TEMP%\flutter.zip' -DestinationPath 'C:\' -Force"

if errorlevel 1 (
    echo.
    echo Extract gagal!
    pause
    exit /b 1
)

echo.
echo Cleaning up...
del "%TEMP%\flutter.zip"

echo.
echo Flutter berhasil terinstall!
echo.

:install_deps
echo ============================================
echo Installing Project Dependencies
echo ============================================
echo.

REM Add Flutter to PATH for current session
set PATH=%PATH%;C:\flutter\bin

REM Check Flutter
echo Checking Flutter installation...
flutter doctor -v

echo.
echo Installing project dependencies...
flutter pub get

if errorlevel 1 (
    echo.
    echo Dependencies install gagal!
    pause
    exit /b 1
)

echo.
echo ============================================
echo Installation Complete!
echo ============================================
echo.
echo Next steps:
echo   1. Restart Command Prompt/PowerShell
echo   2. Run: flutter run -d chrome
echo.
echo IMPORTANT: Tambahkan C:\flutter\bin ke PATH environment variable
echo untuk bisa run flutter dari mana saja.
echo.
pause
