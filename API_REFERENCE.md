# API Reference - Intervals Training

Dokumentasi untuk developer yang ingin mengembangkan atau memodifikasi aplikasi.

## Core Models

### IntervalType (Enum)

```dart
enum IntervalType {
  work,      // Segmen kerja/aktif
  recovery,  // Segmen istirahat/pemulihan
  warmup,    // Pemanasan
  cooldown,  // Pendinginan
  breath,    // Khusus breathing exercises
}
```

### IntervalSegment

Model untuk satu segmen interval.

```dart
class IntervalSegment {
  final IntervalType type;
  final String label;              // Label yang ditampilkan (contoh: "Fast Walk")
  final int seconds;               // Durasi dalam detik
  final Map<String, dynamic>? cues; // Cues untuk TTS/metronome
}
```

**Cues Properties**:
- `tts_start` (String): TTS saat segmen mulai
- `tts_loop` (List<String>): TTS yang di-loop tiap ~12 detik
- `bpm` (int): BPM untuk metronome (opsional)
- `tempo` (String): Tempo pattern, contoh "2-1-2-1"
- `pattern` (List<int>): Array untuk breathing pattern, contoh [4,4,4,4]
- `labels` (List<String>): Label untuk tiap fase breathing

**Methods**:
```dart
String? get ttsStart         // Helper untuk ambil tts_start
List<String>? get ttsLoop    // Helper untuk ambil tts_loop
int? get bpm                 // Helper untuk ambil BPM
List<int>? get breathPattern // Helper untuk ambil breathing pattern
List<String>? get breathLabels // Helper untuk ambil breathing labels
String? get tempo            // Helper untuk ambil tempo string
```

### WorkoutPlan

Model untuk workout plan lengkap.

```dart
class WorkoutPlan {
  final String id;                      // ID unik
  final String title;                   // Judul workout
  final String description;             // Deskripsi
  final String mode;                    // Mode (japanese_walking, tabata, dll)
  final List<IntervalSegment> segments; // Daftar segmen
  final int repeat;                     // Berapa kali repeat segments (default: 1)
  final Map<String, dynamic>? options;  // Options (level, dll)
}
```

**Methods**:
```dart
int get totalDurationSeconds       // Total durasi (segments × repeat)
List<String>? get availableLevels  // Level yang tersedia (dari options)
```

### SessionLog

Model untuk log sesi yang sudah selesai.

```dart
class SessionLog {
  final String workoutId;
  final String workoutTitle;
  final DateTime date;
  final int durationSeconds;
  final String? level;
  final int? rpe;              // Rate of Perceived Exertion (1-10)
  final String? notes;
}
```

## Core Engine

### IntervalEngine

Engine utama untuk manage timer workout.

**Location**: `lib/core/engine/interval_engine.dart`

```dart
class IntervalEngine extends ChangeNotifier {
  IntervalSessionState? get state;  // State session aktif

  // Methods
  Future<void> startSession(
    WorkoutPlan workout,
    {String? level, int countdownSeconds = 3}
  );
  void pause();
  void resume();
  void stop();
  void nextSegment();
  void previousSegment();
}
```

**Usage Example**:
```dart
final engine = ref.read(intervalEngineProvider);

// Start workout
await engine.startSession(
  workout,
  level: 'Beginner',
  countdownSeconds: 3,
);

// Listen to state changes
ref.listen(sessionStateProvider, (previous, next) {
  if (next?.isCompleted == true) {
    // Workout selesai
  }
});

// Control
engine.pause();
engine.resume();
engine.nextSegment();
engine.stop();
```

### IntervalSessionState

State dari session yang sedang berjalan.

```dart
class IntervalSessionState {
  final WorkoutPlan workout;
  final int currentRepeat;            // 0-based
  final int currentSegmentIndex;      // 0-based
  final int remainingSeconds;         // Sisa detik segmen aktif
  final bool isPaused;
  final bool isCompleted;
  final int totalElapsedSeconds;
  final String? level;

  // Getters
  IntervalSegment get currentSegment;
  bool get hasNextSegment;
  bool get hasPreviousSegment;
  double get progress;                // 0.0 - 1.0
}
```

## Providers (Riverpod)

### Workout Providers

```dart
// Repository
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {...});

// List semua workout
final workoutListProvider = FutureProvider<List<WorkoutPlan>>((ref) {...});

// Get workout by ID
final workoutByIdProvider = FutureProvider.family<WorkoutPlan?, String>((ref, id) {...});
```

**Usage**:
```dart
// Load all workouts
final workoutsAsync = ref.watch(workoutListProvider);
workoutsAsync.when(
  data: (workouts) => ...,
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);

// Get specific workout
final workoutAsync = ref.watch(workoutByIdProvider('jp_walk_3x3'));
```

### Session Providers

```dart
// Interval engine
final intervalEngineProvider = ChangeNotifierProvider<IntervalEngine>((ref) {...});

// Session state (nullable)
final sessionStateProvider = Provider<IntervalSessionState?>((ref) {...});

// Helper: has active session
final hasActiveSessionProvider = Provider<bool>((ref) {...});
```

**Usage**:
```dart
final engine = ref.read(intervalEngineProvider);
final state = ref.watch(sessionStateProvider);
final hasSession = ref.watch(hasActiveSessionProvider);

if (hasSession) {
  // Show timer screen
}
```

### Settings Providers

