import 'package:flutter_test/flutter_test.dart';
import 'package:intervals_training/core/models/workout_plan.dart';
import 'package:intervals_training/core/models/interval_segment.dart';
import 'package:intervals_training/core/models/interval_type.dart';

void main() {
  group('WorkoutPlan', () {
    test('should parse from JSON correctly', () {
      final json = {
        'id': 'test_workout',
        'title': 'Test Workout',
        'description': 'A test workout',
        'mode': 'test',
        'segments': [
          {
            'type': 'work',
            'label': 'Work',
            'seconds': 30,
            'cues': {'tts_start': 'Go!'}
          },
          {
            'type': 'recovery',
            'label': 'Rest',
            'seconds': 10,
          }
        ],
        'repeat': 3,
      };

      final workout = WorkoutPlan.fromJson(json);

      expect(workout.id, 'test_workout');
      expect(workout.title, 'Test Workout');
      expect(workout.mode, 'test');
      expect(workout.segments.length, 2);
      expect(workout.repeat, 3);
    });

    test('should calculate total duration correctly', () {
      const workout = WorkoutPlan(
        id: 'test',
        title: 'Test',
        description: 'Test',
        mode: 'test',
        segments: [
          IntervalSegment(
            type: IntervalType.work,
            label: 'Work',
            seconds: 30,
          ),
          IntervalSegment(
            type: IntervalType.recovery,
            label: 'Rest',
            seconds: 10,
          ),
        ],
        repeat: 3,
      );

      // (30 + 10) * 3 = 120
      expect(workout.totalDurationSeconds, 120);
    });

    test('should convert to JSON correctly', () {
      const workout = WorkoutPlan(
        id: 'test',
        title: 'Test',
        description: 'Test desc',
        mode: 'test',
        segments: [
          IntervalSegment(
            type: IntervalType.work,
            label: 'Work',
            seconds: 20,
          ),
        ],
        repeat: 2,
      );

      final json = workout.toJson();

      expect(json['id'], 'test');
      expect(json['title'], 'Test');
      expect(json['repeat'], 2);
      expect(json['segments'], isA<List>());
    });
  });
}
