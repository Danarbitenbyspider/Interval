# Deployment Guide - Intervals Training

Panduan lengkap untuk deploy aplikasi ke production.

## Prerequisites

- Flutter SDK >= 3.0.0 installed
- Android Studio (untuk Android)
- Xcode (untuk iOS, Mac only)
- Google Play Console account (untuk Android publish)
- Apple Developer account (untuk iOS publish)

## Pre-Deployment Checklist

### 1. Update Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

- **Version name**: 1.0.0 (semantic versioning)
- **Build number**: 1 (increment untuk setiap build baru)

### 2. Test Thoroughly

```bash
# Run all tests
flutter test

# Run tests dengan coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
flutter format .
```

### 3. Update Documentation

- [ ] Update CHANGELOG.md dengan perubahan versi terbaru
- [ ] Update README.md jika ada fitur baru
- [ ] Check semua screenshot up-to-date

### 4. Clean Build

```bash
flutter clean
flutter pub get
```

## Android Deployment

### Step 1: Configure App Signing

#### Generate Keystore (first time only)

```bash
# Windows
keytool -genkey -v -keystore %USERPROFILE%\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Mac/Linux
keytool -genkey -v -keystore ~/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Simpan password keystore dengan aman!**

#### Create key.properties

Buat file `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

⚠️ **JANGAN commit key.properties ke Git!**

Pastikan `android/key.properties` ada di `.gitignore`.

#### Update build.gradle

File `android/app/build.gradle` sudah dikonfigurasi untuk release build.

### Step 2: Build Release

#### APK (for testing)
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

**Recommended**: Gunakan App Bundle untuk Play Store (ukuran lebih kecil).

### Step 3: Test Release Build

Install APK ke device:
```bash
flutter install --release
```

Test checklist:
- [ ] Semua fitur berfungsi
- [ ] TTS bekerja
- [ ] Haptics bekerja
- [ ] Settings tersimpan
- [ ] Progress log tersimpan
- [ ] No crashes

### Step 4: Upload to Play Store

