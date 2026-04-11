import 'package:drift/drift.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/services/app_database_service.dart';

class ConsultancyRepository {
  ConsultancyRepository({AppDatabase? database})
      : _database = database ?? AppDatabaseService.database;

  final AppDatabase _database;

  Future<Consultancy?> getConsultancy() async {
    final query = _database.select(_database.consultancies)
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<void> save({
    required String name,
    required String email,
    required String phone,
    required String cnpj,
    required String stateRegistration,
    required String address,
    required double hourlyRate,
    required String accessPassword,
  }) async {
    final Consultancy? existing = await getConsultancy();

    final companion = ConsultanciesCompanion(
      name: Value(_normalizeNullable(name)),
      email: Value(_normalizeNullable(email)),
      phone: Value(_normalizeNullable(phone)),
      cnpj: Value(_normalizeNullable(cnpj)),
      stateRegistration: Value(_normalizeNullable(stateRegistration)),
      address: Value(_normalizeNullable(address)),
      hourlyRate: Value(hourlyRate),
      accessPassword: Value(_normalizeNullable(accessPassword)),
    );

    if (existing == null) {
      await _database.into(_database.consultancies).insert(companion);
      return;
    }

    await (_database.update(_database.consultancies)
      ..where((table) => table.id.equals(existing.id)))
        .write(companion);
  }

  String? _normalizeNullable(String? value) {
    final String normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }
}