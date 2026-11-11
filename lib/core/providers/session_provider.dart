import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/interval_engine.dart';

/// Provider untuk interval engine (session aktif)
final intervalEngineProvider = ChangeNotifierProvider<IntervalEngine>((ref) {
  return IntervalEngine();
});

/// Provider untuk state session aktif (bisa null jika tidak ada session)
final sessionStateProvider = Provider<IntervalSessionState?>((ref) {
  final engine = ref.watch(intervalEngineProvider);
  return engine.state;
});

/// Provider helper untuk cek apakah ada session aktif
final hasActiveSessionProvider = Provider<bool>((ref) {
  final state = ref.watch(sessionStateProvider);
  return state != null && !state.isCompleted;
});
