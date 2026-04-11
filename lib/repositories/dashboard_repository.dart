import 'package:task_scheduler/models/dashboard_summary.dart';
import 'package:task_scheduler/repositories/task_repository.dart';

class DashboardRepository {
  DashboardRepository({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository();

  final TaskRepository _taskRepository;

  Future<List<int>> getAvailableYears() async {
    final items = await _taskRepository.getAll();

    final Set<int> years = <int>{};

    for (final item in items) {
      years.add(item.task.date.year);
    }

    final List<int> sortedYears = years.toList()..sort((a, b) => b.compareTo(a));

    return sortedYears;
  }

  Future<DashboardSummary> getSummary({
    int? month,
    int? year,
  }) async {
    final items = await _taskRepository.getAll();

    final filteredItems = items.where((item) {
      final DateTime taskDate = item.task.date;

      final bool matchesYear = year == null || taskDate.year == year;
      final bool matchesMonth = month == null || taskDate.month == month;

      return matchesYear && matchesMonth;
    }).toList();

    int totalTasks = filteredItems.length;
    int pendingTasks = 0;
    int inProgressTasks = 0;
    int completedTasks = 0;
    double totalHours = 0;

    for (final item in filteredItems) {
      final String status = item.task.status.trim().toLowerCase();

      if (status == 'pendente') {
        pendingTasks++;
      } else if (status == 'em andamento') {
        inProgressTasks++;
      } else if (status == 'concluído') {
        completedTasks++;
      }

      totalHours += item.task.hours;
    }

    return DashboardSummary(
      totalTasks: totalTasks,
      pendingTasks: pendingTasks,
      inProgressTasks: inProgressTasks,
      completedTasks: completedTasks,
      totalHours: totalHours,
    );
  }
}