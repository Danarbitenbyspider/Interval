import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model untuk settings aplikasi
class AppSettings {
  final String language; // 'id' atau 'en'
  final ThemeMode themeMode;
  final bool voiceCuesEnabled;
  final bool hapticsEnabled;
  final double ttsVolume; // 0.0 - 1.0
  final double ttsRate; // 0.5 - 2.0
  final int countdownSeconds; // 3-2-1 sebelum mulai

  const AppSettings({
    this.language = 'id',
    this.themeMode = ThemeMode.system,
    this.voiceCuesEnabled = true,
    this.hapticsEnabled = true,
    this.ttsVolume = 0.8,
    this.ttsRate = 1.0,
    this.countdownSeconds = 3,
  });

  AppSettings copyWith({
    String? language,
    ThemeMode? themeMode,
    bool? voiceCuesEnabled,
    bool? hapticsEnabled,
    double? ttsVolume,
    double? ttsRate,
    int? countdownSeconds,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      voiceCuesEnabled: voiceCuesEnabled ?? this.voiceCuesEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      ttsVolume: ttsVolume ?? this.ttsVolume,
      ttsRate: ttsRate ?? this.ttsRate,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'themeMode': themeMode.name,
      'voiceCuesEnabled': voiceCuesEnabled,
      'hapticsEnabled': hapticsEnabled,
      'ttsVolume': ttsVolume,
      'ttsRate': ttsRate,
      'countdownSeconds': countdownSeconds,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: json['language'] as String? ?? 'id',
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      voiceCuesEnabled: json['voiceCuesEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      ttsVolume: (json['ttsVolume'] as num?)?.toDouble() ?? 0.8,
      ttsRate: (json['ttsRate'] as num?)?.toDouble() ?? 1.0,
      countdownSeconds: json['countdownSeconds'] as int? ?? 3,
    );
  }
}

/// Notifier untuk manage settings
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('app_settings');
    if (jsonString != null) {
      try {
        final json = Map<String, dynamic>.from(
          // ignore: avoid_dynamic_calls
          const {},
        );
        // Manual parsing untuk safety
        state = AppSettings(
          language: prefs.getString('language') ?? 'id',
          themeMode: ThemeMode.values.firstWhere(
            (e) => e.name == prefs.getString('themeMode'),
            orElse: () => ThemeMode.system,
          ),
          voiceCuesEnabled: prefs.getBool('voiceCuesEnabled') ?? true,
          hapticsEnabled: prefs.getBool('hapticsEnabled') ?? true,
          ttsVolume: prefs.getDouble('ttsVolume') ?? 0.8,
          ttsRate: prefs.getDouble('ttsRate') ?? 1.0,
          countdownSeconds: prefs.getInt('countdownSeconds') ?? 3,
        );
      } catch (e) {
        // Fallback ke default
        state = const AppSettings();
      }
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', state.language);
    await prefs.setString('themeMode', state.themeMode.name);
    await prefs.setBool('voiceCuesEnabled', state.voiceCuesEnabled);
    await prefs.setBool('hapticsEnabled', state.hapticsEnabled);
    await prefs.setDouble('ttsVolume', state.ttsVolume);
    await prefs.setDouble('ttsRate', state.ttsRate);
    await prefs.setInt('countdownSeconds', state.countdownSeconds);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
    _saveSettings();
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveSettings();
  }

  void setVoiceCues(bool enabled) {
    state = state.copyWith(voiceCuesEnabled: enabled);
    _saveSettings();
  }

  void setHaptics(bool enabled) {
    state = state.copyWith(hapticsEnabled: enabled);
    _saveSettings();
  }

  void setTtsVolume(double volume) {
    state = state.copyWith(ttsVolume: volume);
    _saveSettings();
  }

  void setTtsRate(double rate) {
    state = state.copyWith(ttsRate: rate);
    _saveSettings();
  }

  void setCountdownSeconds(int seconds) {
    state = state.copyWith(countdownSeconds: seconds);
    _saveSettings();
  }
}

/// Provider untuk settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});