1. Login ke [Google Play Console](https://play.google.com/console)
2. Create new app (first time) atau pilih existing app
3. Fill in app details:
   - App name: **Intervals Training**
   - Short description
   - Full description
   - Screenshots (min 2)
   - Icon (512x512px)
4. Go to **Production** → **Create new release**
5. Upload `app-release.aab`
6. Fill in release notes
7. Review & rollout

#### Play Store Listing Info

**Title**: Intervals Training

**Short Description**:
```
Aplikasi interval training low-impact dengan 5 mode: Japanese Walking, Tabata, Mobility, Core, Breathing. Offline, mudah, zen.
```

**Full Description**:
```
Intervals Training adalah aplikasi interval training low-impact yang cocok untuk pemula hingga menengah.

🏃 5 MODE WORKOUT:
• Japanese Walking Interval - Jalan cepat/lambat bergantian
• Tabata Basic - 20 detik kerja / 10 detik istirahat
• Mobility Interval - Fleksibilitas & mobilitas
• Core Interval Training - Plank dengan tempo breathing
• Breathing Intervals - Box breathing untuk relaksasi

✨ FITUR:
• Offline-first - Tidak perlu internet
• Narasi TTS - Panduan suara Bahasa Indonesia & English
• Haptic feedback - Getaran saat transisi
• Metronom visual - Visualisasi untuk tiap mode
• Dark mode - Tema gelap nyaman di mata
• Progress tracking - Log sesi sederhana
• Accessibility - TTS, haptics, kontras tinggi

🎯 COCOK UNTUK:
• Pemula yang baru mulai interval training
• Yang prefer latihan low-impact
• Yang cari app sederhana tanpa ribet

💪 Selamat berlatih!
```

**Category**: Health & Fitness

**Tags**: interval training, workout, fitness, HIIT, breathing, mobility, core

## iOS Deployment

### Step 1: Configure App

Edit `ios/Runner/Info.plist` (sudah dikonfigurasi).

### Step 2: Configure Signing

1. Open `ios/Runner.xcworkspace` di Xcode
2. Select **Runner** target
3. Go to **Signing & Capabilities**
4. Select team
5. Enable **Automatically manage signing**

### Step 3: Build Release

```bash
flutter build ios --release
```

### Step 4: Archive & Upload

1. Open `ios/Runner.xcworkspace` di Xcode
2. Select **Any iOS Device (arm64)** dari device selector
3. Menu: **Product** → **Archive**
4. Wait for archive to complete
5. Window akan muncul dengan archives
6. Select archive → Click **Distribute App**
7. Pilih **App Store Connect**
8. Follow wizard

### Step 5: App Store Submission

1. Login ke [App Store Connect](https://appstoreconnect.apple.com/)
2. Go to **My Apps** → **Intervals Training**
3. Fill in app information:
   - Name: **Intervals Training**
   - Subtitle
   - Description
   - Keywords
   - Screenshots (required for all device sizes)
   - App icon
4. Go to **TestFlight** (optional, untuk beta testing)
5. Submit for review

#### App Store Description

**Subtitle**:
```
Low-impact interval training
```

**Description**:
```
Intervals Training is a low-impact interval training app suitable for beginners to intermediate users.

🏃 5 WORKOUT MODES:
• Japanese Walking Interval - Alternate fast/slow walk
• Tabata Basic - 20 seconds work / 10 seconds rest
• Mobility Interval - Flexibility & mobility
• Core Interval Training - Plank with breathing tempo
• Breathing Intervals - Box breathing for relaxation

✨ FEATURES:
• Offline-first - No internet required
• TTS narration - Voice guidance in Indonesian & English
• Haptic feedback - Vibration on transitions
• Visual metronome - Unique visualization per mode
• Dark mode - Easy on the eyes
• Progress tracking - Simple session logs
• Accessibility - TTS, haptics, high contrast

🎯 PERFECT FOR:
• Beginners starting interval training
• Low-impact exercise enthusiasts
• Those seeking simple, no-fuss apps

💪 Happy training!
```

**Keywords**: interval, training, workout, fitness, HIIT, breathing, mobility, core, tabata

**Category**: Health & Fitness

## Post-Deployment

### Monitor

#### Android (Play Console)
- Check crash reports
- Monitor reviews
- Check ANR (App Not Responding) reports
- Monitor installation analytics

#### iOS (App Store Connect)
- Check crash reports
- Monitor reviews
- Check TestFlight feedback (if applicable)

### Respond to Reviews

- Balas review (terutama yang negatif)
- Fix bugs yang dilaporkan
- Consider feature requests

### Update Schedule

**Bug fixes**: As soon as possible
**Minor updates**: Monthly
**Major updates**: Quarterly

## Versioning Strategy

Menggunakan **Semantic Versioning** (MAJOR.MINOR.PATCH):

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes, redesign
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes

**Build number**: Increment untuk setiap build (termasuk beta/internal).

### Example Timeline

```
1.0.0+1   - Initial release
1.0.1+2   - Bug fix (TTS issue)
1.0.2+3   - Bug fix (haptics on some devices)
1.1.0+4   - New feature (custom workout builder)
1.1.1+5   - Bug fix
2.0.0+6   - Major redesign
```

## Release Checklist

### Pre-Release
- [ ] All tests passing
- [ ] Code analyzed (no errors)
- [ ] Version bumped
- [ ] CHANGELOG updated
- [ ] Screenshots updated
- [ ] Test on physical devices (Android & iOS)

### Release
- [ ] Build release APK/AAB
- [ ] Test release build
- [ ] Upload to Play Store
- [ ] Build iOS archive
- [ ] Upload to App Store Connect
- [ ] Submit for review

### Post-Release
- [ ] Monitor crash reports
- [ ] Monitor reviews
- [ ] Respond to feedback
- [ ] Plan next update

## Troubleshooting

### Android: "Upload failed: APK signature invalid"

**Solution**: Pastikan keystore dan key.properties sudah benar.

### iOS: "Provisioning profile doesn't include signing certificate"

**Solution**:
1. Xcode → Preferences → Accounts → Download Manual Profiles
2. Atau hapus derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Both: "Version code already used"

**Solution**: Increment build number di `pubspec.yaml`.

### Play Store: "App Bundle contains native code, but you haven't uploaded debug symbols"

**Solution**: Upload debug symbols (optional, untuk crash reporting lebih baik).

## Resources

- [Flutter Deployment Docs](https://docs.flutter.dev/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [iOS Code Signing](https://developer.apple.com/support/code-signing/)

---

**Good luck with your deployment! 🚀**
