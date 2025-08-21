import 'package:get_storage/get_storage.dart';

class StorageKeys {
  static const musicVolume = 'musicVolume';
  static const sfxVolume = 'sfxVolume';
}

class StorageService {
  static Future<void> init() async {
    await GetStorage.init();
  }

  final _box = GetStorage();

  double readDouble(String key, double fallback) =>
      (_box.read(key) as num?)?.toDouble() ?? fallback;

  Future<void> writeDouble(String key, double value) => _box.write(key, value);
}
