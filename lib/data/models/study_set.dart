import 'package:hive/hive.dart';
import 'flashcard.dart';
import 'quiz_question.dart';
import 'package:uuid/uuid.dart';

part 'study_set.g.dart';

@HiveType(typeId: 2)
class StudySet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final List<Flashcard> flashcards;

  @HiveField(4)
  final List<QuizQuestion> questions;

  StudySet({
    String? id,
    required this.name,
    required this.createdAt,
    required this.flashcards,
    required this.questions,
  }) : id = id ?? const Uuid().v4();
}
