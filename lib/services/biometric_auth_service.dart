import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  BiometricAuthService({
    LocalAuthentication? localAuthentication,
    FlutterSecureStorage? secureStorage,
  })  : _localAuthentication = localAuthentication ?? LocalAuthentication(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _biometricEnabledKey = 'biometric_enabled';

  final LocalAuthentication _localAuthentication;
  final FlutterSecureStorage _secureStorage;

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheckBiometrics =
      await _localAuthentication.canCheckBiometrics;
      final bool isDeviceSupported =
      await _localAuthentication.isDeviceSupported();
      final List<BiometricType> availableBiometrics =
      await _localAuthentication.getAvailableBiometrics();

      return (canCheckBiometrics || isDeviceSupported) &&
          availableBiometrics.isNotEmpty;
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    final String? value = await _secureStorage.read(
      key: _biometricEnabledKey,
    );

    return value == 'true';
  }

  Future<void> enableBiometric() async {
    await _secureStorage.write(
      key: _biometricEnabledKey,
      value: 'true',
    );
  }

  Future<void> disableBiometric() async {
    await _secureStorage.delete(
      key: _biometricEnabledKey,
    );
  }

  Future<bool> authenticate({
    required String reason,
  }) async {
    try {
      return await _localAuthentication.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }
}