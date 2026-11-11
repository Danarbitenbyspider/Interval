import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sistem lokalisasi sederhana menggunakan JSON
class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    try {
      final jsonString = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      // Fallback ke bahasa Indonesia jika gagal
      final jsonString = await rootBundle.loadString('assets/i18n/id.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Helper methods untuk key yang sering dipakai
  String get appTitle => translate('app_title');
  String get start => translate('start');
  String get pause => translate('pause');
  String get resume => translate('resume');
  String get stop => translate('stop');
  String get next => translate('next');
  String get previous => translate('previous');
  String get settings => translate('settings');
  String get progress => translate('progress');
  String get home => translate('home');
  String get language => translate('language');
  String get theme => translate('theme');
  String get voiceCues => translate('voice_cues');
  String get haptics => translate('haptics');
  String get volume => translate('volume');
  String get speed => translate('speed');
  String get countdown => translate('countdown');
  String get level => translate('level');
  String get beginner => translate('beginner');
  String get intermediate => translate('intermediate');
  String get advanced => translate('advanced');
  String get duration => translate('duration');
  String get complete => translate('complete');
  String get workoutComplete => translate('workout_complete');
  String get ready => translate('ready');
  String get sessionLog => translate('session_log');
  String get totalSessions => translate('total_sessions');
  String get totalDuration => translate('total_duration');
  String get rpe => translate('rpe');
  String get notes => translate('notes');
  String get delete => translate('delete');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get close => translate('close');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['id', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
