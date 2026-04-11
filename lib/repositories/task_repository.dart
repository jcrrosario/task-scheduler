import 'package:drift/drift.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/models/task_list_item.dart';
import 'package:task_scheduler/services/app_database_service.dart';

class TaskRepository {
  TaskRepository({AppDatabase? database})
      : _database = database ?? AppDatabaseService.database;

  final AppDatabase _database;

  Future<List<TaskListItem>> getAll({
    String search = '',
    int? clientId,
    String? status,
  }) async {
    final List<Task> tasks = await (_database.select(_database.tasks)).get();
    final List<Client> clients =
    await (_database.select(_database.clients)).get();

    final Map<int, Client> clientsMap = <int, Client>{
      for (final Client client in clients) client.id: client,
    };

    final String normalizedSearch = search.trim().toLowerCase();
    final String normalizedStatus = (status ?? '').trim().toLowerCase();

    final List<TaskListItem> items = tasks.map((Task task) {
      final Client? client = clientsMap[task.clientId];

      return TaskListItem(
        task: task,
        clientName: client?.name ?? 'Cliente não encontrado',
      );
    }).where((TaskListItem item) {
      final bool matchesClient =
          clientId == null || item.task.clientId == clientId;

      final bool matchesStatus = normalizedStatus.isEmpty ||
          item.task.status.toLowerCase() == normalizedStatus;

      if (normalizedSearch.isEmpty) {
        return matchesClient && matchesStatus;
      }

      final bool matchesSearch = item.task.title.toLowerCase().contains(
        normalizedSearch,
      ) ||
          item.clientName.toLowerCase().contains(normalizedSearch) ||
          (item.task.requester ?? '').toLowerCase().contains(normalizedSearch) ||
          (item.task.description ?? '')
              .toLowerCase()
              .contains(normalizedSearch);

      return matchesClient && matchesStatus && matchesSearch;
    }).toList();

    items.sort((TaskListItem a, TaskListItem b) {
      final int clientCompare = a.clientName.toLowerCase().compareTo(
        b.clientName.toLowerCase(),
      );

      if (clientCompare != 0) {
        return clientCompare;
      }

      final int dateCompare = a.task.date.compareTo(b.task.date);
      if (dateCompare != 0) {
        return dateCompare;
      }

      return a.task.time.compareTo(b.task.time);
    });

    return items;
  }

  Future<int> create({
    required int clientId,
    required String title,
    required DateTime date,
    required String time,
    String? requester,
    String? description,
    String? doneDescription,
    double hours = 0,
    String status = 'Pendente',
  }) async {
    return _database.into(_database.tasks).insert(
      TasksCompanion.insert(
        clientId: clientId,
        title: title.trim(),
        date: date,
        time: time.trim(),
        requester: Value(_normalizeNullable(requester)),
        description: Value(_normalizeNullable(description)),
        doneDescription: Value(_normalizeNullable(doneDescription)),
        hours: Value(hours),
        status: Value(status.trim().isEmpty ? 'Pendente' : status.trim()),
      ),
    );
  }

  Future<bool> update({
    required int id,
    required int clientId,
    required String title,
    required DateTime date,
    required String time,
    String? requester,
    String? description,
    String? doneDescription,
    double hours = 0,
    String status = 'Pendente',
  }) async {
    final rows = await (_database.update(_database.tasks)
      ..where((table) => table.id.equals(id)))
        .write(
      TasksCompanion(
        clientId: Value(clientId),
        title: Value(title.trim()),
        date: Value(date),
        time: Value(time.trim()),
        requester: Value(_normalizeNullable(requester)),
        description: Value(_normalizeNullable(description)),
        doneDescription: Value(_normalizeNullable(doneDescription)),
        hours: Value(hours),
        status: Value(status.trim().isEmpty ? 'Pendente' : status.trim()),
      ),
    );

    return rows > 0;
  }

  Future<bool> delete(int id) async {
    final rows = await (_database.delete(_database.tasks)
      ..where((table) => table.id.equals(id)))
        .go();

    return rows > 0;
  }

  String? _normalizeNullable(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }
}