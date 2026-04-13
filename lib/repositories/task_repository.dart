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
          (item.task.requester ?? '').toLowerCase().contains(
            normalizedSearch,
          ) ||
          (item.task.description ?? '').toLowerCase().contains(
            normalizedSearch,
          );

      return matchesClient && matchesStatus && matchesSearch;
    }).toList();

    items.sort((TaskListItem a, TaskListItem b) {
      final int sortOrderCompare = a.task.sortOrder.compareTo(b.task.sortOrder);
      if (sortOrderCompare != 0) {
        return sortOrderCompare;
      }

      final int dateCompare = a.task.date.compareTo(b.task.date);
      if (dateCompare != 0) {
        return dateCompare;
      }

      final int timeCompare = a.task.time.compareTo(b.task.time);
      if (timeCompare != 0) {
        return timeCompare;
      }

      return a.task.id.compareTo(b.task.id);
    });

    return items;
  }

  Future<List<TaskListItem>> getTasksForReport({
    required int clientId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final DateTime normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      0,
      0,
      0,
    );

    final DateTime normalizedEnd = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    );

    final List<Task> tasks = await (_database.select(_database.tasks)
      ..where((Tasks table) => table.clientId.equals(clientId))
      ..where((Tasks table) => table.date.isBiggerOrEqualValue(normalizedStart))
      ..where((Tasks table) => table.date.isSmallerOrEqualValue(normalizedEnd)))
        .get();

    final Client? client = await (_database.select(_database.clients)
      ..where((Clients table) => table.id.equals(clientId)))
        .getSingleOrNull();

    final String clientName = client?.name ?? 'Cliente não encontrado';

    final List<TaskListItem> items = tasks
        .map(
          (Task task) => TaskListItem(
        task: task,
        clientName: clientName,
      ),
    )
        .toList();

    items.sort((TaskListItem a, TaskListItem b) {
      final int dateCompare = a.task.date.compareTo(b.task.date);
      if (dateCompare != 0) {
        return dateCompare;
      }

      final int timeCompare = a.task.time.compareTo(b.task.time);
      if (timeCompare != 0) {
        return timeCompare;
      }

      return a.task.id.compareTo(b.task.id);
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
    final String normalizedStatus =
    status.trim().isEmpty ? 'Pendente' : status.trim();

    final double clientHourlyRateSnapshot = await _resolveHourlyRateSnapshot(
      clientId: clientId,
      status: normalizedStatus,
    );

    final DateTime? completedAt = _resolveCompletedAtForCreate(
      status: normalizedStatus,
    );

    final int nextSortOrder = await _getNextSortOrder();

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
        status: Value(normalizedStatus),
        clientHourlyRateSnapshot: Value(clientHourlyRateSnapshot),
        completedAt: Value(completedAt),
        sortOrder: Value(nextSortOrder),
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
    final Task? existingTask = await (_database.select(_database.tasks)
      ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    final String normalizedStatus =
    status.trim().isEmpty ? 'Pendente' : status.trim();

    final double clientHourlyRateSnapshot = await _resolveHourlyRateSnapshot(
      clientId: clientId,
      status: normalizedStatus,
      existingSnapshot: existingTask?.clientHourlyRateSnapshot ?? 0,
    );

    final DateTime? completedAt = _resolveCompletedAtForUpdate(
      status: normalizedStatus,
      existingCompletedAt: existingTask?.completedAt,
    );

    final int rows = await (_database.update(_database.tasks)
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
        status: Value(normalizedStatus),
        clientHourlyRateSnapshot: Value(clientHourlyRateSnapshot),
        completedAt: Value(completedAt),
        sortOrder: Value(existingTask?.sortOrder ?? 0),
      ),
    );

    return rows > 0;
  }

  Future<bool> delete(int id) async {
    final int rows = await (_database.delete(_database.tasks)
      ..where((table) => table.id.equals(id)))
        .go();

    return rows > 0;
  }

  Future<void> updatePriorityOrder({
    required List<int> orderedVisibleTaskIds,
  }) async {
    final List<Task> allTasks = await (_database.select(_database.tasks)).get();

    final Map<int, Task> tasksById = <int, Task>{
      for (final Task task in allTasks) task.id: task,
    };

    final List<Task> prioritizedTasks = orderedVisibleTaskIds
        .map((int id) => tasksById[id])
        .whereType<Task>()
        .toList();

    final Set<int> prioritizedIds = orderedVisibleTaskIds.toSet();

    final List<Task> remainingTasks = allTasks
      ..removeWhere((Task task) => prioritizedIds.contains(task.id))
      ..sort((Task a, Task b) {
        final int sortOrderCompare = a.sortOrder.compareTo(b.sortOrder);
        if (sortOrderCompare != 0) {
          return sortOrderCompare;
        }

        final int dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) {
          return dateCompare;
        }

        final int timeCompare = a.time.compareTo(b.time);
        if (timeCompare != 0) {
          return timeCompare;
        }

        return a.id.compareTo(b.id);
      });

    final List<Task> finalOrder = <Task>[
      ...prioritizedTasks,
      ...remainingTasks,
    ];

    await _database.batch((Batch batch) {
      for (int index = 0; index < finalOrder.length; index++) {
        final Task task = finalOrder[index];

        batch.update(
          _database.tasks,
          TasksCompanion(
            sortOrder: Value(index + 1),
          ),
          where: (Tasks table) => table.id.equals(task.id),
        );
      }
    });
  }

  Future<int> _getNextSortOrder() async {
    final List<Task> tasks = await (_database.select(_database.tasks)).get();

    if (tasks.isEmpty) {
      return 1;
    }

    final int maxSortOrder = tasks
        .map((Task task) => task.sortOrder)
        .fold<int>(0, (int previous, int current) {
      return current > previous ? current : previous;
    });

    return maxSortOrder + 1;
  }

  Future<double> _resolveHourlyRateSnapshot({
    required int clientId,
    required String status,
    double existingSnapshot = 0,
  }) async {
    final String normalizedStatus = status.trim().toLowerCase();

    if (normalizedStatus != 'concluído') {
      return existingSnapshot;
    }

    final Client? client = await (_database.select(_database.clients)
      ..where((table) => table.id.equals(clientId)))
        .getSingleOrNull();

    return client?.hourlyRate ?? 0;
  }

  DateTime? _resolveCompletedAtForCreate({
    required String status,
  }) {
    final String normalizedStatus = status.trim().toLowerCase();

    if (normalizedStatus == 'concluído') {
      return DateTime.now();
    }

    return null;
  }

  DateTime? _resolveCompletedAtForUpdate({
    required String status,
    required DateTime? existingCompletedAt,
  }) {
    final String normalizedStatus = status.trim().toLowerCase();

    if (normalizedStatus == 'concluído') {
      return existingCompletedAt ?? DateTime.now();
    }

    return null;
  }

  String? _normalizeNullable(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }
}