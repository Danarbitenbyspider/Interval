# Intervals Training

Aplikasi Flutter untuk interval training low-impact dengan 5 mode berbeda:
- **Japanese Walking Interval** - Jalan cepat/lambat bergantian
- **Tabata Basic** - 20 detik kerja / 10 detik istirahat
- **Mobility Interval** - 45 detik gerak / 15 detik transisi
- **Core Interval Training** - Plank & side plank dengan tempo
- **Breathing Intervals** - Box breathing 4-4-4-4

## Fitur

✅ **Offline-first** - Semua data disimpan lokal
✅ **Interval berbasis waktu** - Tidak ada hitungan repetisi
✅ **Narasi TTS** - Panduan suara opsional (Bahasa Indonesia & English)
✅ **Haptics** - Getaran saat transisi segmen
✅ **Metronom visual** - Visualisasi berbeda untuk setiap mode
✅ **Dark/Light mode** - Tema terang & gelap
✅ **Lokalisasi** - Bahasa Indonesia & English
✅ **Progress tracking** - Log sesi sederhana dengan RPE

## Arsitektur

- **State Management**: Riverpod
- **Lokalisasi**: JSON-based (id, en)
- **Storage**: SharedPreferences untuk settings & log
- **Timer Engine**: Custom interval engine dengan 1-detik ticker
- **TTS**: flutter_tts
- **Haptics**: vibration

## Struktur Proyek

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp setup
├── core/
│   ├── models/                        # Data models
│   │   ├── interval_type.dart
│   │   ├── interval_segment.dart
│   │   ├── workout_plan.dart
│   │   └── session_log.dart
│   ├── engine/
│   │   └── interval_engine.dart       # Timer logic
│   ├── repo/
│   │   └── workout_repository.dart    # Load JSON workouts
│   ├── providers/                     # Riverpod providers
│   │   ├── workout_provider.dart
│   │   ├── session_provider.dart
│   │   ├── settings_provider.dart
│   │   └── progress_provider.dart
│   └── localization/
│       └── app_localizations.dart     # i18n system
├── features/
│   ├── home/
│   │   └── home_page.dart             # Daftar 5 mode
│   ├── detail/
│   │   └── mode_detail_page.dart      # Detail & level selector
│   ├── timer/
│   │   ├── timer_page.dart            # Timer screen
│   │   └── widgets/
│   │       └── metronome_visual.dart  # Visual metronome
│   ├── settings/
│   │   └── settings_page.dart         # Pengaturan
│   └── progress/
│       └── progress_page.dart         # Log sesi

assets/
├── workouts.json                      # 5 workout plans
└── i18n/
    ├── id.json                        # Bahasa Indonesia
    └── en.json                        # English

test/                                  # Unit tests
```

## Setup & Build

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Install Dependencies

```bash
flutter pub get
```

### Run App

```bash
flutter run
```

### Build Release

**Android:**
```bash
flutter build apk --release
# atau
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

### Run Tests

```bash
flutter test
```

## Konfigurasi Izin

### Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permission untuk TTS (umumnya tidak perlu runtime permission) -->

    <!-- Permission untuk Vibration -->
    <uses-permission android:name="android.permission.VIBRATE" />

    <!-- Optional: WAKE_LOCK jika ingin timer tetap jalan saat layar terkunci -->
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <application ...>
        ...
    </application>
</manifest>
```

### iOS

Edit `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- TTS biasanya tidak perlu permission khusus -->

    <!-- Optional: Background Audio jika ingin TTS saat layar terkunci -->
    <key>UIBackgroundModes</key>
    <array>
        <string>audio</string>
    </array>

    <!-- Haptic sudah built-in iOS, tidak perlu permission -->

    ...
</dict>
```

## Kustomisasi Workout

Edit `assets/workouts.json` untuk menambah/ubah workout plan.

### Contoh Format:

```json
{
  "workouts": [
    {
      "id": "unique_id",
      "title": "Nama Workout",
      "description": "Deskripsi singkat",
      "mode": "nama_mode",
      "segments": [
        {
          "type": "work|recovery|warmup|cooldown|breath",
          "label": "Nama Segmen",
          "seconds": 30,
          "cues": {
            "tts_start": "Teks saat mulai",
            "tts_loop": ["Teks loop 1", "Teks loop 2"],
            "bpm": 100,
            "tempo": "2-1-2-1",
            "pattern": [4, 4, 4, 4],
            "labels": ["In", "Hold", "Out", "Hold"]
          }
        }
      ],
      "repeat": 3,
      "options": {
        "level": ["Beginner", "Intermediate", "Advanced"]
      }
    }
  ]
}
```

### Cues Options:

- **tts_start**: String TTS saat segmen dimulai
- **tts_loop**: Array string TTS yang di-loop tiap ~12 detik
- **bpm**: Metronom BPM (opsional)
- **tempo**: String tempo (contoh: "2-1-2-1" untuk breathing pattern)
- **pattern**: Array angka untuk breathing cycle (contoh: [4,4,4,4])
- **labels**: Array label untuk tiap fase breathing

## Troubleshooting

### TTS tidak berbunyi

1. Pastikan Voice Cues diaktifkan di Settings
2. Cek volume device tidak 0
3. Untuk Android, pastikan TTS engine terinstall (Google TTS)
4. Untuk iOS, TTS sudah built-in

### Haptics tidak bekerja

1. Cek Haptics diaktifkan di Settings
2. Device mungkin tidak support vibration (emulator)
3. Mode silent/vibrate di device

### App crash saat build

1. Jalankan `flutter clean`
2. Jalankan `flutter pub get`
3. Rebuild

### Error "Unable to load asset"

1. Pastikan file assets ada di folder `assets/`
2. Cek `pubspec.yaml` sudah mendaftarkan assets
3. Jalankan `flutter clean` dan rebuild

## Kontribusi

Aplikasi ini adalah template/starter. Silakan fork dan sesuaikan dengan kebutuhan Anda.

## Lisensi

MIT License - Bebas digunakan untuk proyek personal maupun komersial.

## Credits

Dibuat dengan ❤️ menggunakan Flutter & Claude Code
