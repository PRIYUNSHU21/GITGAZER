import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/repository_compare_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'providers/bookmark_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/history_provider.dart';
import 'providers/analysis_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GitHubAnalyzerApp());
}

class GitHubAnalyzerApp extends StatelessWidget {
  const GitHubAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookmarkProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'GITGAZER - AI Repository Insights',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Home screen
            home: const SplashScreen(),

            // Routes for future expansion
            routes: {
              '/home': (context) => const HomeScreen(),
              '/compare': (context) => const RepositoryCompareScreen(),
              '/bookmarks': (context) => const BookmarksScreen(),
            },

            // Builder for responsive design
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(MediaQuery.of(context)
                      .textScaler
                      .scale(1.0)
                      .clamp(0.8, 1.2)),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
