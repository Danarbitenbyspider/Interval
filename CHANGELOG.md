# Changelog

All notable changes to Intervals Training will be documented in this file.

## [1.0.0] - 2025-01-08

### Added
- ✨ Initial release of Intervals Training
- 🏃 5 workout modes:
  - Japanese Walking Interval (3×3)
  - Tabata Basic (4 minutes)
  - Mobility Interval (12 minutes)
  - Core Interval Training (10 minutes)
  - Breathing Intervals (Box 4-4-4-4)
- 🎙️ Text-to-Speech narration (Bahasa Indonesia & English)
- 📳 Haptic feedback on segment transitions
- 📊 Visual metronome with mode-specific animations:
  - Pulsing circle for work/recovery
  - Tempo dots for core exercises
  - Expanding/contracting circle for breathing
- 🌙 Dark mode & Light mode
- 🌍 Localization (id, en)
- 📈 Progress tracking with session logs
- ⚙️ Settings:
  - Language selection
  - Theme mode (Light/Dark/System)
  - Voice cues on/off
  - TTS volume & speed control
  - Haptics on/off
  - Countdown duration (0-5 seconds)
- 🎯 Level selection (Beginner/Intermediate/Advanced) for supported workouts
- ⏸️ Pause/Resume functionality
- ⏭️ Manual navigation (Next/Previous segment)
- 🔔 Countdown alerts (3-2-1) before workout start
- 💾 Offline-first architecture with local storage
- ✅ Accessibility features:
  - WCAG AA contrast ratios
  - Dynamic text sizing
  - Large touch targets
  - TTS support

### Technical
- Built with Flutter 3.0+
- State management: Riverpod
- TTS: flutter_tts
- Haptics: vibration
- Storage: shared_preferences
- Null-safety enabled
- Unit tests for core engine and JSON parsing

---

## Future Plans (Nice-to-Have)

- [ ] Custom workout builder
- [ ] Calorie estimation
- [ ] Export session logs as JSON
- [ ] Workout history charts
- [ ] Workout reminders
- [ ] More workout modes
- [ ] Audio beeps (alternative to TTS)
- [ ] Workout playlists
