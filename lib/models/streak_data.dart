class StreakData {
  final int currentStreak;
  final int longestStreak;
  final List<bool> weekLogins;

  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.weekLogins,
  });
}