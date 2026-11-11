import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/workout_plan.dart';
import '../../core/models/interval_segment.dart';
import '../../core/providers/settings_provider.dart';
import '../timer/timer_page.dart';

class ModeDetailPage extends ConsumerStatefulWidget {
  final WorkoutPlan workout;

  const ModeDetailPage({super.key, required this.workout});

  @override
  ConsumerState<ModeDetailPage> createState() => _ModeDetailPageState();
}

class _ModeDetailPageState extends ConsumerState<ModeDetailPage> {
  String? selectedMode;
  bool voiceCuesEnabled = true;
  bool hapticsEnabled = true;

  // Custom settings
  int? customWarmup;
  int? customWork;
  int? customRecovery;
  int? customRepeat;

  @override
  void initState() {
    super.initState();
    // Set default mode
    final modes = widget.workout.availableModes;
    if (modes != null && modes.isNotEmpty) {
      selectedMode = modes.first;
    }
    // Set custom values to default
    _setDefaultCustomValues();
  }

  void _setDefaultCustomValues() {
    // Set custom values based on workout segments
    if (widget.workout.segments.isNotEmpty) {
      // Try to find warmup segment
      final warmup = widget.workout.segments.where((s) => s.type.name == 'warmup').firstOrNull;
      if (warmup != null) {
        customWarmup = warmup.seconds;
      }

      // Try to find work segment
      final work = widget.workout.segments.where((s) => s.type.name == 'work').firstOrNull;
      if (work != null) {
        customWork = work.seconds;
      }

      // Try to find recovery segment
      final recovery = widget.workout.segments.where((s) => s.type.name == 'recovery').firstOrNull;
      if (recovery != null) {
        customRecovery = recovery.seconds;
      }

      customRepeat = widget.workout.repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);

    voiceCuesEnabled = settings.voiceCuesEnabled;
    hapticsEnabled = settings.hapticsEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deskripsi
            Text(
              widget.workout.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Durasi
            _InfoRow(
              icon: Icons.timer,
              label: l10n.duration,
              value: _formatDuration(widget.workout.totalDurationSeconds),
            ),
            const SizedBox(height: 8),

            // Jumlah segmen
            _InfoRow(
              icon: Icons.view_list,
              label: l10n.translate('segments'),
              value: '${widget.workout.segments.length} × ${widget.workout.repeat}',
            ),
            const SizedBox(height: 24),

            // Mode selector (Default/Custom)
            if (widget.workout.availableModes != null) ...[
              Text(
                l10n.translate('mode'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: widget.workout.availableModes!.map((mode) {
                  final isSelected = selectedMode == mode;
                  return ChoiceChip(
                    label: Text(mode),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedMode = mode;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Custom settings (jika Custom dipilih)
            if (selectedMode == 'Custom' && widget.workout.customizable != null) ...[
              Text(
                l10n.translate('custom_settings'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Warmup
              if (widget.workout.customizable!['warmup'] == true)
                _CustomInputRow(
                  label: 'Warmup',
                  value: customWarmup ?? 60,
                  onChanged: (value) => setState(() => customWarmup = value),
                ),

              // Work
              if (widget.workout.customizable!['work'] == true)
                _CustomInputRow(
                  label: l10n.translate('work'),
                  value: customWork ?? 30,
                  onChanged: (value) => setState(() => customWork = value),
                ),

              // Recovery
              if (widget.workout.customizable!['recovery'] == true)
                _CustomInputRow(
                  label: l10n.translate('recovery'),
                  value: customRecovery ?? 30,
                  onChanged: (value) => setState(() => customRecovery = value),
                ),

              // Repeat
              if (widget.workout.customizable!['repeat'] == true)
                _CustomInputRow(
                  label: l10n.translate('repeat'),
                  value: customRepeat ?? 1,
                  onChanged: (value) => setState(() => customRepeat = value),
                  isRepeat: true,
                ),

              const SizedBox(height: 24),
            ],

            // Options
            Text(
              l10n.translate('options'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              title: Text(l10n.voiceCues),
              subtitle: Text(l10n.translate('voice_cues_desc')),
              value: voiceCuesEnabled,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setVoiceCues(value);
              },
            ),

            SwitchListTile(
              title: Text(l10n.haptics),
              subtitle: Text(l10n.translate('haptics_desc')),
              value: hapticsEnabled,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setHaptics(value);
              },
            ),

            const SizedBox(height: 32),

            // Tombol Start
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _startWorkout,
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  l10n.start,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (secs == 0) {
      return '$minutes menit';
    }
    return '$minutes:${secs.toString().padLeft(2, '0')} menit';
  }

  void _startWorkout() {
    final settings = ref.read(settingsProvider);

    // Create custom workout if Custom mode is selected
    WorkoutPlan workoutToUse = widget.workout;
    if (selectedMode == 'Custom') {
      workoutToUse = _createCustomWorkout();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerPage(
          workout: workoutToUse,
          level: selectedMode,
        ),
      ),
    );
  }

  WorkoutPlan _createCustomWorkout() {
    // Create a custom workout based on user settings
    final customizable = widget.workout.customizable;
    final newSegments = <IntervalSegment>[];

    for (final segment in widget.workout.segments) {
      final type = segment.type;
      int newSeconds = segment.seconds;

      // Update based on custom settings
      if (customizable != null) {
        if (type.name == 'warmup' && customizable['warmup'] == true && customWarmup != null) {
          newSeconds = customWarmup!;
        } else if (type.name == 'work' && customizable['work'] == true && customWork != null) {
          newSeconds = customWork!;
        } else if (type.name == 'recovery' && customizable['recovery'] == true && customRecovery != null) {
          newSeconds = customRecovery!;
        }
      }

      // Create new segment with updated duration
      newSegments.add(IntervalSegment(
        type: type,
        label: segment.label,
        seconds: newSeconds,
        cues: segment.cues,
      ));
    }

    final newRepeat = (customizable != null && customizable['repeat'] == true && customRepeat != null)
        ? customRepeat!
        : widget.workout.repeat;

    return WorkoutPlan(
      id: '${widget.workout.id}_custom',
      title: widget.workout.title,
      description: widget.workout.description,
      mode: widget.workout.mode,
      segments: newSegments,
      repeat: newRepeat,
      options: widget.workout.options,
    );
  }
}

class _CustomInputRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final bool isRepeat;

  const _CustomInputRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRepeat = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: value > (isRepeat ? 1 : 5)
                ? () => onChanged(value - (isRepeat ? 1 : 5))
                : null,
          ),
          Container(
            width: 60,
            alignment: Alignment.center,
            child: Text(
              '$value${isRepeat ? 'x' : 's'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onChanged(value + (isRepeat ? 1 : 5)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
