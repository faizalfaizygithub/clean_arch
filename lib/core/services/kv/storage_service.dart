import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<void> setInt(String key, int value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<int?> getInt(String key);
  Future<void> remove(String key);
}

class StorageServiceImpl implements StorageService {
  StorageServiceImpl() {
    _initializationFuture = _initPrefs();
  }

  SharedPreferences? _prefs;
  Future<void>? _initializationFuture;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _preferences async {
    await _initializationFuture;
    return _prefs!;
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefs = await _preferences;
    await prefs.setString(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final prefs = await _preferences;
    await prefs.setInt(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await _preferences;
    await prefs.remove(key);
  }
}
