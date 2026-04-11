import 'package:task_scheduler/models/dashboard_summary.dart';
import 'package:task_scheduler/repositories/task_repository.dart';

class DashboardRepository {
  DashboardRepository({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository();

  final TaskRepository _taskRepository;

  Future<DashboardSummary> getSummary() async {
    final items = await _taskRepository.getAll();

    int totalTasks = items.length;
    int pendingTasks = 0;
    int inProgressTasks = 0;
    int completedTasks = 0;
    double totalHours = 0;

    for (final item in items) {
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