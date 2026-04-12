class DashboardSummary {
  DashboardSummary({
    required this.totalTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.completedHours,
    required this.totalCompletedHoursValue,
  });

  final int totalTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int completedTasks;
  final double completedHours;
  final double totalCompletedHoursValue;
}