import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(settings.language == 'id' ? 'Bahasa Indonesia' : 'English'),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),

          // Theme
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeLabel(settings.themeMode, l10n)),
            onTap: () => _showThemeDialog(context, ref),
          ),
          const Divider(),

          // Voice Cues
          SwitchListTile(
            secondary: const Icon(Icons.record_voice_over),
            title: Text(l10n.voiceCues),
            subtitle: Text(l10n.translate('voice_cues_desc')),
            value: settings.voiceCuesEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setVoiceCues(value);
            },
          ),

          // TTS Volume (jika voice cues enabled)
          if (settings.voiceCuesEnabled) ...[
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: Text(l10n.volume),
              subtitle: Slider(
                value: settings.ttsVolume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(settings.ttsVolume * 100).toInt()}%',
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setTtsVolume(value);
                },
              ),
            ),

            // TTS Rate
            ListTile(
              leading: const Icon(Icons.speed),
              title: Text(l10n.speed),
              subtitle: Slider(
                value: settings.ttsRate,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                label: '${settings.ttsRate.toStringAsFixed(1)}x',
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setTtsRate(value);
                },
              ),
            ),
          ],

          const Divider(),

          // Haptics
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: Text(l10n.haptics),
            subtitle: Text(l10n.translate('haptics_desc')),
            value: settings.hapticsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setHaptics(value);
            },
          ),

          const Divider(),

          // Countdown
          ListTile(
            leading: const Icon(Icons.timer),
            title: Text(l10n.countdown),
            subtitle: Text('${settings.countdownSeconds} ${l10n.translate('seconds')}'),
            onTap: () => _showCountdownDialog(context, ref),
          ),

          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.translate('about')),
            subtitle: const Text('Intervals Training v1.0.0'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.translate('light');
      case ThemeMode.dark:
        return l10n.translate('dark');
      case ThemeMode.system:
        return l10n.translate('system');
    }
  }

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'id',
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showThemeDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.translate('light')),
              value: ThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.translate('dark')),
              value: ThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.translate('system')),
              value: ThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCountdownDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.countdown),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i <= 5; i++)
              RadioListTile<int>(
                title: Text('$i ${l10n.translate('seconds')}'),
                value: i,
                groupValue: settings.countdownSeconds,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier).setCountdownSeconds(value);
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Intervals Training\n\n${l10n.translate('about_text')}',
    );
  }
}
