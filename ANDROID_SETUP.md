# 📱 Setup Android untuk Intervals Training

Panduan lengkap untuk run aplikasi di Android.

## 🎯 Pilihan Platform

Anda punya 3 pilihan:

### ✅ **Option 1: Windows Desktop (TERCEPAT - Sudah Siap!)**

**Sudah tersetup dan langsung bisa dipakai!**

```bash
flutter run -d windows
```

App akan terbuka sebagai Windows desktop app. Semua fitur bekerja kecuali:
- ❌ Haptics (tidak ada getaran di PC)
- ✅ TTS bekerja
- ✅ Semua fitur lain bekerja

### 🌐 **Option 2: Web (Chrome/Edge - Sudah Jalan)**

**Yang saat ini sedang running:**

```bash
flutter run -d chrome
```

### 📱 **Option 3: Android (Perlu Setup)**

**Untuk test di Android device/emulator.**

---

## 📱 Setup Android (Lengkap)

### Step 1: Install Android Studio

1. **Download Android Studio**:
   ```
   https://developer.android.com/studio
   ```
   Size: ~1GB download

2. **Install Android Studio**:
   - Run installer
   - Pilih "Standard" installation
   - Wait for Android SDK download (~2-3 GB)
   - Klik "Finish"

### Step 2: Setup Android SDK

Android Studio akan otomatis install:
- ✅ Android SDK
- ✅ Android SDK Platform
- ✅ Android SDK Build-Tools
- ✅ Android Emulator

### Step 3: Accept Android Licenses

Buka terminal dan jalankan:

```bash
flutter doctor --android-licenses
```

Tekan `y` untuk semua license yang muncul.

### Step 4: Create Android Virtual Device (AVD)

Di Android Studio:

1. **Buka AVD Manager**:
   - Tools → Device Manager
   - Atau klik icon 📱 di toolbar

2. **Create Virtual Device**:
   - Klik "Create Device"
   - Pilih hardware: **Pixel 5** atau **Pixel 7** (recommended)
   - Klik "Next"

3. **Select System Image**:
   - Tab "Recommended"
   - Pilih **API 33** (Android 13) atau **API 34** (Android 14)
   - Klik "Download" jika belum ada (~1GB)
   - Klik "Next"

4. **Verify Configuration**:
   - AVD Name: biarkan default (contoh: "Pixel_5_API_33")
   - Klik "Finish"

### Step 5: Start Emulator

**Option A - Via Android Studio:**
- AVD Manager → Klik ▶️ (Play) di emulator yang sudah dibuat

**Option B - Via Flutter:**
```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

### Step 6: Run App di Android

Tunggu emulator fully booted (sampai muncul home screen), lalu:

```bash
cd "d:\Project Ongoing\Claude Project\Interval apps"
flutter run
```

Atau di VS Code:
- Tekan **F5**
- Pilih Android device dari dropdown

---

## 🚀 Alternative: Test di HP Android Fisik

Lebih cepat dari emulator!

### Step 1: Enable Developer Mode di HP

1. **Buka Settings** di HP Android
2. **About Phone** → Tap **Build Number** 7x
3. Developer Mode aktif!

### Step 2: Enable USB Debugging

1. **Settings** → **Developer Options**
2. Enable **USB Debugging**
3. Tap "OK" di popup

### Step 3: Connect HP ke PC

1. **Colok USB** HP ke PC
2. Di HP: Pilih **"File Transfer"** atau **"MTP"**
3. Popup "Allow USB debugging?" → Tap **OK**

### Step 4: Verify Device

Di PC terminal:

```bash
flutter devices
```

Anda akan lihat HP Anda muncul, contoh:
```
SM G991B (mobile) • 12345ABCD • android-arm64 • Android 13 (API 33)
```

### Step 5: Run!

```bash
flutter run
```

App akan otomatis install & run di HP Anda! 🎉

---

## ⚡ Quick Comparison

| Platform | Speed | Setup | TTS | Haptics | Recommended |
|----------|-------|-------|-----|---------|-------------|
| **Windows** | ⚡⚡⚡ Instant | ✅ Sudah | ✅ Yes | ❌ No | Testing cepat |
| **Chrome** | ⚡⚡⚡ Instant | ✅ Sudah | ✅ Yes | ❌ No | Demo |
| **Emulator** | ⚡ Slow | ⏰ 30 min | ✅ Yes | ⚠️ Limited | Development |
| **HP Fisik** | ⚡⚡⚡ Fast | ⏰ 5 min | ✅ Yes | ✅ Yes | **BEST!** |

---

## 🎯 Rekomendasi Saya

### Untuk Testing Cepat Sekarang:
```bash
flutter run -d windows
```
App jalan sebagai Windows desktop app. Semua fitur bekerja (kecuali haptics).

### Untuk Test di Mobile Sungguhan:
Gunakan **HP Android fisik** (lebih cepat dari emulator):
1. Enable USB Debugging (5 menit setup)
2. Colok USB
3. `flutter run`

### Jika Mau Emulator:
Install Android Studio (30-60 menit setup first time).

---

## 🔧 Troubleshooting

### "Unable to locate Android SDK"

Install Android Studio dari link di atas.

### Emulator lambat/lag

**Solusi:**
1. Enable **Hardware Acceleration**:
   - AVD Manager → Edit emulator
   - Advanced Settings → Enable "Hardware - GLES 2.0"

2. Atau gunakan HP fisik (jauh lebih cepat!)

### "device offline" saat connect HP

**Solusi:**
1. Cabut USB
2. Matikan USB Debugging
3. Nyalakan lagi USB Debugging
4. Colok USB lagi
5. Allow debugging

---

## 📊 Build APK untuk Install Manual

Jika mau install APK ke HP tanpa USB:

```bash
flutter build apk --release
```

APK ada di: `build\app\outputs\flutter-apk\app-release.apk`

Transfer ke HP via:
- Google Drive
- WhatsApp
- Bluetooth
- Email

Lalu install di HP (tap APK file).

---

## 💡 Tips

1. **Emulator pertama kali slow** - Tunggu 2-3 menit sampai fully booted
2. **HP fisik lebih cepat** - Untuk development, lebih baik pakai HP
3. **Hot reload bekerja** - Edit code, save, langsung update di device
4. **TTS & Haptics** - Hanya bekerja sempurna di Android device fisik

---

**Mau langsung test sekarang? Jalankan:**
```bash
flutter run -d windows
```

Atau tunggu setup Android Studio untuk emulator/HP fisik! 📱
