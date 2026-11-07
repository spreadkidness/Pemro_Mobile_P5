import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    debugPrint('Token berhasil disimpan secara aman.');
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    debugPrint('Token berhasil dihapus.');
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    debugPrint('PIN berhasil disimpan secara aman.');
  }

  Future<String?> getPin() async {
    return _storage.read(key: _pinKey);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    debugPrint('Data secure storage berhasil dihapus.');
  }

  Future<bool> hasToken() async {
    return await _storage.containsKey(key: _tokenKey);
  }
}
