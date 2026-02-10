enum TimeFilter { thisWeek, lastWeek, thisMonth, lastMonth, thisYear, lastYear }

const Map<TimeFilter, String> filterLabels = {
    TimeFilter.thisWeek: "This Week",
    TimeFilter.lastWeek: "Last Week",
    TimeFilter.thisMonth: "This Month",
    TimeFilter.lastMonth: "Last Month",
    TimeFilter.thisYear: "This Year",
    TimeFilter.lastYear: "Last Year",
  };