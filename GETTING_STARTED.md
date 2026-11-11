# 🚀 Getting Started - Intervals Training

Selamat datang! Panduan ini akan membantu Anda menjalankan aplikasi dalam 5 menit.

## ⚡ Quick Start (TL;DR)

```bash
# 1. Install Flutter & Dependencies (otomatis)
powershell -ExecutionPolicy Bypass -File install_flutter.ps1

# 2. Run aplikasi
flutter run -d chrome
```

Selesai! 🎉

---

## 📋 Panduan Lengkap Step-by-Step

### Step 1: Install Flutter & Dependencies

**Option A: Otomatis (Recommended)**

Buka PowerShell dan jalankan:

```powershell
cd "d:\Project Ongoing\Claude Project\Interval apps"
powershell -ExecutionPolicy Bypass -File install_flutter.ps1
```

Script ini akan:
- ✅ Download Flutter SDK (~1GB)
- ✅ Install ke `C:\flutter`
- ✅ Tambahkan ke PATH
- ✅ Install project dependencies

⏱️ **Waktu**: 5-10 menit (tergantung internet)

**Option B: Manual**

Lihat panduan lengkap di [INSTALL.md](INSTALL.md)

### Step 2: Verify Installation

```bash
flutter --version
flutter doctor
```

Output yang diharapkan:
```
Flutter 3.19.6 • channel stable
Dart 3.3.4
✓ Chrome - develop for the web
```

### Step 3: Run Aplikasi

**Quick run (Chrome):**
```bash
flutter run -d chrome
```

Chrome akan terbuka otomatis dengan aplikasi! 🎉

**Pilih device lain:**
```bash
# Lihat available devices
flutter devices

# Run di device pilihan
flutter run -d windows     # Windows desktop
flutter run -d edge        # Edge browser
```

### Step 4: Explore Aplikasi

Di aplikasi:

1. **Home Screen**: Pilih salah satu dari 5 workout modes
2. **Detail Screen**: Pilih level (Beginner/Intermediate/Advanced)
3. **Timer Screen**: Lihat countdown, metronome visual, dan kontrol
4. **Settings**: Ubah bahasa, tema, TTS, haptics
5. **Progress**: Lihat riwayat sesi workout

---

## 🎯 5 Workout Modes

| Mode | Durasi | Cocok Untuk |
|------|--------|-------------|
| 🚶 Japanese Walking | ~19 min | Cardio ringan, pemula |
| 🏋️ Tabata Basic | ~5 min | HIIT singkat |
| 🧘 Mobility | ~13 min | Fleksibilitas |
| 💪 Core Training | 6 min | Core strength |
| 🧘‍♀️ Breathing | 8 min | Relaksasi, stress relief |

---

## 🛠️ Development

### Run Tests

```bash
flutter test
```

### Hot Reload

Saat app sedang running, edit code dan:
- Tekan `r` di terminal untuk hot reload
- Tekan `R` untuk hot restart
- Tekan `q` untuk quit

### Format & Analyze

```bash
# Format code
flutter format .

# Analyze code
flutter analyze
```

### Build Release

```bash
# Android APK
flutter build apk --release

# Windows EXE
flutter build windows --release

# Web
flutter build web --release
```

---

## 📚 Documentation

| Dokumen | Deskripsi |
|---------|-----------|
| [INSTALL.md](INSTALL.md) | Panduan install lengkap |
| [QUICKSTART.md](QUICKSTART.md) | Panduan penggunaan app |
| [API_REFERENCE.md](API_REFERENCE.md) | Dokumentasi API developer |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Diagram arsitektur |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Deploy ke Play Store/App Store |

Lihat [INDEX.md](INDEX.md) untuk navigasi lengkap.

---

## 🎨 Customize

### Tambah Workout Baru

Edit [assets/workouts.json](assets/workouts.json):

```json
{
  "id": "custom_workout",
  "title": "Custom Workout",
  "description": "Deskripsi workout",
  "mode": "custom",
  "segments": [
    {
      "type": "work",
      "label": "Kerja",
      "seconds": 30,
      "cues": {
        "tts_start": "Mulai kerja!"
      }
    }
  ],
  "repeat": 3
}
```

Hot reload app (`r`) dan workout baru akan muncul!

### Ubah Bahasa

Edit [assets/i18n/id.json](assets/i18n/id.json) atau [assets/i18n/en.json](assets/i18n/en.json):

```json
{
  "custom_key": "Teks custom"
}
```

### Ubah Tema

Edit [lib/app.dart](lib/app.dart):

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.purple, // Ubah warna utama
),
```

---

## 🐛 Troubleshooting

### "flutter: command not found"

**Solution:**
```bash
# Restart PowerShell/Terminal
# Atau tambahkan manual ke PATH:
$env:Path += ";C:\flutter\bin"
```

### App tidak bisa build

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### TTS tidak berbunyi

- ✅ Check Settings → Voice Cues = ON
- ✅ Check volume device
- ✅ Android: Install Google TTS dari Play Store

### Haptics tidak bekerja

- Haptics tidak bekerja di emulator/browser
- Test di device fisik (Android/iOS)

### Lainnya

Lihat [INSTALL.md](INSTALL.md) section Troubleshooting.

---

## 📞 Need Help?

- 📖 **Full Documentation**: [README.md](README.md)
- 🐛 **Found a Bug**: Create issue dengan detail error
- 💡 **Feature Request**: Diskusikan di forum
- 🤝 **Contribute**: Lihat [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 🎉 Next Steps

Setelah app berjalan:

1. ✅ Coba semua 5 workout modes
2. ✅ Test TTS & haptics
3. ✅ Explore Settings & Progress
4. ✅ Read [QUICKSTART.md](QUICKSTART.md) untuk tips
5. ✅ Customize workout di [assets/workouts.json](assets/workouts.json)
6. ✅ Build release: [DEPLOYMENT.md](DEPLOYMENT.md)

---

## ⭐ Features Checklist

Aplikasi ini includes:

- ✅ 5 workout modes (Japanese Walking, Tabata, Mobility, Core, Breathing)
- ✅ TTS narration (Bahasa Indonesia & English)
- ✅ Haptic feedback
- ✅ Visual metronome (3 styles)
- ✅ Dark/Light mode
- ✅ Progress tracking
- ✅ Accessibility features
- ✅ Offline-first
- ✅ No ads, no tracking
- ✅ Open source (MIT License)

---

**Happy training! 💪🎉**

*Aplikasi dibuat dengan Flutter & Riverpod*
*Dokumentasi oleh Claude Code*
