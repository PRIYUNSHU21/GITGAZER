import 'package:flutter/material.dart';

class SafeOpacity extends StatelessWidget {
  final double opacity;
  final Widget child;

  const SafeOpacity({
    super.key,
    required this.opacity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final safeOpacity = opacity.clamp(0.0, 1.0);

    // If opacity is effectively 0, don't render
    if (safeOpacity <= 0.01) {
      return const SizedBox.shrink();
    }

    // If opacity is effectively 1, don't wrap in Opacity widget
    if (safeOpacity >= 0.99) {
      return child;
    }

    return Opacity(
      opacity: safeOpacity,
      child: child,
    );
  }
}
