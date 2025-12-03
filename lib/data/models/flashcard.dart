import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String front;

  @HiveField(2)
  String back;

  @HiveField(3)
  bool isLearned;

  @HiveField(4)
  final String deckId;

  Flashcard({
    String? id,
    required this.front,
    required this.back,
    this.isLearned = false,
    required this.deckId,
  }) : id = id ?? const Uuid().v4();
}
