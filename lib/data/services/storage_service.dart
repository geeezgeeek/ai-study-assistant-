import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard.dart';
import '../models/quiz_question.dart';
import '../models/study_set.dart';
import '../models/activity_log.dart';

class StorageService {
  static const String studySetBoxName = 'study_sets';
  static const String activityBoxName = 'activity_logs';

  Future<void> init() async {
    // Register Adapters
    Hive.registerAdapter(FlashcardAdapter());
    Hive.registerAdapter(QuizQuestionAdapter());
    Hive.registerAdapter(StudySetAdapter());
    Hive.registerAdapter(ActivityLogAdapter());

    // Open Boxes
    await Hive.openBox<StudySet>(studySetBoxName);
    await Hive.openBox<ActivityLog>(activityBoxName);
  }

  // Study Sets
  List<StudySet> getStudySets() {
    final box = Hive.box<StudySet>(studySetBoxName);
    return box.values.toList().cast<StudySet>();
  }

  Future<void> saveStudySet(StudySet set) async {
    final box = Hive.box<StudySet>(studySetBoxName);
    await box.put(set.id, set);
  }

  Future<void> deleteStudySet(String id) async {
    final box = Hive.box<StudySet>(studySetBoxName);
    await box.delete(id);
  }

  // Activity Logs
  List<ActivityLog> getActivityLogs() {
    final box = Hive.box<ActivityLog>(activityBoxName);
    return box.values.toList().cast<ActivityLog>();
  }

  Future<void> logActivity({int cards = 0, int questions = 0}) async {
    final box = Hive.box<ActivityLog>(activityBoxName);
    final today = DateTime.now();
    final key = "${today.year}-${today.month}-${today.day}";
    
    ActivityLog? log = box.get(key);
    if (log == null) {
      log = ActivityLog(date: today, cardsReviewed: cards, questionsAnswered: questions);
    } else {
      log.cardsReviewed += cards;
      log.questionsAnswered += questions;
    }
    await box.put(key, log);
  }
}
