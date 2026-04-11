import 'package:task_scheduler/db/app_database.dart';

class TaskListItem {
  TaskListItem({
    required this.task,
    required this.clientName,
  });

  final Task task;
  final String clientName;
}