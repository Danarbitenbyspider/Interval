import 'package:flutter_test/flutter_test.dart';
import 'package:intervals_training/core/repo/workout_repository.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WorkoutRepository', () {
    late WorkoutRepository repository;

    setUp(() {
      repository = WorkoutRepository();

      // Mock asset bundle untuk testing
      const jsonData = '''
      {
        "workouts": [
          {
            "id": "test_1",
            "title": "Test Workout 1",
            "description": "Description 1",
            "mode": "test",
            "segments": [
              {"type": "work", "label": "Work", "seconds": 30}
            ],
            "repeat": 1
          },
          {
            "id": "test_2",
            "title": "Test Workout 2",
            "description": "Description 2",
            "mode": "test",
            "segments": [
              {"type": "recovery", "label": "Rest", "seconds": 10}
            ],
            "repeat": 1
          }
        ]
      }
      ''';

      // Setup mock untuk rootBundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        final key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'assets/workouts.json') {
          return ByteData.sublistView(utf8.encode(jsonData));
        }
        return null;
      });
    });

    tearDown(() {
      repository.clearCache();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    test('should load workouts from JSON', () async {
      final workouts = await repository.loadWorkouts();

      expect(workouts.length, 2);
      expect(workouts[0].id, 'test_1');
      expect(workouts[1].id, 'test_2');
    });

    test('should cache workouts', () async {
      final workouts1 = await repository.loadWorkouts();
      final workouts2 = await repository.loadWorkouts();

      expect(identical(workouts1, workouts2), true);
    });

    test('should get workout by ID', () async {
      final workout = await repository.getWorkoutById('test_1');

      expect(workout, isNotNull);
      expect(workout!.title, 'Test Workout 1');
    });

    test('should return null for non-existent ID', () async {
      final workout = await repository.getWorkoutById('non_existent');

      expect(workout, isNull);
    });

    test('should get workouts by mode', () async {
      final workouts = await repository.getWorkoutsByMode('test');

      expect(workouts.length, 2);
    });

    test('should clear cache', () async {
      await repository.loadWorkouts();
      repository.clearCache();

      // Cache should be cleared, so this will reload
      final workouts = await repository.loadWorkouts();
      expect(workouts.length, 2);
    });
  });
}
