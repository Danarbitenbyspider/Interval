# Quick Start Guide - Intervals Training

## 🚀 Cara Cepat Mulai

### 1. Install Dependencies

```bash
cd "Interval apps"
flutter pub get
```

### 2. Jalankan Aplikasi

```bash
flutter run
```

Pilih device (Android emulator, iOS simulator, atau Chrome untuk testing)

### 3. Testing

```bash
# Run semua tests
flutter test

# Run dengan coverage
flutter test --coverage
```

## 📱 Cara Menggunakan Aplikasi

### Home Screen
- Pilih salah satu dari 5 mode workout
- Lihat durasi estimasi untuk setiap mode
- Akses Settings (⚙️) atau Progress (📊) dari tombol di atas

### Mode Detail Screen
- Baca deskripsi workout
- Pilih level (Beginner/Intermediate/Advanced) jika tersedia
- Toggle Voice Cues dan Haptics sesuai preferensi
- Tekan **Mulai** untuk memulai workout

### Timer Screen
- Lihat countdown timer di tengah
- Metronom visual akan berubah sesuai tipe segmen:
  - **Breathing**: Circle yang membesar/mengecil
  - **Core/Tempo**: Dots yang berpindah mengikuti tempo
  - **Lainnya**: Pulsing circle
- Kontrol:
  - **⏸️ Pause/▶️ Resume**: Jeda/lanjutkan
  - **⏮️ Previous**: Segmen sebelumnya
  - **⏭️ Next**: Segmen berikutnya
  - **⏹️ Stop**: Berhenti (ada konfirmasi)
- Saat selesai: Log otomatis tersimpan

### Settings Screen
- **Bahasa**: Indonesia / English
- **Tema**: Light / Dark / System
- **Voice Cues**: ON/OFF + volume & kecepatan
- **Haptics**: ON/OFF untuk getaran
- **Countdown**: Hitung mundur 3-2-1 sebelum mulai (0-5 detik)

### Progress Screen
- Lihat riwayat semua sesi
- Swipe kiri untuk hapus sesi
- Lihat total sesi & durasi kumulatif
- Clear All untuk hapus semua riwayat

## 🎯 Mode Workout yang Tersedia

### 1. Japanese Walking Interval (3×3)
**Durasi**: ~19 menit
**Cocok untuk**: Pemula, cardio ringan
**Pattern**: 1 menit pemanasan + (3 menit fast walk + 3 menit recovery) × 3

### 2. Tabata Basic (4')
**Durasi**: ~5 menit
**Cocok untuk**: Semua level, HIIT singkat
**Pattern**: 1 menit pemanasan + (20 detik kerja + 10 detik istirahat) × 8

### 3. Mobility Interval (12')
**Durasi**: ~13 menit
**Cocok untuk**: Fleksibilitas, recovery
**Pattern**: 1 menit joint prep + (45 detik mobility + 15 detik transisi) × 8

### 4. Core Interval Training (10')
**Durasi**: 6 menit
**Cocok untuk**: Core strength
**Pattern**: (30s plank + 30s rest + 30s side plank L + 30s rest + 30s side plank R + 30s rest) × 2
**Fitur khusus**: Tempo 2-1-2-1 untuk breathing cue

### 5. Breathing Intervals (Box 4-4-4-4)
**Durasi**: 8 menit
**Cocok untuk**: Relaksasi, stress relief
**Pattern**: Box breathing (4 detik in - 4 detik hold - 4 detik out - 4 detik hold)
**Fitur khusus**: Circle visual yang membesar/mengecil

## 🔧 Kustomisasi

### Membuat Workout Baru

Edit [assets/workouts.json](assets/workouts.json) dan tambahkan workout baru:

```json
{
  "id": "custom_workout",
  "title": "Custom Workout",
  "description": "Deskripsi workout kamu",
  "mode": "custom",
  "segments": [
    {
      "type": "warmup",
      "label": "Pemanasan",
      "seconds": 60,
      "cues": {
        "tts_start": "Pemanasan dimulai"
      }
    },
    {
      "type": "work",
      "label": "Kerja Keras",
      "seconds": 30,
      "cues": {
        "tts_start": "Mulai kerja!",
        "tts_loop": ["Pertahankan!", "Terus!"]
      }
    }
  ],
  "repeat": 3
}
```

### Mengubah Lokalisasi

Edit file di [assets/i18n/](assets/i18n/):
- `id.json` untuk Bahasa Indonesia
- `en.json` untuk English

Tambahkan key-value baru dan gunakan di kode:
```dart
l10n.translate('custom_key')
```

## 🐛 Troubleshooting Umum

### Build Error: "Unable to load asset"
```bash
flutter clean
flutter pub get
flutter run
```

### TTS Tidak Berbunyi
1. Cek Settings → Voice Cues = ON
2. Cek volume device
3. Android: Install Google TTS dari Play Store
4. iOS: TTS sudah built-in

### Haptics Tidak Bekerja
1. Cek Settings → Haptics = ON
2. Tidak bekerja di emulator/simulator
3. Test di device fisik

### Gradle Build Error (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

## 📦 Build Release

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (untuk Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```
Kemudian buka Xcode untuk archive & distribute

## 💡 Tips

1. **Untuk pemula**: Mulai dari Japanese Walking atau Breathing Intervals
2. **HIIT singkat**: Tabata Basic (hanya 4 menit!)
3. **Recovery day**: Mobility Interval
4. **Core strength**: Core Interval Training dengan tempo breathing
5. **Stress relief**: Breathing Intervals sebelum tidur

## 🎨 Fitur Accessibility

- ✅ Dynamic Text Size (ikuti system font size)
- ✅ WCAG AA Contrast Ratio
- ✅ Dark Mode
- ✅ TTS untuk visual impairment
- ✅ Haptics untuk hearing impairment
- ✅ Large touch targets (minimum 48dp)

## 📄 Lisensi

MIT License - Bebas digunakan dan dimodifikasi.

---

**Selamat berlatih! 💪**
