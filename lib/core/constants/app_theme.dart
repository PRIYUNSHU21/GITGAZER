import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Material 3 Color Scheme - Dark Theme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF4FC3F7), // Light Blue
    onPrimary: Color(0xFF002E42), // Dark Blue
    primaryContainer: Color(0xFF004459), // Medium Blue
    onPrimaryContainer: Color(0xFFB8E6FF), // Very Light Blue

    secondary: Color(0xFFB3E5FC), // Secondary Light Blue
    onSecondary: Color(0xFF1A1A1A), // Dark Text
    secondaryContainer: Color(0xFF2E5266), // Secondary Container
    onSecondaryContainer: Color(0xFFD4E6F1), // Light Text on Secondary

    tertiary: Color(0xFF81C784), // Light Green
    onTertiary: Color(0xFF1B5E20), // Dark Green
    tertiaryContainer: Color(0xFF2E7D32), // Medium Green
    onTertiaryContainer: Color(0xFFC8E6C9), // Light Green Text

    error: Color(0xFFEF5350), // Red
    onError: Color(0xFF000000), // Black
    errorContainer: Color(0xFFB71C1C), // Dark Red
    onErrorContainer: Color(0xFFFFCDD2), // Light Red

    outline: Color(0xFF79747E), // Outline
    outlineVariant: Color(0xFF49454F), // Variant Outline

    surface: Color(0xFF1C1B1F), // Surface
    onSurface: Color(0xFFE6E1E5), // Text on Surface
    surfaceContainerHighest: Color(0xFF49454F), // Surface Container Highest
    onSurfaceVariant: Color(0xFFCAC4D0), // Text on Surface Variant

    inverseSurface: Color(0xFFE6E1E5), // Inverse Surface
    onInverseSurface: Color(0xFF313033), // Text on Inverse Surface
    inversePrimary: Color(0xFF006A77), // Inverse Primary

    shadow: Color(0xFF000000), // Shadow
    scrim: Color(0xFF000000), // Scrim
    surfaceTint: Color(0xFF4FC3F7), // Surface Tint
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: darkColorScheme.onSurface,
        displayColor: darkColorScheme.onSurface,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: darkColorScheme.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.error),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme, // Using dark for now
      textTheme: GoogleFonts.robotoTextTheme(),
    );
  }
}

// Language colors for programming languages (GitHub-inspired)
class LanguageColors {
  static const Map<String, Color> colors = {
    'JavaScript': Color(0xFFF1E05A),
    'TypeScript': Color(0xFF3178C6),
    'Python': Color(0xFF3776AB),
    'Java': Color(0xFFB07219),
    'C++': Color(0xFFF34B7D),
    'C': Color(0xFF555555),
    'Go': Color(0xFF00ADD8),
    'Rust': Color(0xFFDEA584),
    'Swift': Color(0xFFFA7343),
    'Kotlin': Color(0xFFA97BFF),
    'Dart': Color(0xFF0175C2),
    'PHP': Color(0xFF4F5D95),
    'Ruby': Color(0xFF701516),
    'CSS': Color(0xFF1572B6),
    'HTML': Color(0xFFE34F26),
    'Shell': Color(0xFF89E051),
    'Vue': Color(0xFF4FC08D),
    'C#': Color(0xFF239120),
    'R': Color(0xFF198CE7),
    'Scala': Color(0xFFDC322F),
  };

  static Color getColor(String language) {
    return colors[language] ?? const Color(0xFF6B7280); // Default gray
  }
}
