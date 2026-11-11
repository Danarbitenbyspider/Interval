import 'package:equatable/equatable.dart';
import 'interval_segment.dart';

/// Model untuk satu workout plan lengkap (contoh: "Japanese Walking 3x3")
class WorkoutPlan extends Equatable {
  final String id;
  final String title;
  final String description;
  final String mode;
  final List<IntervalSegment> segments;
  final int repeat;
  final Map<String, dynamic>? options;
  final Map<String, bool>? customizable;

  const WorkoutPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.mode,
    required this.segments,
    this.repeat = 1,
    this.options,
    this.customizable,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    final segmentsRaw = json['segments'] as List<dynamic>;
    final segments = segmentsRaw
        .map((s) => IntervalSegment.fromJson(s as Map<String, dynamic>))
        .toList();

    // Parse customizable field
    Map<String, bool>? customizable;
    if (json['customizable'] is Map) {
      final raw = json['customizable'] as Map;
      customizable = raw.map((key, value) => MapEntry(key as String, value as bool));
    }

    return WorkoutPlan(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      mode: json['mode'] as String,
      segments: segments,
      repeat: json['repeat'] as int? ?? 1,
      options: json['options'] as Map<String, dynamic>?,
      customizable: customizable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'mode': mode,
      'segments': segments.map((s) => s.toJson()).toList(),
      'repeat': repeat,
      if (options != null) 'options': options,
      if (customizable != null) 'customizable': customizable,
    };
  }

  /// Hitung durasi total dalam detik (semua segmen × repeat)
  int get totalDurationSeconds {
    final segmentTotal = segments.fold<int>(0, (sum, seg) => sum + seg.seconds);
    return segmentTotal * repeat;
  }

  /// Helper untuk ambil level yang tersedia (deprecated, gunakan availableModes)
  List<String>? get availableLevels {
    if (options == null) return null;
    final raw = options!['level'];
    if (raw is List) {
      return raw.cast<String>();
    }
    return null;
  }

  /// Helper untuk ambil mode yang tersedia (Default, Custom)
  List<String>? get availableModes {
    if (options == null) return null;
    final raw = options!['mode'];
    if (raw is List) {
      return raw.cast<String>();
    }
    return null;
  }

  @override
  List<Object?> get props => [id, title, description, mode, segments, repeat, options, customizable];
}
