import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'quiz_question.g.dart';

@HiveType(typeId: 1)
class QuizQuestion extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<String> options;

  @HiveField(3)
  final int correctIndex;

  @HiveField(4)
  final String explanation;

  @HiveField(5)
  final String deckId;

  QuizQuestion({
    String? id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.deckId,
  }) : id = id ?? const Uuid().v4();
}
