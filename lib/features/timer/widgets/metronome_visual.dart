import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/models/interval_segment.dart';
import '../../../core/models/interval_type.dart';

/// Widget metronom visual yang berubah sesuai tipe segmen
class MetronomeVisual extends StatefulWidget {
  final IntervalSegment segment;
  final int remainingSeconds;

  const MetronomeVisual({
    super.key,
    required this.segment,
    required this.remainingSeconds,
  });

  @override
  State<MetronomeVisual> createState() => _MetronomeVisualState();
}

class _MetronomeVisualState extends State<MetronomeVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void didUpdateWidget(MetronomeVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation if segment changed
    if (oldWidget.segment != widget.segment) {
      _controller.reset();
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pilih visualisasi berdasarkan tipe
    if (widget.segment.type == IntervalType.breath &&
        widget.segment.breathPattern != null) {
      return _BreathingMetronome(
        segment: widget.segment,
        remainingSeconds: widget.remainingSeconds,
      );
    } else if (widget.segment.tempo != null) {
      return _TempoMetronome(
        segment: widget.segment,
        remainingSeconds: widget.remainingSeconds,
      );
    } else {
      return _SimpleMetronome(
        segment: widget.segment,
        remainingSeconds: widget.remainingSeconds,
        animation: _controller,
      );
    }
  }
}

/// Metronom sederhana dengan pulsing circle
class _SimpleMetronome extends StatelessWidget {
  final IntervalSegment segment;
  final int remainingSeconds;
  final Animation<double> animation;

  const _SimpleMetronome({
    required this.segment,
    required this.remainingSeconds,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    // Warna berdasarkan tipe
    Color color;
    switch (segment.type) {
      case IntervalType.work:
        color = Colors.red;
        break;
      case IntervalType.recovery:
        color = Colors.blue;
        break;
      case IntervalType.warmup:
        color = Colors.orange;
        break;
      case IntervalType.cooldown:
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    // Use animation for smooth pulse instead of calculating based on remainingSeconds
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final pulsePhase = animation.value;
        final scale = 1.0 + (math.sin(pulsePhase * math.pi * 2) * 0.1);

        return Center(
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
                border: Border.all(
                  color: color,
                  width: 8,
                ),
              ),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Metronom dengan tempo pattern (contoh: 2-1-2-1 untuk plank)
class _TempoMetronome extends StatefulWidget {
  final IntervalSegment segment;
  final int remainingSeconds;

  const _TempoMetronome({
    required this.segment,
    required this.remainingSeconds,
  });

  @override
  State<_TempoMetronome> createState() => _TempoMetronomeState();
}

class _TempoMetronomeState extends State<_TempoMetronome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<int> beats;
  late int totalBeats;
  int activeBeatIndex = 0;

  @override
  void initState() {
    super.initState();
    beats = widget.segment.tempo!.split('-').map(int.parse).toList();
    totalBeats = beats.reduce((a, b) => a + b);

    // Animation duration based on tempo pattern
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (totalBeats * 250)), // 250ms per beat unit
    )..repeat();

    // Update active beat based on remaining seconds
    _updateActiveBeat();
  }

  @override
  void didUpdateWidget(_TempoMetronome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingSeconds != widget.remainingSeconds) {
      _updateActiveBeat();
    }
  }

  void _updateActiveBeat() {
    final elapsed = widget.segment.seconds - widget.remainingSeconds;
    final currentBeat = elapsed % totalBeats;

    int accumulated = 0;
    for (int i = 0; i < beats.length; i++) {
      accumulated += beats[i];
      if (currentBeat < accumulated) {
        if (activeBeatIndex != i) {
          setState(() {
            activeBeatIndex = i;
          });
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: List.generate(beats.length, (index) {
          final isActive = index == activeBeatIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.orange : Colors.orange.withOpacity(0.2),
              border: Border.all(
                color: Colors.orange,
                width: isActive ? 4 : 2,
              ),
            ),
            child: Center(
              child: Text(
                beats[index].toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : Colors.orange,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Metronom untuk breathing dengan pattern box (4-4-4-4)
class _BreathingMetronome extends StatefulWidget {
  final IntervalSegment segment;
  final int remainingSeconds;

  const _BreathingMetronome({
    required this.segment,
    required this.remainingSeconds,
  });

  @override
  State<_BreathingMetronome> createState() => _BreathingMetronomeState();
}

class _BreathingMetronomeState extends State<_BreathingMetronome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<int> pattern;
  late List<String> labels;
  late int cycleDuration;
  int activePhase = 0;
  double phaseProgress = 0.0;

  @override
  void initState() {
    super.initState();
    pattern = widget.segment.breathPattern!;
    labels = widget.segment.breathLabels ?? ['In', 'Hold', 'Out', 'Hold'];
    cycleDuration = pattern.reduce((a, b) => a + b);

    // Animation runs at 60fps for smooth breathing effect
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: cycleDuration),
    )..repeat();

    // Calculate initial phase
    _updatePhase();
  }

  @override
  void didUpdateWidget(_BreathingMetronome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingSeconds != widget.remainingSeconds) {
      _updatePhase();
    }
  }

  void _updatePhase() {
    final elapsed = widget.segment.seconds - widget.remainingSeconds;
    final positionInCycle = elapsed % cycleDuration;

    // Find active phase
    int accumulated = 0;
    for (int i = 0; i < pattern.length; i++) {
      accumulated += pattern[i];
      if (positionInCycle < accumulated) {
        if (activePhase != i) {
          setState(() {
            activePhase = i;
          });
        }
        break;
      }
    }

    // Calculate progress within phase
    int phaseStart = 0;
    for (int i = 0; i < activePhase; i++) {
      phaseStart += pattern[i];
    }
    phaseProgress = (positionInCycle - phaseStart) / pattern[activePhase];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circle yang membesar/mengecil dengan smooth animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final size = _getBreathCircleSize(activePhase, phaseProgress);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.purple,
                    width: 6,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Label fase
          Text(
            labels[activePhase],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 16),
          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pattern.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == activePhase
                      ? Colors.purple
                      : Colors.purple.withOpacity(0.3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  double _getBreathCircleSize(int phase, double progress) {
    // Fase 0 (In): 100 -> 200
    // Fase 1 (Hold): 200
    // Fase 2 (Out): 200 -> 100
    // Fase 3 (Hold): 100

    switch (phase) {
      case 0: // Inhale
        return 100 + (100 * progress);
      case 1: // Hold (full)
        return 200;
      case 2: // Exhale
        return 200 - (100 * progress);
      case 3: // Hold (empty)
        return 100;
      default:
        return 150;
    }
  }
}
