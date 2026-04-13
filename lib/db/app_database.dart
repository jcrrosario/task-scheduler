import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get cnpj => text().nullable()();

  TextColumn get phone => text().nullable()();

  TextColumn get contact => text().nullable()();

  TextColumn get email => text().nullable()();

  RealColumn get hourlyRate => real().withDefault(const Constant(0))();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get clientId => integer()();

  TextColumn get title => text()();

  TextColumn get requester => text().nullable()();

  TextColumn get description => text().nullable()();

  TextColumn get doneDescription => text().nullable()();

  DateTimeColumn get date => dateTime()();

  TextColumn get time => text()();

  RealColumn get hours => real().withDefault(const Constant(0))();

  TextColumn get status => text().withDefault(const Constant('Pendente'))();

  RealColumn get clientHourlyRateSnapshot =>
      real().withDefault(const Constant(0))();

  DateTimeColumn get completedAt => dateTime().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Consultancies extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get phone => text().nullable()();

  TextColumn get cnpj => text().nullable()();

  TextColumn get stateRegistration => text().nullable()();

  TextColumn get address => text().nullable()();

  RealColumn get hourlyRate => real().withDefault(const Constant(0))();

  TextColumn get accessPassword => text().nullable()();
}

@DriftDatabase(
  tables: <Type>[
    Clients,
    Tasks,
    Consultancies,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.createTable(consultancies);
      }

      if (from < 3) {
        await migrator.addColumn(clients, clients.hourlyRate);
      }

      if (from < 4) {
        await migrator.addColumn(
          tasks,
          tasks.clientHourlyRateSnapshot,
        );
      }

      if (from < 5) {
        await migrator.addColumn(
          tasks,
          tasks.completedAt,
        );
      }

      if (from < 6) {
        await migrator.addColumn(
          tasks,
          tasks.sortOrder,
        );

        final List<QueryRow> existingTasks = await customSelect(
          '''
              SELECT id
              FROM tasks
              ORDER BY date ASC, time ASC, id ASC
              ''',
        ).get();

        for (int index = 0; index < existingTasks.length; index++) {
          final int taskId = existingTasks[index].read<int>('id');

          await customStatement(
            '''
                UPDATE tasks
                SET sort_order = ?
                WHERE id = ?
                ''',
            <Object>[index + 1, taskId],
          );
        }
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(
      p.join(directory.path, 'task_scheduler.sqlite'),
    );

    return NativeDatabase(file);
  });
}