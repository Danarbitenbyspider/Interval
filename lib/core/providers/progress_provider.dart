import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_log.dart';

/// Notifier untuk manage progress/log sesi
class ProgressNotifier extends StateNotifier<List<SessionLog>> {
  ProgressNotifier() : super([]) {
    _loadLogs();
  }

  static const String _storageKey = 'session_logs';

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final jsonList = json.decode(jsonString) as List<dynamic>;
        final logs = jsonList
            .map((j) => SessionLog.fromJson(j as Map<String, dynamic>))
            .toList();
        // Urutkan dari yang terbaru
        logs.sort((a, b) => b.date.compareTo(a.date));
        state = logs;
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((log) => log.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_storageKey, jsonString);
  }

  /// Tambah log baru
  Future<void> addLog(SessionLog log) async {
    state = [log, ...state];
    await _saveLogs();
  }

  /// Hapus log
  Future<void> deleteLog(SessionLog log) async {
    state = state.where((l) => l != log).toList();
    await _saveLogs();
  }

  /// Clear semua log
  Future<void> clearAll() async {
    state = [];
    await _saveLogs();
  }

  /// Ambil log untuk workout tertentu
  List<SessionLog> getLogsForWorkout(String workoutId) {
    return state.where((log) => log.workoutId == workoutId).toList();
  }

  /// Hitung total sesi
  int get totalSessions => state.length;

  /// Hitung total durasi (dalam detik)
  int get totalDurationSeconds {
    return state.fold<int>(0, (sum, log) => sum + log.durationSeconds);
  }
}

/// Provider untuk progress
final progressProvider = StateNotifierProvider<ProgressNotifier, List<SessionLog>>((ref) {
  return ProgressNotifier();
});
