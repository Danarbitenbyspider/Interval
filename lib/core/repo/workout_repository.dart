import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/workout_plan.dart';

/// Repository untuk load workout dari JSON assets
class WorkoutRepository {
  List<WorkoutPlan>? _cachedWorkouts;

  /// Load semua workout dari assets/workouts.json
  Future<List<WorkoutPlan>> loadWorkouts() async {
    if (_cachedWorkouts != null) return _cachedWorkouts!;

    try {
      final jsonString = await rootBundle.loadString('assets/workouts.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final workoutsJson = jsonData['workouts'] as List<dynamic>;

      _cachedWorkouts = workoutsJson
          .map((w) => WorkoutPlan.fromJson(w as Map<String, dynamic>))
          .toList();

      return _cachedWorkouts!;
    } catch (e) {
      throw Exception('Gagal load workouts: $e');
    }
  }

  /// Ambil workout berdasarkan ID
  Future<WorkoutPlan?> getWorkoutById(String id) async {
    final workouts = await loadWorkouts();
    try {
      return workouts.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Ambil workout berdasarkan mode
  Future<List<WorkoutPlan>> getWorkoutsByMode(String mode) async {
    final workouts = await loadWorkouts();
    return workouts.where((w) => w.mode == mode).toList();
  }

  /// Clear cache (berguna untuk testing atau reload)
  void clearCache() {
    _cachedWorkouts = null;
  }
}
