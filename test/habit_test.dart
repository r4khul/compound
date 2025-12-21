import 'package:compound/features/habit/domain/entities/habit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Habit Entity', () {
    late Habit habit;

    setUp(() {
      habit = Habit(
        id: '1',
        name: 'Drink Water',
        createdAt: DateTime(2025, 1, 1),
      );
    });

    test('should return 0 streak when no completions', () {
      expect(habit.currentStreak, 0);
      expect(habit.longestStreak, 0);
    });

    test('should calculate current streak correctly (today + yesterday)', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      final completedHabit = habit.copyWith(
        completedDates: [today, yesterday],
      );

      expect(completedHabit.currentStreak, 2);
      expect(completedHabit.isCompletedToday(), true);
    });

    test('current streak should break on gap', () {
      final today = DateTime.now();
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final completedHabit = habit.copyWith(
        completedDates: [today, twoDaysAgo],
      );

      expect(completedHabit.currentStreak, 1);
    });

    test('longest streak should track historical max', () {
      final dates = [
        DateTime(2025, 12, 1),
        DateTime(2025, 12, 2),
        DateTime(2025, 12, 3),
        DateTime(2025, 12, 5), 
        DateTime(2025, 12, 6),
        DateTime(2025, 12, 7),
        DateTime(2025, 12, 8),
        DateTime(2025, 12, 9), 
      ];

      final completedHabit = habit.copyWith(completedDates: dates);
      expect(completedHabit.longestStreak, 5);
    });

    test('isCompletedToday should handle timezones correctly', () {
      final todayMidnight = DateTime.now();
      final todayNoon = todayMidnight.add(const Duration(hours: 12));

      final completedHabit = habit.copyWith(completedDates: [todayNoon]);
      expect(completedHabit.isCompletedToday(), true);
    });
  });
}