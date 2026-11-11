# Installation Guide - Intervals Training

Panduan lengkap untuk install Flutter dan dependencies.

## 🎯 Quick Install (Windows)

### Option 1: Otomatis dengan PowerShell Script

1. Buka **PowerShell** sebagai Administrator
2. Jalankan:

```powershell
cd "d:\Project Ongoing\Claude Project\Interval apps"
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install_flutter.ps1
```

Script ini akan:
- ✅ Download Flutter SDK (jika belum ada)
- ✅ Extract ke `C:\flutter`
- ✅ Tambahkan Flutter ke PATH
- ✅ Run `flutter doctor`
- ✅ Install project dependencies (`flutter pub get`)

### Option 2: Manual Install

#### Step 1: Install Flutter SDK

**Download Flutter:**
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip
```

**Extract:**
- Extract ZIP ke `C:\flutter` (atau lokasi lain)

**Tambah ke PATH:**
1. Tekan `Win + R`, ketik `sysdm.cpl`, Enter
2. Tab **Advanced** → **Environment Variables**
3. Di **User variables**, pilih **Path**, klik **Edit**
4. Klik **New**, tambahkan: `C:\flutter\bin`
5. Klik **OK** semua

**Restart Terminal/PowerShell**

#### Step 2: Verify Flutter

Buka terminal baru:
```bash
flutter --version
flutter doctor
```

**Flutter doctor mungkin menunjukkan warning:**
- ⚠️ Android toolchain - **Optional** (hanya jika ingin run di Android)
- ⚠️ Xcode - **N/A** (hanya di Mac untuk iOS)
- ⚠️ Visual Studio - **Optional** (hanya jika ingin run di Windows desktop)
- ✅ Chrome - **Recommended** untuk testing cepat!

#### Step 3: Install Project Dependencies

```bash
cd "d:\Project Ongoing\Claude Project\Interval apps"
flutter pub get
```

Output yang diharapkan:
```
Running "flutter pub get" in Interval apps...
Resolving dependencies...
+ flutter_riverpod 2.5.1
+ flutter_tts 4.0.2
+ shared_preferences 2.2.3
+ vibration 1.8.4
+ equatable 2.0.5
+ intl 0.19.0
...
Got dependencies!
```

## 🚀 Run Aplikasi

### Quick Run (Chrome - Tercepat)

```bash
flutter run -d chrome
```

Chrome akan terbuka otomatis dengan aplikasi.

### Run di Platform Lain

**Lihat available devices:**
```bash
flutter devices
```

**Run di device tertentu:**
```bash
# Windows Desktop
flutter run -d windows

# Android Emulator (jika sudah setup)
flutter run -d emulator-5554

# Edge browser
flutter run -d edge
```

## 🔧 Setup Platform-Specific (Optional)

### Android

**Requirements:**
- Android Studio
- Android SDK
- Android Emulator atau device fisik

**Install:**
1. Download [Android Studio](https://developer.android.com/studio)
2. Install dengan default settings
3. Buka Android Studio → **More Actions** → **SDK Manager**
4. Install:
   - Android SDK Platform (API 33+)
   - Android SDK Build-Tools
   - Android Emulator
5. Create virtual device: **Tools** → **AVD Manager**

**Verify:**
```bash
flutter doctor --android-licenses
flutter doctor
```

### iOS (Mac Only)

**Requirements:**
- Xcode (Mac App Store)
- CocoaPods

**Install:**
```bash
# Install Xcode dari App Store
# Install CocoaPods
sudo gem install cocoapods

# Verify
flutter doctor
```

### Windows Desktop

**Requirements:**
- Visual Studio 2022 with "Desktop development with C++"

**Install:**
1. Download [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/)
2. Pilih **Desktop development with C++** workload
3. Install

**Enable Windows support:**
```bash
flutter config --enable-windows-desktop
```

**Verify:**
```bash
flutter doctor
```

## 🧪 Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/engine/interval_engine_test.dart
```

## 🐛 Troubleshooting

### "flutter: command not found"

**Solution:**
1. Pastikan Flutter sudah di PATH
2. Restart terminal/PowerShell
3. Verify: `echo $env:PATH` (PowerShell) atau `echo %PATH%` (CMD)

### "Unable to locate Android SDK"

**Solution:**
```bash
flutter config --android-sdk "C:\Users\YOUR_USERNAME\AppData\Local\Android\Sdk"
```

### "CocoaPods not installed"

**Solution (Mac):**
```bash
sudo gem install cocoapods
```

### Gradle build failed (Android)

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### "Waiting for another flutter command to release the startup lock"

**Solution:**
```bash
# Hapus lock file
rm <flutter-sdk-path>/bin/cache/lockfile
```

Atau di Windows:
```powershell
Remove-Item "C:\flutter\bin\cache\lockfile" -Force
```

## 📦 Dependencies yang Akan Terinstall

Dari [pubspec.yaml](pubspec.yaml):

**Production:**
- `flutter_riverpod: ^2.5.1` - State management
- `shared_preferences: ^2.2.3` - Local storage
- `flutter_tts: ^4.0.2` - Text-to-Speech
- `vibration: ^1.8.4` - Haptic feedback
- `intl: ^0.19.0` - Internationalization
- `equatable: ^2.0.5` - Value equality

**Development:**
- `flutter_test` - Testing framework
- `flutter_lints: ^3.0.0` - Linting rules
- `mockito: ^5.4.4` - Mocking for tests

**Total size:** ~50-100 MB (dependencies + cache)

## ✅ Verification Checklist

Setelah install, verify semua bekerja:

```bash
# 1. Flutter version
flutter --version

# 2. Doctor check
flutter doctor

# 3. Dependencies installed
cd "d:\Project Ongoing\Claude Project\Interval apps"
flutter pub get

# 4. Tests pass
flutter test

# 5. App runs
flutter run -d chrome
```

Expected output:
```
✅ Flutter 3.19.x • Dart 3.3.x
✅ All dependencies resolved
✅ All tests passed
✅ App running on Chrome
```

## 🎉 Next Steps

Setelah semua terinstall:

1. **Jalankan app**: `flutter run -d chrome`
2. **Baca Quick Start**: [QUICKSTART.md](QUICKSTART.md)
3. **Explore code**: Lihat [lib/](lib/) folder
4. **Customize workout**: Edit [assets/workouts.json](assets/workouts.json)

## 📞 Need Help?

- 📖 Flutter Docs: https://docs.flutter.dev/
- 🆘 Flutter Doctor: `flutter doctor -v`
- 💬 Flutter Community: https://flutter.dev/community

---

**Happy Coding! 🚀**
