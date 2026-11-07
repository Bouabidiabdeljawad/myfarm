import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] for credentials and sensitive
/// local data (JWT tokens, refresh tokens, biometric flags).
///
/// All keys are namespaced under `myfarm.` to avoid collisions.
class SecureStorageService {
  static const String _prefix = 'myfarm.';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Stores a string value.
  Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: '$_prefix$key', value: value);
  }

  /// Reads a string value. Returns null if not found.
  Future<String?> read({required String key}) async {
    return _storage.read(key: '$_prefix$key');
  }

  /// Deletes a value. No error if key does not exist.
  Future<void> delete({required String key}) async {
    await _storage.delete(key: '$_prefix$key');
  }

  /// Clears all myFarm-prefixed keys.
  Future<void> clearAll() async {
    final all = await _storage.readAll();
    for (final entry in all.entries) {
      if (entry.key.startsWith(_prefix)) {
        await _storage.delete(key: entry.key);
      }
    }
  }

  /// Convenience keys
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const isBiometricEnabledKey = 'biometric_enabled';
  static const selectedFarmIdKey = 'selected_farm_id';
  static const lastSyncAtKey = 'last_sync_at';
}
