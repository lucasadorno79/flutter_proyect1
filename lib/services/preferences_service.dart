import 'package:shared_preferences/shared_preferences.dart';

class ExpandedPreferences {
  static const _keyExpanded = 'calendar_expanded';

  // Guardar estado
  static Future<void> saveExpanded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyExpanded, value);
  }

  // Cargar estado
  static Future<bool> loadExpanded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyExpanded) ?? true;
  }
}

class  PreferencesService{
  static const _keyDarkMode = 'dark_mode';

  static Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }
}
