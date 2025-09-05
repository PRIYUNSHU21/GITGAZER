import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark theme
  bool _isLoaded = false;
  static const String _themeBoxName = 'theme_settings';
  static const String _themeModeKey = 'theme_mode';

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  bool get isLoaded => _isLoaded;

  // Load theme preference from Hive storage
  Future<void> loadThemePreference() async {
    if (_isLoaded) return;

    try {
      // Open the theme settings box
      final box = await Hive.openBox(_themeBoxName);

      // Get saved theme mode (default to dark mode if not found)
      final themeIndex =
          box.get(_themeModeKey, defaultValue: ThemeMode.dark.index);
      _themeMode = ThemeMode.values[themeIndex];

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, use dark theme as default
      debugPrint('Failed to load theme preference: $e');
      _themeMode = ThemeMode.dark;
      _isLoaded = true;
      notifyListeners();
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _saveThemePreference();
    notifyListeners();
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  // Set to system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  // Set to light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  // Set to dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Get theme mode name
  String get themeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  // Private method to save theme preference to Hive
  Future<void> _saveThemePreference() async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      await box.put(_themeModeKey, _themeMode.index);
    } catch (e) {
      // Handle save error silently
      debugPrint('Failed to save theme preference: $e');
    }
  }
}
