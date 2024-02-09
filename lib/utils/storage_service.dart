import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  static final _storage = GetStorage();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  // Initialize GetStorage
  Future<void> init() async {
    await GetStorage.init();
  }

  // Write data to storage
  void writeData(String key, dynamic value) {
    _storage.write(key, value);
  }

  // Read data from storage
  dynamic readData(String key) {
    return _storage.read(key);
  }

  // Singleton instance
  static StorageService get instance => _instance;
}
