import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/interval_segment.dart';
import '../models/workout_plan.dart';

/// State dari session yang sedang berjalan
class IntervalSessionState {
  final WorkoutPlan workout;
  final int currentRepeat; // 0-based
  final int currentSegmentIndex; // index dalam workout.segments
  final int remainingSeconds; // sisa detik untuk segmen aktif (untuk display)
  final int actualRemainingSeconds; // sisa detik aktual (untuk akurasi internal)
  final bool isPaused;
  final bool isCompleted;
  final int totalElapsedSeconds; // total waktu yang sudah berlalu
  final String? level; // Default atau Custom
  final bool warmupCompleted; // track apakah warmup sudah selesai

  const IntervalSessionState({
    required this.workout,
    this.currentRepeat = 0,
    this.currentSegmentIndex = 0,
    required this.remainingSeconds,
    int? actualRemainingSeconds,
    this.isPaused = false,
    this.isCompleted = false,
    this.totalElapsedSeconds = 0,
    this.level,
    this.warmupCompleted = false,
  }) : actualRemainingSeconds = actualRemainingSeconds ?? remainingSeconds;

  IntervalSessionState copyWith({
    WorkoutPlan? workout,
    int? currentRepeat,
    int? currentSegmentIndex,
    int? remainingSeconds,
    int? actualRemainingSeconds,
    bool? isPaused,
    bool? isCompleted,
    int? totalElapsedSeconds,
    String? level,
    bool? warmupCompleted,
  }) {
    return IntervalSessionState(
      workout: workout ?? this.workout,
      currentRepeat: currentRepeat ?? this.currentRepeat,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      actualRemainingSeconds: actualRemainingSeconds,
      isPaused: isPaused ?? this.isPaused,
      isCompleted: isCompleted ?? this.isCompleted,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      level: level ?? this.level,
      warmupCompleted: warmupCompleted ?? this.warmupCompleted,
    );
  }

  /// Ambil segmen yang sedang aktif
  IntervalSegment get currentSegment => workout.segments[currentSegmentIndex];

  /// Cek apakah ada segmen berikutnya
  bool get hasNextSegment {
    if (currentSegmentIndex < workout.segments.length - 1) return true;
    if (currentRepeat < workout.repeat - 1) return true;
    return false;
  }

  /// Cek apakah ada segmen sebelumnya
  bool get hasPreviousSegment {
    if (currentSegmentIndex > 0) return true;
    if (currentRepeat > 0) return true;
    return false;
  }

  /// Hitung progress total (0.0 - 1.0)
  double get progress {
    final totalDuration = workout.totalDurationSeconds;
    if (totalDuration == 0) return 1.0;
    return totalElapsedSeconds / totalDuration;
  }
}

/// Engine interval training dengan scheduler 1-detik
/// Memancarkan event untuk:
/// - Tick setiap detik
/// - Transisi segmen (untuk TTS & haptics)
/// - Completion
class IntervalEngine extends ChangeNotifier {
  IntervalSessionState? _state;
  Timer? _timer;
  DateTime? _lastTickTime;

  IntervalSessionState? get state => _state;

  /// Mulai session baru dengan countdown awal (default 3 detik)
  Future<void> startSession(WorkoutPlan workout, {String? level, int countdownSeconds = 3}) async {
    stop();

    // Jalankan countdown terlebih dahulu
    await _runCountdown(countdownSeconds);

    // Cek apakah ada warmup di workout
    final hasWarmup = workout.segments.any((s) => s.type.name == 'warmup');

    final firstSegmentSeconds = workout.segments.first.seconds;
    _state = IntervalSessionState(
      workout: workout,
      currentRepeat: 0,
      currentSegmentIndex: 0,
      remainingSeconds: firstSegmentSeconds,
      actualRemainingSeconds: firstSegmentSeconds,
      level: level,
      warmupCompleted: !hasWarmup, // Jika tidak ada warmup, mark as completed
    );

    _startTimer();
    notifyListeners();
  }

