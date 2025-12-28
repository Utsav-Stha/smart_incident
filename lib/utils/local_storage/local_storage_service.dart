import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_incident/feature/common/constants/local_storage_keys.dart';

class LocalStorageService {
  static const _storage = FlutterSecureStorage();

  static final String _keyEmail = LocalStorageKeys.emailKey;
  static final String _keyPassword = LocalStorageKeys.passwordKey;
  static final String _keyRememberMe = LocalStorageKeys.rememberMeKey;

  static Future<void> saveCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
    await _storage.write(key: _keyRememberMe, value: rememberMe.toString());
  }

  static Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: _keyEmail);
    final password = await _storage.read(key: _keyPassword);
    final rememberMe = await _storage.read(key: _keyRememberMe);
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyPassword);
    await _storage.delete(key: _keyRememberMe);
  }
}
