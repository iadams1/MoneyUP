import '/features/budgettracker/ui/time_filter.dart';

class TimeRange {
  final DateTime start;
  final DateTime end;
  const TimeRange({required this.start, required this.end});
}

TimeRange getTimeRange(TimeFilter filter, DateTime now) {
  late DateTime start;
  late DateTime end;

  switch (filter) {
      case TimeFilter.thisWeek:
        start = now.subtract(Duration(days: now.weekday - 1));
        end = DateTime(now.year, now.month, now.day + 1);
        break;

      case TimeFilter.lastWeek:
        final lastWeekEnd = now.subtract(Duration(days: now.weekday));
        start = lastWeekEnd.subtract(Duration(days: 6));
        end = DateTime(
          lastWeekEnd.year,
          lastWeekEnd.month,
          lastWeekEnd.day + 1,
        );
        break;

      case TimeFilter.thisMonth:
        start = DateTime(now.year, now.month, 1);
        end = now.add(Duration(days: 1));
        break;

      case TimeFilter.lastMonth:
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 1);
        break;

      case TimeFilter.thisYear:
        start = DateTime(now.year, 1, 1);
        end = now.add(Duration(days: 1));
        break;
      
      case TimeFilter.lastYear:
        start = DateTime(now.year - 1, 1, 1);
        end = now.add(Duration(days: 1));
        break;
    }

    return TimeRange(start: start, end: end);
}