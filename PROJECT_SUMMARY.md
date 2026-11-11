# Project Summary - Intervals Training

## 📋 Overview

**Intervals Training** adalah aplikasi Flutter untuk interval training low-impact dengan fokus pada:
- Kemudahan penggunaan (one-handed operation)
- Offline-first
- Accessibility (TTS, haptics, dark mode)
- Zen/minimal UI

## 🎯 Target User

- **Pemula**: Yang baru mulai fitness/interval training
- **Menengah**: Yang ingin latihan terstruktur tanpa ribet
- **Low-impact enthusiasts**: Yang prefer latihan ringan-sedang

## 🏗️ Arsitektur Aplikasi

### Tech Stack
```
Flutter 3.0+
├── State Management: Riverpod
├── Storage: SharedPreferences
├── TTS: flutter_tts
├── Haptics: vibration
├── i18n: Custom JSON loader
└── Testing: flutter_test + mockito
```

### Layer Architecture
```
Presentation Layer (UI)
    ↓
Provider Layer (Riverpod)
    ↓
Business Logic Layer (Engine, Repo)
    ↓
Data Layer (Models, JSON)
```

## 📁 Struktur Proyek

```
intervals_training/
│
├── lib/
│   ├── main.dart                      # Entry point
│   ├── app.dart                       # App setup & theme
│   │
│   ├── core/                          # Core functionality
│   │   ├── models/                    # Data models
│   │   │   ├── interval_type.dart
│   │   │   ├── interval_segment.dart
│   │   │   ├── workout_plan.dart
│   │   │   └── session_log.dart
│   │   │
│   │   ├── engine/
│   │   │   └── interval_engine.dart   # Timer engine (jantung app)
│   │   │
│   │   ├── repo/
│   │   │   └── workout_repository.dart # Load & parse JSON
│   │   │
│   │   ├── providers/                 # Riverpod providers
│   │   │   ├── workout_provider.dart
│   │   │   ├── session_provider.dart
│   │   │   ├── settings_provider.dart
│   │   │   └── progress_provider.dart
│   │   │
│   │   └── localization/
│   │       └── app_localizations.dart # i18n system
│   │
│   └── features/                      # Feature modules
│       ├── home/
│       │   └── home_page.dart
│       ├── detail/
│       │   └── mode_detail_page.dart
│       ├── timer/
│       │   ├── timer_page.dart
│       │   └── widgets/
│       │       └── metronome_visual.dart
│       ├── settings/
│       │   └── settings_page.dart
│       └── progress/
│           └── progress_page.dart
│
├── assets/
│   ├── workouts.json                  # Workout definitions
│   └── i18n/
│       ├── id.json                    # Bahasa Indonesia
│       └── en.json                    # English
│
├── test/                              # Unit tests
│   └── core/
│       ├── models/
│       ├── engine/
│       └── repo/
│
├── android/                           # Android-specific
├── ios/                               # iOS-specific
│
├── pubspec.yaml                       # Dependencies
├── analysis_options.yaml              # Linter rules
├── README.md                          # Main documentation
├── QUICKSTART.md                      # Quick start guide
├── CHANGELOG.md                       # Version history
├── CONTRIBUTING.md                    # Contribution guide
└── LICENSE                            # MIT License
```

## 🔄 Data Flow

### 1. Startup Flow
```
main()
  → ProviderScope
    → IntervalsTrainingApp
      → Load Settings (SharedPreferences)
        → Apply Theme & Language
          → HomePage (Load workouts.json)
```

### 2. Workout Flow
```
User selects mode (HomePage)
  → ModeDetailPage (select level, options)
    → User taps "Start"
      → TimerPage
        → IntervalEngine.startSession()
          → Countdown 3-2-1
            → Timer starts (1-sec ticker)
              → Update UI + TTS + Haptics
                → Segment transitions
                  → Workout complete
                    → Save SessionLog
                      → Back to HomePage
```

### 3. Settings Flow
```
SettingsPage
  → User changes setting
    → SettingsNotifier.updateSetting()
      → Save to SharedPreferences
        → Notify listeners
          → UI updates automatically
```

## 🧩 Key Components

### IntervalEngine
**Location**: [lib/core/engine/interval_engine.dart](lib/core/engine/interval_engine.dart)

**Tanggung jawab**:
- Manage timer dengan 1-detik ticker
- Handle pause/resume
- Track progress (segment, repeat, elapsed time)
- Emit events untuk TTS & haptics
- Akurat meski app masuk background (DateTime delta)

**Key Methods**:
- `startSession()`: Mulai workout dengan countdown
- `pause()` / `resume()`: Control playback
- `nextSegment()` / `previousSegment()`: Manual navigation
- `stop()`: Hentikan dan reset

### WorkoutRepository
**Location**: [lib/core/repo/workout_repository.dart](lib/core/repo/workout_repository.dart)

