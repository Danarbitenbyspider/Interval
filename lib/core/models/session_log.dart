import 'package:equatable/equatable.dart';

/// Model untuk log satu sesi workout yang sudah selesai
class SessionLog extends Equatable {
  final String workoutId;
  final String workoutTitle;
  final DateTime date;
  final int durationSeconds;
  final String? level;
  final int? rpe; // Rate of Perceived Exertion (1-10)
  final String? notes;

  const SessionLog({
    required this.workoutId,
    required this.workoutTitle,
    required this.date,
    required this.durationSeconds,
    this.level,
    this.rpe,
    this.notes,
  });

  factory SessionLog.fromJson(Map<String, dynamic> json) {
    return SessionLog(
      workoutId: json['workoutId'] as String,
      workoutTitle: json['workoutTitle'] as String,
      date: DateTime.parse(json['date'] as String),
      durationSeconds: json['durationSeconds'] as int,
      level: json['level'] as String?,
      rpe: json['rpe'] as int?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'workoutTitle': workoutTitle,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      if (level != null) 'level': level,
      if (rpe != null) 'rpe': rpe,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [workoutId, workoutTitle, date, durationSeconds, level, rpe, notes];
}
