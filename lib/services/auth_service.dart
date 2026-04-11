import 'package:task_scheduler/core/constants/app_strings.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/repositories/consultancy_repository.dart';

class AuthService {
  AuthService({
    ConsultancyRepository? consultancyRepository,
  }) : _consultancyRepository =
      consultancyRepository ?? ConsultancyRepository();

  final ConsultancyRepository _consultancyRepository;

  Future<bool> validateLogin({
    required String username,
    required String password,
  }) async {
    if (username.trim() != AppStrings.defaultUsername) {
      return false;
    }

    final Consultancy? consultancy =
    await _consultancyRepository.getConsultancy();

    final String savedPassword = (consultancy?.accessPassword ?? '').trim();

    final String expectedPassword = savedPassword.isEmpty
        ? AppStrings.defaultPassword
        : savedPassword;

    return password.trim() == expectedPassword;
  }

  Future<String> getExpectedPassword() async {
    final Consultancy? consultancy =
    await _consultancyRepository.getConsultancy();

    final String savedPassword = (consultancy?.accessPassword ?? '').trim();

    if (savedPassword.isEmpty) {
      return AppStrings.defaultPassword;
    }

    return savedPassword;
  }
}