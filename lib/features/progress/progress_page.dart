import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/session_log.dart';
import '../../core/providers/progress_provider.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(progressProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final totalSessions = logs.length;
    final totalDurationSeconds = logs.fold<int>(0, (sum, log) => sum + log.durationSeconds);
    final totalHours = totalDurationSeconds / 3600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progress),
        actions: [
          if (logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearConfirmation(context, ref),
              tooltip: l10n.translate('clear_all'),
            ),
        ],
      ),
      body: logs.isEmpty
          ? _buildEmptyState(context, l10n)
          : Column(
              children: [
                // Summary stats
                Container(
                  padding: const EdgeInsets.all(16),
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCard(
                        icon: Icons.fitness_center,
                        label: l10n.totalSessions,
                        value: totalSessions.toString(),
                      ),
                      _StatCard(
                        icon: Icons.access_time,
                        label: l10n.totalDuration,
                        value: '${totalHours.toStringAsFixed(1)}h',
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Log list
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _SessionLogTile(
                        log: log,
                        onDelete: () => _deleteLog(context, ref, log),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('no_sessions_yet'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLog(BuildContext context, WidgetRef ref, SessionLog log) async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.translate('delete_session_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (result == true) {
      await ref.read(progressProvider.notifier).deleteLog(log);
    }
  }

  Future<void> _showClearConfirmation(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('clear_all')),
        content: Text(l10n.translate('clear_all_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.translate('clear_all')),
          ),
        ],
      ),
    );

    if (result == true) {
      await ref.read(progressProvider.notifier).clearAll();
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _SessionLogTile extends StatelessWidget {
  final SessionLog log;
  final VoidCallback onDelete;

  const _SessionLogTile({
    required this.log,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    final durationMinutes = (log.durationSeconds / 60).ceil();

    return Dismissible(
      key: Key(log.date.toIso8601String()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(log.workoutTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(log.date)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: 14, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5)),
                const SizedBox(width: 4),
                Text(
                  '$durationMinutes menit',
                  style: theme.textTheme.bodySmall,
                ),
                if (log.level != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.level!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: log.rpe != null
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getRpeColor(log.rpe!).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'RPE ${log.rpe}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getRpeColor(log.rpe!),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Color _getRpeColor(int rpe) {
    if (rpe <= 3) return Colors.green;
    if (rpe <= 6) return Colors.orange;
    return Colors.red;
  }
}
