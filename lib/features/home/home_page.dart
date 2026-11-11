import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/workout_plan.dart';
import '../../core/providers/workout_provider.dart';
import '../detail/mode_detail_page.dart';
import '../settings/settings_page.dart';
import '../progress/progress_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressPage()),
              );
            },
            tooltip: l10n.progress,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: workoutsAsync.when(
        data: (workouts) => _buildWorkoutList(context, workouts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildWorkoutList(BuildContext context, List<WorkoutPlan> workouts) {
    final l10n = AppLocalizations.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return _WorkoutCard(workout: workout);
      },
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutPlan workout;

  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Icon berdasarkan mode
    IconData icon;
    Color iconColor;
    switch (workout.mode) {
      case 'japanese_walking':
        icon = Icons.directions_walk;
        iconColor = Colors.blue;
        break;
      case 'tabata':
        icon = Icons.fitness_center;
        iconColor = Colors.red;
        break;
      case 'mobility':
        icon = Icons.accessibility_new;
        iconColor = Colors.green;
        break;
      case 'core':
        icon = Icons.self_improvement;
        iconColor = Colors.orange;
        break;
      case 'breathing':
        icon = Icons.air;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.timer;
        iconColor = Colors.grey;
    }

    final durationMinutes = (workout.totalDurationSeconds / 60).ceil();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModeDetailPage(workout: workout),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workout.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$durationMinutes ${l10n.translate('minutes')}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
