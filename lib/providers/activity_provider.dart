import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/activity_log.dart';
import '../data/services/storage_service.dart';
import 'study_provider.dart';

class ActivityState {
  final List<ActivityLog> logs;
  final int currentStreak;

  ActivityState({this.logs = const [], this.currentStreak = 0});
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final StorageService _storage;

  ActivityNotifier(this._storage) : super(ActivityState()) {
    loadActivity();
  }

  void loadActivity() {
    final logs = _storage.getActivityLogs();
    // Calculate streak logic here (simplified for now)
    int streak = 0;
    // Sort logs by date desc
    logs.sort((a, b) => b.date.compareTo(a.date));
    
    // Simple streak calculation
    if (logs.isNotEmpty) {
      // Check if last log was today or yesterday
      final last = logs.first;
      final now = DateTime.now();
      final diff = now.difference(last.date).inDays;
      if (diff <= 1) {
        streak = logs.length; // Placeholder logic
      }
    }

    state = ActivityState(logs: logs, currentStreak: streak);
  }

  Future<void> logProgress({int cards = 0, int questions = 0}) async {
    await _storage.logActivity(cards: cards, questions: questions);
    loadActivity();
  }
}

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ActivityNotifier(storage);
});
