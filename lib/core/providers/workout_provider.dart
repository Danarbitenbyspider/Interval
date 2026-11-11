import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_plan.dart';
import '../repo/workout_repository.dart';

/// Provider untuk workout repository
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository();
});

/// Provider untuk list semua workout
final workoutListProvider = FutureProvider<List<WorkoutPlan>>((ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return await repo.loadWorkouts();
});

/// Provider untuk ambil workout berdasarkan ID
final workoutByIdProvider = FutureProvider.family<WorkoutPlan?, String>((ref, id) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return await repo.getWorkoutById(id);
});
