import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/workout_plan.dart';
import '../../core/models/session_log.dart';
import '../../core/providers/session_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/progress_provider.dart';
import 'widgets/metronome_visual.dart';

class _BeepPlayer {
  static const _channel = MethodChannel('com.example.intervals_training/beep');

  static Future<void> play() async {
    try {
      await _channel.invokeMethod('playBeep');
    } catch (e) {
      // Silently fail if platform channel not available
    }
  }
}

class TimerPage extends ConsumerStatefulWidget {
  final WorkoutPlan workout;
  final String? level;

  const TimerPage({
    super.key,
    required this.workout,
    this.level,
  });

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> with WidgetsBindingObserver {
  DateTime? _sessionStartTime;
  int? _lastRemainingSeconds;
  int? _lastSegmentIndex;
  bool _hasVibrator = false;
  int _lastBeepLoopTime = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkVibration();
    // Delay startSession agar tidak modify provider saat build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSession();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkVibration() async {
    _hasVibrator = await Vibration.hasVibrator() ?? false;
  }

  Future<void> _startSession() async {
    _sessionStartTime = DateTime.now();
    final settings = ref.read(settingsProvider);
    final engine = ref.read(intervalEngineProvider);

    await engine.startSession(
      widget.workout,
      level: widget.level,
      countdownSeconds: settings.countdownSeconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionStateProvider);
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context);

    // Handle TTS dan haptics berdasarkan state changes
    if (sessionState != null) {
      _handleCues(sessionState, settings);
    }

    // Handle workout completion
    if (sessionState?.isCompleted == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onWorkoutComplete();
      });
    }

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop) {
          ref.read(intervalEngineProvider).stop();
        }
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.title),
        ),
        body: sessionState == null
            ? const Center(child: CircularProgressIndicator())
            : _buildTimerView(context, sessionState, settings),
      ),
    );
  }

  Widget _buildTimerView(BuildContext context, sessionState, AppSettings settings) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentSegment = sessionState.currentSegment;

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: sessionState.progress,
          minHeight: 6,
        ),

        const SizedBox(height: 24),

        // Segment info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                currentSegment.label,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.translate('round')} ${sessionState.currentRepeat + 1}/${sessionState.workout.repeat}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Countdown timer
        Text(
          _formatTime(sessionState.remainingSeconds),
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 72,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),

        const SizedBox(height: 32),

        // Metronome visual
        Expanded(
          child: MetronomeVisual(
            segment: currentSegment,
            remainingSeconds: sessionState.remainingSeconds,
          ),
        ),

        const SizedBox(height: 24),

        // Next segment preview
        if (sessionState.hasNextSegment) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.translate('next')}: ${_getNextSegmentLabel(sessionState)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Controls
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous
              IconButton(
                onPressed: sessionState.hasPreviousSegment
                    ? () => ref.read(intervalEngineProvider).previousSegment()
                    : null,
                icon: const Icon(Icons.skip_previous),
                iconSize: 32,
              ),

              // Pause/Resume
              FilledButton.icon(
                onPressed: () {
                  final engine = ref.read(intervalEngineProvider);
                  if (sessionState.isPaused) {
                    engine.resume();
                  } else {
                    engine.pause();
                  }
                },
                icon: Icon(sessionState.isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(sessionState.isPaused ? l10n.resume : l10n.pause),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),

              // Next
              IconButton(
                onPressed: sessionState.hasNextSegment
                    ? () => ref.read(intervalEngineProvider).nextSegment()
                    : null,
                icon: const Icon(Icons.skip_next),
                iconSize: 32,
              ),
            ],
          ),
        ),

        // Stop button
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextButton.icon(
            onPressed: () async {
              final shouldStop = await _showStopConfirmation(context);
              if (shouldStop) {
                ref.read(intervalEngineProvider).stop();
                if (mounted) Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.stop),
            label: Text(l10n.stop),
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getNextSegmentLabel(sessionState) {
    final nextIndex = sessionState.currentSegmentIndex + 1;
    if (nextIndex < sessionState.workout.segments.length) {
      return sessionState.workout.segments[nextIndex].label;
    } else if (sessionState.currentRepeat < sessionState.workout.repeat - 1) {
      return sessionState.workout.segments.first.label;
    }
    return '';
  }

  void _handleCues(sessionState, AppSettings settings) {
    final currentSegment = sessionState.currentSegment;
    final remaining = sessionState.remainingSeconds;

    // Deteksi transisi segmen
    if (_lastSegmentIndex != sessionState.currentSegmentIndex) {
      _lastSegmentIndex = sessionState.currentSegmentIndex;
      _lastBeepLoopTime = 0;

      // Beep untuk segment start
      if (settings.voiceCuesEnabled) {
        // Play beep untuk setiap transisi segmen
        _playBeep();
      }

      // Haptics untuk transisi
      if (settings.hapticsEnabled && _hasVibrator) {
        Vibration.vibrate(duration: 200);
      }
    }

    // Beep loop setiap ~10-15 detik
    if (settings.voiceCuesEnabled && currentSegment.beepLoop == true) {
      final elapsed = currentSegment.seconds - remaining;
      if (elapsed > 0 && elapsed - _lastBeepLoopTime >= 12) {
        _lastBeepLoopTime = elapsed;
        _playBeep();
      }
    }

    // Haptics untuk 3-2-1 countdown di akhir segmen
    if (settings.hapticsEnabled && _hasVibrator && remaining <= 3 && remaining > 0) {
      if (_lastRemainingSeconds != remaining) {
        _lastRemainingSeconds = remaining;
        Vibration.vibrate(duration: 100);
        _playBeep(); // Beep untuk countdown juga
      }
    }
  }

  void _playBeep() {
    // Play beep sound via Android ToneGenerator
    _BeepPlayer.play();
  }

  Future<void> _onWorkoutComplete() async {
    final settings = ref.read(settingsProvider);

    // Beep
    if (settings.voiceCuesEnabled) {
      _playBeep();
    }

    // Haptics
    if (settings.hapticsEnabled && _hasVibrator) {
      await Vibration.vibrate(duration: 500);
    }

    // Simpan log
    final sessionState = ref.read(sessionStateProvider);
    if (sessionState != null && _sessionStartTime != null) {
      final log = SessionLog(
        workoutId: widget.workout.id,
        workoutTitle: widget.workout.title,
        date: DateTime.now(),
        durationSeconds: sessionState.totalElapsedSeconds,
        level: widget.level,
      );
      await ref.read(progressProvider.notifier).addLog(log);
    }

    // Show completion dialog
    if (mounted) {
      await _showCompletionDialog();
    }
  }

  Future<void> _showCompletionDialog() async {
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.workoutComplete),
        content: Text(l10n.translate('great_job')),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close timer page
            },
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('exit_workout')),
        content: Text(l10n.translate('exit_workout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.translate('exit')),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<bool> _showStopConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('stop_workout')),
        content: Text(l10n.translate('stop_workout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.stop),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
