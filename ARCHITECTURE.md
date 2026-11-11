# Architecture Documentation - Intervals Training

Dokumentasi arsitektur aplikasi dengan diagram dan penjelasan detail.

## 📐 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        User Interface                        │
│  (Material Design 3 • Dark/Light Mode • Accessibility)      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   Presentation Layer                         │
│                  (Flutter Widgets • Pages)                   │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │   Home   │  Detail  │  Timer   │ Settings │ Progress │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │ Listens to
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Provider Layer                            │
│                   (Riverpod Providers)                       │
│  ┌──────────┬──────────┬──────────┬──────────────────────┐  │
│  │ Workout  │ Session  │ Settings │ Progress             │  │
│  │ Provider │ Provider │ Provider │ Provider             │  │
│  └────┬─────┴─────┬────┴─────┬────┴────┬─────────────────┘  │
└───────┼───────────┼──────────┼─────────┼────────────────────┘
        │           │          │         │
        ▼           ▼          ▼         ▼
┌─────────────────────────────────────────────────────────────┐
│                  Business Logic Layer                        │
│  ┌──────────────┬─────────────────┬────────────────────┐   │
│  │   Workout    │ Interval Engine │  Settings Manager  │   │
│  │  Repository  │  (Timer Logic)  │   Progress Store   │   │
│  └──────┬───────┴────────┬────────┴────────┬───────────┘   │
└─────────┼────────────────┼─────────────────┼───────────────┘
          │                │                 │
          ▼                ▼                 ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  ┌──────────────────┬─────────────────┬──────────────────┐  │
│  │  workouts.json   │     Models      │ SharedPreferences│  │
│  │   (Assets)       │ (Dart Classes)  │   (Storage)      │  │
│  └──────────────────┴─────────────────┴──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
          │                                 │
          ▼                                 ▼
    [JSON Parser]                    [Local Storage]
```

## 🔄 Data Flow Diagram

### Flow 1: Load Workouts

```
App Start
    │
    ▼
HomePage Widget
    │
    ▼
workoutListProvider (FutureProvider)
    │
    ▼
WorkoutRepository.loadWorkouts()
    │
    ▼
rootBundle.loadString('assets/workouts.json')
    │
    ▼
JSON Parser (json.decode)
    │
    ▼
List<WorkoutPlan> (parsed)
    │
    ▼
Cache in memory
    │
    ▼
Return to Provider
    │
    ▼
UI Updates (HomePage shows workout cards)
```

### Flow 2: Start Workout

```
User taps workout card
    │
    ▼
Navigate to ModeDetailPage
    │
    ▼
User selects level & options
    │
    ▼
User taps "Start"
    │
    ▼
Navigate to TimerPage
    │
    ▼
TimerPage.initState()
    │
    ▼
IntervalEngine.startSession(workout, level, countdown)
    │
    ├─► Run countdown (3-2-1)
    │   ├─► Haptic vibration
    │   └─► TTS announcement
    │
    ▼
Start 1-second Timer (periodic)
    │
    ▼
Every 1 second:
    │
    ├─► Update remainingSeconds
    ├─► Check if segment complete
    │   └─► If yes: advance to next segment
    │       ├─► TTS announcement
    │       └─► Haptic vibration
    │
    ├─► Update totalElapsedSeconds
    ├─► Calculate progress (0.0-1.0)
    │
    ▼
notifyListeners()
    │
    ▼
sessionStateProvider emits new state
    │
    ▼
TimerPage rebuilds UI
    │
    ├─► Update countdown display
    ├─► Update progress bar
    ├─► Update MetronomeVisual
    └─► Update segment label
    │
    ▼
Workout complete?
    │
    ├─► No: continue timer
    │
    └─► Yes:
        ├─► Stop timer
        ├─► TTS "Workout complete!"
        ├─► Haptic vibration
        ├─► Save SessionLog to SharedPreferences
        └─► Show completion dialog
```

### Flow 3: Settings Update

```
User opens SettingsPage
    │
    ▼
settingsProvider emits current AppSettings
    │
    ▼
UI shows current values (switches, sliders)
    │
    ▼
User changes setting (e.g., toggle voice cues)
    │
    ▼
settingsProvider.notifier.setVoiceCues(value)
    │
    ▼
