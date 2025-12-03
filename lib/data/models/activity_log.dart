import 'package:hive/hive.dart';

part 'activity_log.g.dart';

@HiveType(typeId: 3)
class ActivityLog extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  int cardsReviewed;

  @HiveField(2)
  int questionsAnswered;

  ActivityLog({
    required this.date,
    this.cardsReviewed = 0,
    this.questionsAnswered = 0,
  });
}