**Tanggung jawab**:
- Load `workouts.json` dari assets
- Parse JSON → WorkoutPlan objects
- Cache untuk performa
- Query by ID atau mode

### MetronomeVisual
**Location**: [lib/features/timer/widgets/metronome_visual.dart](lib/features/timer/widgets/metronome_visual.dart)

**Tanggung jawab**:
- Visualisasi berbeda per tipe segmen:
  - **Breathing**: Circle membesar/mengecil
  - **Tempo**: Dots berpindah sesuai beat
  - **Default**: Pulsing circle
- Update setiap detik

## 🎨 UI/UX Design Principles

### Zen/Minimal
- Clean layout, banyak whitespace
- Fokus pada info penting (timer, segment)
- Tidak ada distraction (ads, popup)

### Accessibility
- ✅ WCAG AA contrast
- ✅ Dynamic text sizing
- ✅ Large touch targets (min 48dp)
- ✅ TTS untuk visual impairment
- ✅ Haptics untuk hearing impairment

### One-handed Operation
- Bottom controls (thumb-friendly)
- Minimal scrolling
- Large buttons (48dp+)

## 📊 5 Workout Modes

| Mode | Durasi | Target | Fitur Khusus |
|------|--------|--------|--------------|
| Japanese Walking | ~19 min | Cardio ringan | BPM cues |
| Tabata Basic | ~5 min | HIIT singkat | 20s/10s classic |
| Mobility | ~13 min | Fleksibilitas | 45s/15s flow |
| Core Training | 6 min | Core strength | Tempo 2-1-2-1 |
| Breathing | 8 min | Relaksasi | Box 4-4-4-4 visual |

## 🔧 Kustomisasi

### Menambah Workout Baru
Edit [assets/workouts.json](assets/workouts.json):
```json
{
  "id": "new_workout",
  "title": "New Workout",
  "mode": "custom",
  "segments": [...],
  "repeat": 3
}
```

### Menambah Bahasa
1. Buat `assets/i18n/[lang].json`
2. Tambahkan locale di [lib/app.dart](lib/app.dart)
3. Update [lib/core/localization/app_localizations.dart](lib/core/localization/app_localizations.dart)

## 🧪 Testing Strategy

### Unit Tests
- ✅ WorkoutPlan parsing
- ✅ IntervalEngine transitions
- ✅ Progress calculation
- ✅ WorkoutRepository loading

### Widget Tests
- Timer display
- Navigation flow

### Integration Tests
- End-to-end workout flow

## 📈 Performance Considerations

### Optimizations
- ✅ Workout JSON cached setelah pertama kali load
- ✅ Settings di-lazy load dari SharedPreferences
- ✅ Timer akurat dengan DateTime delta (bukan hanya ticker count)
- ✅ TTS loop throttled (tiap ~12 detik, bukan tiap detik)

### Bundle Size
- Target: < 20 MB (Android APK)
- No heavy dependencies (no video, no ML, no maps)

## 🔐 Privacy & Data

### Data yang Disimpan Lokal
- Settings (bahasa, tema, volume, dll)
- Session logs (workout history)

### Data yang TIDAK Disimpan
- ❌ Personal info (nama, email, dll)
- ❌ Location
- ❌ Analytics/tracking

### Offline-First
- Semua fitur bekerja tanpa internet
- No cloud sync (by design)

## 🚀 Deployment

### Android
```bash
flutter build apk --release        # APK
flutter build appbundle --release  # AAB (for Play Store)
```

### iOS
```bash
flutter build ios --release
# Then archive in Xcode
```

## 🐛 Known Limitations

1. **TTS Language**: Tergantung device TTS engine
   - Android: Perlu Google TTS
   - iOS: Built-in, tapi terbatas

2. **Haptics**: Tidak bekerja di emulator

3. **Background Timer**:
   - Android: Butuh WAKE_LOCK permission
   - iOS: Butuh Background Audio mode

4. **Custom Workouts**: Belum ada UI builder (harus edit JSON manual)

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design 3](https://m3.material.io/)
- [WCAG Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## 🎓 Learning Points

Project ini cocok untuk belajar:
- ✅ Riverpod state management
- ✅ Custom timer/engine implementation
- ✅ TTS & haptics integration
- ✅ JSON parsing & repository pattern
- ✅ i18n/l10n
- ✅ Material Design 3
- ✅ Accessibility best practices
- ✅ Unit testing

## 🔮 Future Roadmap

### v1.1 (Planned)
- [ ] Custom workout builder UI
- [ ] More workout modes (Pilates, Yoga flows)
- [ ] Export logs to CSV/JSON

### v1.2 (Ideas)
- [ ] Workout reminders
- [ ] Statistics/charts
- [ ] Audio beeps (alternative to TTS)

### v2.0 (Maybe)
- [ ] Wearable integration (watch app)
- [ ] Cloud backup (optional)
- [ ] Social features (share workouts)

---

**Dibuat dengan ❤️ menggunakan Flutter & Claude Code**
