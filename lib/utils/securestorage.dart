import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create storage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Read value
  static Future<String?> readValue(String key) async {
    return await _storage.read(key: key);
  }

  // Read all values
  static Future<Map<String, String>> readAllValues() async {
    return await _storage.readAll();
  }

  // Delete value
  static Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all values
  static Future<void> deleteAllValues() async {
    await _storage.deleteAll();
  }

  // Write value
  static Future<void> writeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}
