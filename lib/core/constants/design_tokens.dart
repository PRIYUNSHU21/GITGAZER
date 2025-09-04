import 'package:flutter/material.dart';

/// Modern design tokens for consistent spacing, typography, and effects
class DesignTokens {
  // Spacing System (8px grid)
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;
  static const double space20 = 80;
  static const double space24 = 96;

  // Border Radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2xl = 24;
  static const double radiusFull = 9999;

  // Elevation & Shadows
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;
  static const double elevationXl = 12;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Duration durationSlower = Duration(milliseconds: 500);

  // Glassmorphism Effect
  static BoxDecoration glassmorphism(
    BuildContext context, {
    double blur = 10,
    double opacity = 0.1,
    Color? borderColor,
    double borderWidth = 1,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color: borderColor ?? theme.colorScheme.outline.withOpacity(0.2),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withOpacity(0.1),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Gradient Backgrounds
  static BoxDecoration gradient(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          // More matte, subdued colors
          theme.colorScheme.primary.withOpacity(0.6),
          theme.colorScheme.primary.withOpacity(0.4),
          theme.colorScheme.secondary.withOpacity(0.3),
          theme.colorScheme.surface.withOpacity(0.9),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 8),
          spreadRadius: -3,
        ),
      ],
    );
  }

  static LinearGradient primaryGradient(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primary.withOpacity(0.7),
      ],
    );
  }

  static LinearGradient surfaceGradient(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ],
    );
  }

  // Card Styles
  static BoxDecoration modernCard(
    BuildContext context, {
    bool elevated = false,
    bool glass = false,
  }) {
    final theme = Theme.of(context);

    if (glass) {
      return glassmorphism(context);
    }

    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color: theme.colorScheme.outline.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: elevationMd,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  // Text Styles Extensions
  static TextStyle? headingXl(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        );
  }

  static TextStyle? headingLg(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.25,
        );
  }

  static TextStyle? headingMd(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle? headingSm(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle? bodySm(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        );
  }

  static TextStyle? bodyXs(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        );
  }
}
