class Habit {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    List<DateTime>? completedDates,
  }) : completedDates = completedDates ?? [];

  bool isCompletedToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return completedDates.any((date) {
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    });
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates =
        completedDates
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime expectedDate = DateTime.now();

    for (final completedDate in sortedDates) {
      final normalizedExpected = DateTime(
        expectedDate.year,
        expectedDate.month,
        expectedDate.day,
      );

      if (completedDate.isAtSameMomentAs(normalizedExpected)) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else if (completedDate.isAfter(normalizedExpected)) {
        continue;
      } else {
        break;
      }
    }

    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates =
        completedDates
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet()
            .toList()
          ..sort((a, b) => a.compareTo(b));

    int maxStreak = 0;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
      } else {
        maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
        currentStreak = 1;
      }
    }

    maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
    return maxStreak;
  }

  Habit copyWith({
    String? name,
    String? description,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdAt == createdAt &&
        _listsEqual(other.completedDates, completedDates);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      createdAt,
      Object.hashAll(completedDates),
    );
  }

  bool _listsEqual(List<DateTime> a, List<DateTime> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      final da = DateTime(a[i].year, a[i].month, a[i].day);
      final db = DateTime(b[i].year, b[i].month, b[i].day);
      if (da != db) return false;
    }
    return true;
  }
}
