# Script untuk install Flutter SDK dan dependencies
# Run as Administrator atau dengan execution policy: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Write-Host "=== Flutter Installation Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter already installed
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterPath) {
    Write-Host "Flutter sudah terinstall di: $($flutterPath.Source)" -ForegroundColor Green
    flutter --version
} else {
    Write-Host "Flutter belum terinstall. Memulai download..." -ForegroundColor Yellow
    Write-Host ""

    # Create installation directory
    $installDir = "C:\flutter"
    if (-not (Test-Path $installDir)) {
        Write-Host "Membuat folder instalasi: $installDir" -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    # Download Flutter SDK (stable)
    $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip"
    $zipPath = "$env:TEMP\flutter_windows_stable.zip"

    Write-Host "Downloading Flutter SDK..." -ForegroundColor Cyan
    Write-Host "URL: $flutterUrl" -ForegroundColor Gray
    Write-Host "Ini akan memakan waktu beberapa menit tergantung koneksi internet Anda..." -ForegroundColor Yellow

    try {
        Invoke-WebRequest -Uri $flutterUrl -OutFile $zipPath -UseBasicParsing
        Write-Host "Download selesai!" -ForegroundColor Green

        # Extract ZIP
        Write-Host "Extracting Flutter SDK ke $installDir..." -ForegroundColor Cyan
        Expand-Archive -Path $zipPath -DestinationPath "C:\" -Force
        Write-Host "Extract selesai!" -ForegroundColor Green

        # Add to PATH
        $flutterBin = "C:\flutter\bin"
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($currentPath -notlike "*$flutterBin*") {
            Write-Host "Menambahkan Flutter ke PATH..." -ForegroundColor Cyan
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBin", "User")
            $env:Path += ";$flutterBin"
            Write-Host "Flutter berhasil ditambahkan ke PATH!" -ForegroundColor Green
        }

        # Clean up
        Remove-Item $zipPath -Force

        Write-Host ""
        Write-Host "Flutter berhasil terinstall!" -ForegroundColor Green
        Write-Host "Lokasi: C:\flutter" -ForegroundColor Cyan

    } catch {
        Write-Host "Error saat download/install Flutter: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Silakan download manual dari: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "=== Running Flutter Doctor ===" -ForegroundColor Cyan
flutter doctor

Write-Host ""
Write-Host "=== Installing Project Dependencies ===" -ForegroundColor Cyan
Set-Location -Path "$PSScriptRoot"

if (Test-Path "pubspec.yaml") {
    Write-Host "Running flutter pub get..." -ForegroundColor Cyan
    flutter pub get

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "Dependencies berhasil terinstall!" -ForegroundColor Green
        Write-Host ""
        Write-Host "=== Next Steps ===" -ForegroundColor Cyan
        Write-Host "1. Jalankan: flutter run -d chrome" -ForegroundColor Yellow
        Write-Host "2. Atau buka di VS Code dan tekan F5" -ForegroundColor Yellow
        Write-Host "3. Atau jalankan: flutter run (pilih device)" -ForegroundColor Yellow
    } else {
        Write-Host "Error saat install dependencies!" -ForegroundColor Red
    }
} else {
    Write-Host "Error: pubspec.yaml tidak ditemukan!" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Green