```dart
class AppSettings {
  final String language;              // 'id' | 'en'
  final ThemeMode themeMode;          // light | dark | system
  final bool voiceCuesEnabled;
  final bool hapticsEnabled;
  final double ttsVolume;             // 0.0 - 1.0
  final double ttsRate;               // 0.5 - 2.0
  final int countdownSeconds;         // 0 - 5
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {...});
```

**Usage**:
```dart
final settings = ref.watch(settingsProvider);

// Update settings
ref.read(settingsProvider.notifier).setLanguage('en');
ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
ref.read(settingsProvider.notifier).setVoiceCues(true);
ref.read(settingsProvider.notifier).setTtsVolume(0.8);
```

### Progress Providers

```dart
final progressProvider = StateNotifierProvider<ProgressNotifier, List<SessionLog>>((ref) {...});
```

**Methods**:
```dart
// Add log
await ref.read(progressProvider.notifier).addLog(sessionLog);

// Delete log
await ref.read(progressProvider.notifier).deleteLog(log);

// Clear all
await ref.read(progressProvider.notifier).clearAll();

// Get logs for specific workout
final logs = ref.read(progressProvider.notifier).getLogsForWorkout('jp_walk_3x3');
```

## Localization

### AppLocalizations

```dart
class AppLocalizations {
  final Locale locale;

  static AppLocalizations of(BuildContext context);
  String translate(String key);

  // Helper getters
  String get appTitle;
  String get start;
  String get pause;
  // ... dll
}
```

**Usage**:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.start);
Text(l10n.translate('custom_key'));
```

**Menambah string baru**:

1. Tambahkan di `assets/i18n/id.json`:
```json
{
  "custom_key": "Teks Indonesia"
}
```

2. Tambahkan di `assets/i18n/en.json`:
```json
{
  "custom_key": "English text"
}
```

3. (Opsional) Tambahkan helper getter di `AppLocalizations`:
```dart
String get customKey => translate('custom_key');
```

## Repository

### WorkoutRepository

```dart
class WorkoutRepository {
  Future<List<WorkoutPlan>> loadWorkouts();
  Future<WorkoutPlan?> getWorkoutById(String id);
  Future<List<WorkoutPlan>> getWorkoutsByMode(String mode);
  void clearCache();
}
```

**Usage**:
```dart
final repo = ref.read(workoutRepositoryProvider);

// Load all
final workouts = await repo.loadWorkouts();

// Get by ID
final workout = await repo.getWorkoutById('jp_walk_3x3');

// Get by mode
final tabataWorkouts = await repo.getWorkoutsByMode('tabata');

// Clear cache (force reload)
repo.clearCache();
```

## Widgets

### MetronomeVisual

Widget untuk visualisasi metronome.

```dart
class MetronomeVisual extends StatelessWidget {
  final IntervalSegment segment;
  final int remainingSeconds;
}
```

Secara otomatis memilih visualisasi berdasarkan tipe:
- **Breathing** (dengan breathPattern): Circle membesar/mengecil
- **Tempo** (dengan tempo string): Dots yang berpindah
- **Default**: Pulsing circle

**Usage**:
```dart
MetronomeVisual(
  segment: currentSegment,
  remainingSeconds: state.remainingSeconds,
)
```

## JSON Format

### workouts.json

```json
{
  "workouts": [
    {
      "id": "unique_id",
      "title": "Workout Title",
      "description": "Description",
      "mode": "mode_name",
      "segments": [
        {
          "type": "work|recovery|warmup|cooldown|breath",
          "label": "Segment Label",
          "seconds": 30,
          "cues": {
            "tts_start": "Start message",
            "tts_loop": ["Loop message 1", "Loop message 2"],
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

## Testing

### Unit Test Examples

**Test WorkoutPlan parsing**:
```dart
test('should parse from JSON correctly', () {
  final json = {...};
  final workout = WorkoutPlan.fromJson(json);

  expect(workout.id, 'test_workout');
  expect(workout.segments.length, 2);
});
```

**Test IntervalEngine**:
```dart
test('should initialize session state correctly', () async {
  await engine.startSession(testWorkout, countdownSeconds: 0);

  expect(engine.state, isNotNull);
  expect(engine.state!.currentRepeat, 0);
});
```

**Mock Repository**:
```dart
TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
  .setMockMessageHandler('flutter/assets', (message) async {
    // Return mock JSON
    return ByteData.sublistView(utf8.encode(jsonData));
  });
```

## Common Tasks

### Menambah Workout Baru

1. Edit `assets/workouts.json`
2. Tambahkan workout object baru
3. Hot reload app
4. Workout muncul di home page

### Menambah Mode Baru

1. Buat workout dengan `mode: "new_mode"`
2. (Opsional) Tambahkan icon khusus di `HomePage` (_WorkoutCard)
3. (Opsional) Tambahkan visualisasi khusus di `MetronomeVisual`

### Mengubah Countdown Duration Default

Edit `SettingsNotifier`:
```dart
state = const AppSettings(
  countdownSeconds: 5, // Ubah dari 3 ke 5
);
```

### Menambah TTS Language

1. Update `_initTts()` di `TimerPage`:
```dart
await _tts.setLanguage(
  settings.language == 'id' ? 'id-ID' :
  settings.language == 'es' ? 'es-ES' : 'en-US'
);
```

2. Tambahkan locale di `app.dart` supportedLocales

---

**Happy Coding! 🚀**
