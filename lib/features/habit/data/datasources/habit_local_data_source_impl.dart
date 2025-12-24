import 'package:compound/features/habit/data/datasources/habit_local_data_source.dart';
import 'package:compound/features/habit/data/models/habit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  static const String _boxName = 'habits_box';

  Future<Box<HabitModel>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<HabitModel>(_boxName);
    }
    return await Hive.openBox<HabitModel>(_boxName);
  }

  @override
  Future<List<HabitModel>> getAllHabits() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> addHabit(HabitModel habit) async {
    final box = await _box;
    await box.put(habit.id, habit);
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    final box = await _box;
    await box.put(habit.id, habit);
  }

  @override
  Future<void> deleteHabit(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final box = await _box;
    final habit = box.get(habitId);

    if (habit == null) {
      throw Exception('Habit not found');
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final timestamp = normalizedDate.millisecondsSinceEpoch;

    List<int> updatedTimestamps = List.from(habit.completedDatesTimestamps);

    if (updatedTimestamps.contains(timestamp)) {
      updatedTimestamps.remove(timestamp);
    } else {
      updatedTimestamps.add(timestamp);
    }

    final updatedHabit = HabitModel.fromStored(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      createdAtTimestamp: habit.createdAtTimestamp,
      completedDatesTimestamps: updatedTimestamps,
    );

    await box.put(habitId, updatedHabit);
  }
}
