import 'package:compound/features/habit/domain/entities/habit.dart';
import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends Habit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final int createdAtTimestamp;

  @HiveField(4)
  final List<int> completedDatesTimestamps;

  HabitModel({
    required this.id,
    required this.name,
    this.description,
    required DateTime createdAt,
    required List<DateTime> completedDates,
  }) : createdAtTimestamp = createdAt.millisecondsSinceEpoch,
       completedDatesTimestamps = completedDates
           .map((date) => date.millisecondsSinceEpoch)
           .toList(),
       super(
         id: id,
         name: name,
         description: description,
         createdAt: createdAt,
         completedDates: completedDates,
       );

  // Factory to create from stored data
  factory HabitModel.fromStored({
    required String id,
    required String name,
    String? description,
    required int createdAtTimestamp,
    required List<int> completedDatesTimestamps,
  }) {
    return HabitModel(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp),
      completedDates: completedDatesTimestamps
          .map((ts) => DateTime.fromMillisecondsSinceEpoch(ts))
          .toList(),
    );
  }

  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp),
      completedDates: completedDatesTimestamps
          .map((ts) => DateTime.fromMillisecondsSinceEpoch(ts))
          .toList(),
    );
  }

  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      createdAt: habit.createdAt,
      completedDates: habit.completedDates,
    );
  }
}
