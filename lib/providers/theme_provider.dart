import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark theme
  bool _isLoaded = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  bool get isLoaded => _isLoaded;

  // Load theme preference from storage
  Future<void> loadThemePreference() async {
    if (_isLoaded) return;

    try {
      // For now, we'll use dark theme as default
      // When shared_preferences is available, uncomment the code below:
      /*
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to dark (index 2)
      _themeMode = ThemeMode.values[themeIndex];
      */

      _themeMode = ThemeMode.dark;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, use dark theme as default
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

  // Private method to save theme preference
  Future<void> _saveThemePreference() async {
    try {
      // When shared_preferences is available, uncomment the code below:
      /*
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
      */
    } catch (e) {
      // Handle save error silently
      debugPrint('Failed to save theme preference: $e');
    }
  }
}