SettingsNotifier.state = state.copyWith(voiceCuesEnabled: value)
    │
    ▼
_saveSettings() to SharedPreferences
    │
    ├─► prefs.setBool('voiceCuesEnabled', value)
    │
    ▼
notifyListeners()
    │
    ▼
All listeners rebuild (if watching settingsProvider)
    │
    └─► TimerPage will respect new setting
```

## 🧩 Component Diagram

### Core Components

```
┌────────────────────────────────────────────────┐
│              IntervalEngine                    │
│  (ChangeNotifier)                              │
│                                                │
│  State:                                        │
│  • IntervalSessionState? _state                │
│  • Timer? _timer                               │
│  • DateTime? _lastTickTime                     │
│                                                │
│  Methods:                                      │
│  • startSession(workout, level, countdown)     │
│  • pause() / resume()                          │
│  • nextSegment() / previousSegment()           │
│  • stop()                                      │
│  • _onTick(Timer) - called every 1 second      │
│  • _advanceSegment() - transition logic        │
│                                                │
│  Emits:                                        │
│  • State changes via notifyListeners()         │
└────────────────────────────────────────────────┘
                      │
                      │ Used by
                      ▼
┌────────────────────────────────────────────────┐
│           intervalEngineProvider               │
│     (ChangeNotifierProvider<IntervalEngine>)   │
└────────────────────────────────────────────────┘
                      │
                      │ Watched by
                      ▼
┌────────────────────────────────────────────────┐
│              sessionStateProvider              │
│       (Provider<IntervalSessionState?>)        │
│                                                │
│  Returns: engine.state                         │
└────────────────────────────────────────────────┘
                      │
                      │ Watched by
                      ▼
              ┌──────────────┐
              │  TimerPage   │
              └──────────────┘
```

### Settings Flow

```
┌────────────────────────────────────────────────┐
│              AppSettings                       │
│  (Immutable Data Class)                        │
│                                                │
│  Fields:                                       │
│  • language: String                            │
│  • themeMode: ThemeMode                        │
│  • voiceCuesEnabled: bool                      │
│  • hapticsEnabled: bool                        │
│  • ttsVolume: double                           │
│  • ttsRate: double                             │
│  • countdownSeconds: int                       │
│                                                │
│  Methods:                                      │
│  • copyWith(...) → AppSettings                 │
│  • toJson() → Map                              │
│  • fromJson(Map) → AppSettings                 │
└────────────────────────────────────────────────┘
                      │
                      │ Managed by
                      ▼
┌────────────────────────────────────────────────┐
│           SettingsNotifier                     │
│  (StateNotifier<AppSettings>)                  │
│                                                │
│  Methods:                                      │
│  • _loadSettings() from SharedPreferences      │
│  • _saveSettings() to SharedPreferences        │
│  • setLanguage(String)                         │
│  • setThemeMode(ThemeMode)                     │
│  • setVoiceCues(bool)                          │
│  • setHaptics(bool)                            │
│  • setTtsVolume(double)                        │
│  • setTtsRate(double)                          │
│  • setCountdownSeconds(int)                    │
└────────────────────────────────────────────────┘
                      │
                      │ Provided by
                      ▼
┌────────────────────────────────────────────────┐
│            settingsProvider                    │
│  (StateNotifierProvider<SettingsNotifier,      │
│                          AppSettings>)         │
└────────────────────────────────────────────────┘
```

## 🎨 UI Component Hierarchy

```
MaterialApp
  │
  └── HomePage
      │
      ├── AppBar
      │   ├── Title
      │   ├── History Icon (→ ProgressPage)
      │   └── Settings Icon (→ SettingsPage)
      │
      └── ListView
          │
          └── [For each workout]
              └── WorkoutCard
                  ├── Icon (mode-specific)
                  ├── Title
                  ├── Description
                  ├── Duration badge
                  └── onTap → ModeDetailPage
                      │
                      ├── Description
                      ├── Info rows (duration, segments)
                      ├── Level selector (if available)
                      ├── Options switches (voice, haptics)
                      └── Start Button → TimerPage
                          │
                          ├── Progress bar (linear)
                          ├── Segment label
                          ├── Round indicator
                          ├── Countdown (large)
                          ├── MetronomeVisual
                          │   ├── SimpleMetronome (pulsing)
                          │   ├── TempoMetronome (dots)
                          │   └── BreathingMetronome (expanding)
                          │
                          ├── Next segment preview
                          ├── Controls
                          │   ├── Previous button
                          │   ├── Pause/Resume button
                          │   └── Next button
                          │
                          └── Stop button
