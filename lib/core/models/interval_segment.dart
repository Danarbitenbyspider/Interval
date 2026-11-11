import 'package:equatable/equatable.dart';
import 'interval_type.dart';

/// Model untuk satu segmen interval (contoh: "Fast Walk 3 menit")
class IntervalSegment extends Equatable {
  final IntervalType type;
  final String label;
  final int seconds;
  final Map<String, dynamic>? cues;

  const IntervalSegment({
    required this.type,
    required this.label,
    required this.seconds,
    this.cues,
  });

  factory IntervalSegment.fromJson(Map<String, dynamic> json) {
    return IntervalSegment(
      type: IntervalType.fromString(json['type'] as String),
      label: json['label'] as String,
      seconds: json['seconds'] as int,
      cues: json['cues'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'label': label,
      'seconds': seconds,
      if (cues != null) 'cues': cues,
    };
  }

  /// Helper untuk ambil cue TTS saat segmen dimulai
  String? get ttsStart {
    if (cues == null) return null;
    return cues!['tts_start'] as String?;
  }

  /// Helper untuk ambil array TTS yang di-loop sepanjang segmen
  List<String>? get ttsLoop {
    if (cues == null) return null;
    final raw = cues!['tts_loop'];
    if (raw is List) {
      return raw.cast<String>();
    }
    return null;
  }

  /// Helper untuk ambil BPM metronom visual (opsional)
  int? get bpm {
    if (cues == null) return null;
    return cues!['bpm'] as int?;
  }

  /// Helper untuk ambil pola breathing (array angka)
  List<int>? get breathPattern {
    if (cues == null) return null;
    final raw = cues!['pattern'];
    if (raw is List) {
      return raw.cast<int>();
    }
    return null;
  }

  /// Helper untuk ambil label pola breathing
  List<String>? get breathLabels {
    if (cues == null) return null;
    final raw = cues!['labels'];
    if (raw is List) {
      return raw.cast<String>();
    }
    return null;
  }

  /// Helper untuk ambil tempo string (contoh: "2-1-2-1")
  String? get tempo {
    if (cues == null) return null;
    return cues!['tempo'] as String?;
  }

  /// Helper untuk ambil beep saat segmen dimulai
  bool? get beepStart {
    if (cues == null) return null;
    return cues!['beep_start'] as bool?;
  }

  /// Helper untuk ambil beep loop sepanjang segmen
  bool? get beepLoop {
    if (cues == null) return null;
    return cues!['beep_loop'] as bool?;
  }

  @override
  List<Object?> get props => [type, label, seconds, cues];
}
