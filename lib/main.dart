import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/bookmark_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize providers
  final themeProvider = ThemeProvider();
  final bookmarkProvider = BookmarkProvider();

  // Load saved theme and bookmarks
  await Future.wait([
    themeProvider.loadThemePreference(),
    bookmarkProvider.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: bookmarkProvider),
      ],
      child: const GitHubAnalyzerApp(),
    ),
  );
}
