# Auto Flutter Installation Script
$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Flutter Auto Installation Starting..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if already installed
if (Test-Path "C:\flutter\bin\flutter.bat") {
    Write-Host "Flutter already installed at C:\flutter!" -ForegroundColor Green
    C:\flutter\bin\flutter.bat --version
} else {
    Write-Host "Step 1/4: Downloading Flutter SDK (~1GB)..." -ForegroundColor Yellow
    Write-Host "This will take 5-10 minutes depending on your connection..." -ForegroundColor Gray

    $zipPath = "$env:TEMP\flutter_sdk.zip"
    $url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip"

    try {
        Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
        Write-Host "Download complete!" -ForegroundColor Green
    } catch {
        Write-Host "Download failed: $_" -ForegroundColor Red
        Write-Host "Please check your internet connection." -ForegroundColor Yellow
        exit 1
    }

    Write-Host ""
    Write-Host "Step 2/4: Extracting Flutter SDK to C:\flutter..." -ForegroundColor Yellow

    try {
        Expand-Archive -Path $zipPath -DestinationPath "C:\" -Force
        Write-Host "Extract complete!" -ForegroundColor Green
    } catch {
        Write-Host "Extract failed: $_" -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Write-Host "Step 3/4: Cleaning up..." -ForegroundColor Yellow
    Remove-Item $zipPath -Force
    Write-Host "Cleanup done!" -ForegroundColor Green

    Write-Host ""
    Write-Host "Flutter SDK installed successfully!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 4/4: Adding Flutter to PATH..." -ForegroundColor Yellow

$flutterBin = "C:\flutter\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($userPath -notlike "*$flutterBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$flutterBin", "User")
    $env:Path += ";$flutterBin"
    Write-Host "Flutter added to PATH!" -ForegroundColor Green
} else {
    Write-Host "Flutter already in PATH!" -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Verifying Flutter Installation..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

C:\flutter\bin\flutter.bat --version

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Installing Project Dependencies..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Set-Location -Path $PSScriptRoot
C:\flutter\bin\flutter.bat pub get

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Close and reopen VS Code" -ForegroundColor Yellow
Write-Host "  2. Open this project folder in VS Code" -ForegroundColor Yellow
Write-Host "  3. Press F5 to run the app" -ForegroundColor Yellow
Write-Host "  4. Select Chrome as device" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or run manually:" -ForegroundColor Cyan
Write-Host "  flutter run -d chrome" -ForegroundColor Yellow
Write-Host ""

Read-Host "Press Enter to exit"