  /// Countdown 3-2-1 sebelum mulai
  Future<void> _runCountdown(int seconds) async {
    for (int i = seconds; i > 0; i--) {
      // Emit event countdown (bisa didengarkan oleh UI untuk haptics/TTS)
      _onCountdownTick(i);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _onCountdownTick(int count) {
    // Hook untuk countdown - minimal logging untuk performance
  }

  void _startTimer() {
    _lastTickTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (_state == null || _state!.isPaused) return;

    // Hitung delta waktu untuk akurasi internal (kasus app masuk background)
    final now = DateTime.now();
    final delta = now.difference(_lastTickTime!).inSeconds;
    _lastTickTime = now;

    // Gunakan actualRemaining sebagai sumber kebenaran tunggal
    // Dan sync display dengan actual untuk menghindari desynchronization
    final actualRemaining = _state!.actualRemainingSeconds - delta;

    if (actualRemaining > 0) {
      // Masih dalam segmen yang sama
      // Update display dengan clamp ke 0 minimal (tidak ada negatif)
      final displayRemaining = actualRemaining.clamp(0, 999999);
      final elapsed = _state!.totalElapsedSeconds + delta;

      _state = _state!.copyWith(
        remainingSeconds: displayRemaining,
        actualRemainingSeconds: actualRemaining,
        totalElapsedSeconds: elapsed,
      );
    } else {
      // Segmen selesai, pindah ke segmen berikutnya
      _advanceSegment();
    }

    notifyListeners();
  }

  void _advanceSegment() {
    if (_state == null) return;

    final nextSegmentIndex = _state!.currentSegmentIndex + 1;
    final currentSegment = _state!.currentSegment;

    // Cek apakah segmen saat ini adalah warmup yang baru selesai
    // Simply mark warmup as completed whenever we finish a warmup segment
    if (currentSegment.type.name == 'warmup' && !_state!.warmupCompleted) {
      // Tandai warmup sebagai completed
      _state = _state!.copyWith(warmupCompleted: true);
    }

    if (nextSegmentIndex < _state!.workout.segments.length) {
      // Masih ada segmen di repeat ini
      final segmentSeconds = _state!.workout.segments[nextSegmentIndex].seconds;
      // Explicitly preserve warmupCompleted when advancing within same repeat
      _state = _state!.copyWith(
        currentSegmentIndex: nextSegmentIndex,
        remainingSeconds: segmentSeconds,
        actualRemainingSeconds: segmentSeconds,
        warmupCompleted: _state!.warmupCompleted,
      );
      _onSegmentTransition();
    } else if (_state!.currentRepeat < _state!.workout.repeat - 1) {
      // Repeat berikutnya - skip warmup jika sudah selesai
      int startIndex = 0;
      final nextRepeat = _state!.currentRepeat + 1;

      // ALWAYS skip warmup for repeats after the first one (more robust logic)
      // If nextRepeat > 0, we're going to repeat 1, 2, 3, etc. - skip warmup
      if (nextRepeat > 0) {
        // Find first non-warmup segment
        for (int i = 0; i < _state!.workout.segments.length; i++) {
          if (_state!.workout.segments[i].type.name != 'warmup') {
            startIndex = i;
            break;
          }
        }
      }

      final segmentSeconds = _state!.workout.segments[startIndex].seconds;

      // Explicitly preserve warmupCompleted when moving to next repeat
      _state = _state!.copyWith(
        currentRepeat: nextRepeat,
        currentSegmentIndex: startIndex,
        remainingSeconds: segmentSeconds,
        actualRemainingSeconds: segmentSeconds,
        warmupCompleted: nextRepeat > 0, // Set warmupCompleted to true after first repeat
      );
      _onSegmentTransition();
    } else {
      // Workout selesai
      _state = _state!.copyWith(isCompleted: true);
      _onWorkoutComplete();
      stop();
    }
  }

  void _onSegmentTransition() {
    // Hook untuk transisi segmen (bisa didengarkan untuk TTS/haptics)
    // Minimal logging untuk performance
  }

  void _onWorkoutComplete() {
    // Workout complete - bisa ditambahkan callback jika perlu
  }

  /// Pause session
  void pause() {
    if (_state == null || _state!.isPaused) return;
    _state = _state!.copyWith(isPaused: true);
    notifyListeners();
  }

  /// Resume session
  void resume() {
    if (_state == null || !_state!.isPaused) return;
    _state = _state!.copyWith(isPaused: false);
    _lastTickTime = DateTime.now(); // Reset waktu untuk akurasi
    notifyListeners();
  }

  /// Stop dan reset session
  void stop() {
    _timer?.cancel();
    _timer = null;
    _lastTickTime = null;
    _state = null;
    notifyListeners();
  }

  /// Lompat ke segmen berikutnya (manual)
  void nextSegment() {
    if (_state == null || !_state!.hasNextSegment) return;
    _advanceSegment();
    notifyListeners();
  }

  /// Lompat ke segmen sebelumnya (manual)
  void previousSegment() {
    if (_state == null || !_state!.hasPreviousSegment) return;

    if (_state!.currentSegmentIndex > 0) {
      final prevIndex = _state!.currentSegmentIndex - 1;

      // Jika kembali ke warmup, reset warmupCompleted
      final prevSegment = _state!.workout.segments[prevIndex];
      final newWarmupCompleted = _state!.warmupCompleted && prevSegment.type.name != 'warmup';

      final segmentSeconds = prevSegment.seconds;
      _state = _state!.copyWith(
        currentSegmentIndex: prevIndex,
        remainingSeconds: segmentSeconds,
        actualRemainingSeconds: segmentSeconds,
        warmupCompleted: newWarmupCompleted,
      );
    } else if (_state!.currentRepeat > 0) {
      final prevRepeat = _state!.currentRepeat - 1;
      final lastSegmentIndex = _state!.workout.segments.length - 1;
      final segmentSeconds = _state!.workout.segments[lastSegmentIndex].seconds;

      // Hitung warmupCompleted untuk repeat sebelumnya
      bool newWarmupCompleted = _state!.warmupCompleted;
      if (prevRepeat == 0) {
        // Kembali ke repeat pertama, warmupCompleted = false (belum lewat warmup)
        newWarmupCompleted = false;
      }

      _state = _state!.copyWith(
        currentRepeat: prevRepeat,
        currentSegmentIndex: lastSegmentIndex,
        remainingSeconds: segmentSeconds,
        actualRemainingSeconds: segmentSeconds,
        warmupCompleted: newWarmupCompleted,
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
