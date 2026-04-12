class DashboardSummary {
  DashboardSummary({
    required this.totalTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.completedHours,
    required this.totalCompletedHoursValue,
    required this.quarterLabel,
    required this.quarterBars,
  });

  final int totalTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int completedTasks;
  final double completedHours;
  final double totalCompletedHoursValue;
  final String quarterLabel;
  final List<DashboardQuarterBar> quarterBars;
}

class DashboardQuarterBar {
  DashboardQuarterBar({
    required this.month,
    required this.monthLabel,
    required this.value,
  });

  final int month;
  final String monthLabel;
  final double value;
}