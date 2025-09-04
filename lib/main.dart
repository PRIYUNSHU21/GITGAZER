import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/repository_compare_screen.dart';

void main() {
  runApp(const GitHubAnalyzerApp());
}

class GitHubAnalyzerApp extends StatelessWidget {
  const GitHubAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GITGAZER - AI Repository Insights',
      debugShowCheckedModeBanner: false,

      // Theme configuration - Default to dark theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Force dark theme

      // Home screen
      home: const SplashScreen(),

      // Routes for future expansion
      routes: {
        '/home': (context) => const HomeScreen(),
        '/compare': (context) => const RepositoryCompareScreen(),
      },

      // Builder for responsive design
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2)),
          ),
          child: child!,
        );
      },
    );
  }
}