```

## 🔐 State Management Strategy

### Provider Types Used

1. **Provider** (read-only, computed)
   - `sessionStateProvider` - derives from intervalEngineProvider.state
   - `hasActiveSessionProvider` - computed boolean

2. **FutureProvider** (async data)
   - `workoutListProvider` - loads workouts from JSON
   - `workoutByIdProvider` - fetches specific workout

3. **StateNotifierProvider** (mutable state)
   - `settingsProvider` - manages app settings
   - `progressProvider` - manages session logs

4. **ChangeNotifierProvider** (complex state with listeners)
   - `intervalEngineProvider` - manages timer & workout state

### Why This Strategy?

- **Separation of concerns**: UI doesn't know about business logic
- **Testability**: Providers can be mocked easily
- **Performance**: Only widgets that watch specific providers rebuild
- **Type safety**: Compile-time type checking
- **Simplicity**: No boilerplate (vs Redux/BLoC)

## 🧪 Testing Architecture

```
Test Layer
    │
    ├── Unit Tests
    │   ├── Models
    │   │   ├── WorkoutPlan parsing
    │   │   ├── IntervalSegment parsing
    │   │   └── SessionLog serialization
    │   │
    │   ├── Engine
    │   │   ├── Timer transitions
    │   │   ├── Pause/resume
    │   │   ├── Progress calculation
    │   │   └── Repeat logic
    │   │
    │   └── Repository
    │       ├── JSON loading
    │       ├── Cache behavior
    │       └── Query methods
    │
    ├── Widget Tests
    │   ├── HomePage rendering
    │   ├── TimerPage UI updates
    │   └── Navigation flows
    │
    └── Integration Tests (future)
        └── End-to-end workout flow
```

## 🔄 Lifecycle Flows

### App Lifecycle

```
App Launch
    │
    ├─► Load Flutter engine
    ├─► Initialize Riverpod (ProviderScope)
    ├─► Load settings from SharedPreferences
    ├─► Apply theme & language
    ├─► Build MaterialApp
    └─► Show HomePage
        │
        ├─► Load workouts.json
        └─► Display workout cards
```

### Workout Session Lifecycle

```
Session Start
    │
    ├─► Create IntervalSessionState
    ├─► Run countdown (3-2-1)
    ├─► Start 1-second timer
    │
    ▼
Running
    │
    ├─► Tick every second
    ├─► Update state
    ├─► Notify listeners
    ├─► Handle TTS & haptics
    │
    ├─► User pause? → Paused state
    │   └─► User resume? → Back to Running
    │
    ├─► Segment complete? → Advance segment
    │
    ▼
Complete
    │
    ├─► Stop timer
    ├─► Save SessionLog
    ├─► Show completion dialog
    └─► Clean up resources
```

## 📊 Performance Considerations

### Optimizations

1. **JSON Caching**
   - Workouts loaded once, cached in memory
   - Only reload on explicit clearCache()

2. **Provider Efficiency**
   - Only widgets watching specific providers rebuild
   - Use `.select()` for granular updates (if needed)

3. **Timer Accuracy**
   - Uses DateTime delta instead of just tick count
   - Handles app backgrounding correctly

4. **TTS Throttling**
   - Loop announcements every ~12 seconds, not every second
   - Prevents TTS queue overflow

5. **Widget Rebuilds**
   - Minimal rebuilds via targeted providers
   - Use `const` constructors where possible

## 🎯 Design Patterns Used

1. **Repository Pattern**
   - `WorkoutRepository` abstracts data source
   - Could swap JSON for API/database without UI changes

2. **State Pattern**
   - `IntervalSessionState` represents different states
   - Immutable state transitions

3. **Observer Pattern**
   - Riverpod providers notify listeners on changes
   - Widgets rebuild reactively

4. **Factory Pattern**
   - `fromJson()` factories for model parsing

5. **Singleton (via Riverpod)**
   - Single instance of repositories & notifiers

---

**Architecture designed for simplicity, testability, and maintainability.**
