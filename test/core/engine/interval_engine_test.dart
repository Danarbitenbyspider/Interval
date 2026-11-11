import 'package:flutter_test/flutter_test.dart';
import 'package:intervals_training/core/engine/interval_engine.dart';
import 'package:intervals_training/core/models/workout_plan.dart';
import 'package:intervals_training/core/models/interval_segment.dart';
import 'package:intervals_training/core/models/interval_type.dart';

void main() {
  group('IntervalEngine', () {
    late IntervalEngine engine;
    late WorkoutPlan testWorkout;

    setUp(() {
      engine = IntervalEngine();
      testWorkout = const WorkoutPlan(
        id: 'test',
        title: 'Test Workout',
        description: 'Test',
        mode: 'test',
        segments: [
          IntervalSegment(
            type: IntervalType.work,
            label: 'Work',
            seconds: 5,
          ),
          IntervalSegment(
            type: IntervalType.recovery,
            label: 'Rest',
            seconds: 3,
          ),
        ],
        repeat: 2,
      );
    });

    tearDown(() {
      engine.dispose();
    });

    test('should initialize session state correctly', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      expect(engine.state, isNotNull);
      expect(engine.state!.workout.id, 'test');
      expect(engine.state!.currentRepeat, 0);
      expect(engine.state!.currentSegmentIndex, 0);
      expect(engine.state!.remainingSeconds, 5);
    });

    test('should handle pause and resume', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      engine.pause();
      expect(engine.state!.isPaused, true);

      engine.resume();
      expect(engine.state!.isPaused, false);
    });

    test('should advance to next segment manually', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      expect(engine.state!.currentSegmentIndex, 0);
      expect(engine.state!.currentSegment.label, 'Work');

      engine.nextSegment();

      expect(engine.state!.currentSegmentIndex, 1);
      expect(engine.state!.currentSegment.label, 'Rest');
    });

    test('should go to previous segment manually', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      engine.nextSegment(); // Go to segment 1
      expect(engine.state!.currentSegmentIndex, 1);

      engine.previousSegment();
      expect(engine.state!.currentSegmentIndex, 0);
    });

    test('should calculate progress correctly', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      // Total duration: (5 + 3) * 2 = 16 seconds
      expect(engine.state!.progress, 0.0);

      // Simulate some elapsed time
      final state = engine.state!.copyWith(totalElapsedSeconds: 8);
      expect(state.progress, 0.5);
    });

    test('should detect hasNextSegment correctly', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      expect(engine.state!.hasNextSegment, true);

      // Move to last segment of last repeat
      engine.nextSegment(); // segment 1, repeat 0
      expect(engine.state!.hasNextSegment, true);

      engine.nextSegment(); // segment 0, repeat 1
      expect(engine.state!.hasNextSegment, true);

      engine.nextSegment(); // segment 1, repeat 1
      expect(engine.state!.hasNextSegment, false);
    });

    test('should stop session', () async {
      await engine.startSession(testWorkout, countdownSeconds: 0);

      expect(engine.state, isNotNull);

      engine.stop();

      expect(engine.state, isNull);
    });
  });

  group('IntervalSessionState', () {
    test('should calculate progress correctly', () {
      const workout = WorkoutPlan(
        id: 'test',
        title: 'Test',
        description: 'Test',
        mode: 'test',
        segments: [
          IntervalSegment(
            type: IntervalType.work,
            label: 'Work',
            seconds: 10,
          ),
        ],
        repeat: 1,
      );

      const state = IntervalSessionState(
        workout: workout,
        remainingSeconds: 10,
        totalElapsedSeconds: 0,
      );

      expect(state.progress, 0.0);

      final state2 = state.copyWith(totalElapsedSeconds: 5);
      expect(state2.progress, 0.5);

      final state3 = state.copyWith(totalElapsedSeconds: 10);
      expect(state3.progress, 1.0);
    });
  });
}
