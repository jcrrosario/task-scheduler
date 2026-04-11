import 'package:drift/drift.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/services/app_database_service.dart';

class ClientRepository {
  ClientRepository({AppDatabase? database})
      : _database = database ?? AppDatabaseService.database;

  final AppDatabase _database;

  Future<List<Client>> getAll() async {
    final query = _database.select(_database.clients)
      ..orderBy([
            (table) => OrderingTerm(expression: table.name),
      ]);

    return query.get();
  }

  Future<List<Client>> search(String term) async {
    final String normalizedTerm = term.trim();

    if (normalizedTerm.isEmpty) {
      return getAll();
    }

    final String filter = '%$normalizedTerm%';

    final query = _database.select(_database.clients)
      ..where(
            (table) =>
        table.name.like(filter) | table.cnpj.like(filter),
      )
      ..orderBy([
            (table) => OrderingTerm(expression: table.name),
      ]);

    return query.get();
  }

  Future<int> create({
    required String name,
    String? cnpj,
    String? phone,
    String? contact,
    String? email,
  }) async {
    return _database.into(_database.clients).insert(
      ClientsCompanion.insert(
        name: name.trim(),
        cnpj: Value(_normalizeNullable(cnpj)),
        phone: Value(_normalizeNullable(phone)),
        contact: Value(_normalizeNullable(contact)),
        email: Value(_normalizeNullable(email)),
      ),
    );
  }

  Future<bool> update({
    required int id,
    required String name,
    String? cnpj,
    String? phone,
    String? contact,
    String? email,
  }) async {
    final rows = await (_database.update(_database.clients)
      ..where((table) => table.id.equals(id)))
        .write(
      ClientsCompanion(
        name: Value(name.trim()),
        cnpj: Value(_normalizeNullable(cnpj)),
        phone: Value(_normalizeNullable(phone)),
        contact: Value(_normalizeNullable(contact)),
        email: Value(_normalizeNullable(email)),
      ),
    );

    return rows > 0;
  }

  Future<bool> delete(int id) async {
    final rows = await (_database.delete(_database.clients)
      ..where((table) => table.id.equals(id)))
        .go();

    return rows > 0;
  }

  String? _normalizeNullable(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }
}