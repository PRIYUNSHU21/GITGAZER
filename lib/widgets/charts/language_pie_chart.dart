import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/repository_analysis.dart';

class LanguagePieChart extends StatelessWidget {
  final LanguageData languageData;
  final double size;

  const LanguagePieChart({
    super.key,
    required this.languageData,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (!languageData.hasLanguages) {
      return _buildEmptyChart(context);
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PieChartPainter(
          languages: languageData.sortedLanguages,
        ),
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Text(
            'No data',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<LanguageItem> languages;

  _PieChartPainter({required this.languages});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.9;

    // Draw shadow for 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(center.dx + 4, center.dy + 4),
      radius + 3,
      shadowPaint,
    );

    double startAngle = -math.pi / 2; // Start at top

    for (int i = 0; i < languages.length; i++) {
      final language = languages[i];
      final sweepAngle = (language.percentage / 100) * 2 * math.pi;
      final baseColor = _getEnhancedColor(language.name, i);

      // Create enhanced gradient effect
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            baseColor.withOpacity(0.9),
            baseColor,
            baseColor.withOpacity(0.8),
          ],
          stops: const [0.0, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw thicker border for each segment with dark color
      final borderPaint = Paint()
        ..color = const Color(0xFF2D3748) // Dark gray for better contrast
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw percentage text if segment is visible
      if (language.percentage > 5) {
        _drawPercentageText(
          canvas,
          center,
          radius * 0.7,
          startAngle + sweepAngle / 2,
          language.formattedPercentage,
          baseColor,
        );
      }

      startAngle += sweepAngle;
    }

    // Draw center hole with better gradient for donut effect
    final holePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF7FAFC), // Light gray center
          Colors.white,
          const Color(0xFFE2E8F0), // Subtle border
        ],
        stops: const [0.0, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.4))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, holePaint);

    // Draw enhanced inner border
    final innerBorderPaint = Paint()
      ..color = const Color(0xFF4A5568)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius * 0.4, innerBorderPaint);

    // Draw enhanced outer border
    final outerBorderPaint = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius, outerBorderPaint);
  }

  // Enhanced color palette with better contrast
  Color _getEnhancedColor(String languageName, int index) {
    // Professional color palette with good contrast
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEC4899), // Pink
      const Color(0xFF84CC16), // Lime
      const Color(0xFFEAB308), // Yellow
      const Color(0xFF6366F1), // Indigo
      const Color(0xFFF97316), // Orange
      const Color(0xFF14B8A6), // Teal
    ];

    // Use language-specific colors if available, otherwise use index-based
    switch (languageName.toLowerCase()) {
      case 'javascript':
        return const Color(0xFFF7DF1E);
      case 'typescript':
        return const Color(0xFF3178C6);
      case 'python':
        return const Color(0xFF3776AB);
      case 'java':
        return const Color(0xFFED8B00);
      case 'c++':
      case 'cpp':
        return const Color(0xFF00599C);
      case 'c#':
      case 'csharp':
        return const Color(0xFF239120);
      case 'php':
        return const Color(0xFF777BB4);
      case 'ruby':
        return const Color(0xFFCC342D);
      case 'go':
        return const Color(0xFF00ADD8);
      case 'rust':
        return const Color(0xFF000000);
      case 'swift':
        return const Color(0xFFFA7343);
      case 'kotlin':
        return const Color(0xFF7F52FF);
      case 'dart':
        return const Color(0xFF0175C2);
      case 'html':
        return const Color(0xFFE34F26);
      case 'css':
        return const Color(0xFF1572B6);
      default:
        return colors[index % colors.length];
    }
  }

  void _drawPercentageText(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    String text,
    Color backgroundColor,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.8),
              offset: const Offset(1, 1),
              blurRadius: 3,
            ),
            Shadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(-1, -1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final x = center.dx + radius * math.cos(angle) - textPainter.width / 2;
    final y = center.dy + radius * math.sin(angle) - textPainter.height / 2;

    // Draw enhanced background for text with better contrast
    final bgPaint = Paint()
      ..color = backgroundColor.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        x - 4,
        y - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      ),
      const Radius.circular(6),
    );

    canvas.drawRRect(bgRect, bgPaint);

    // Draw border around text background
    final bgBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(bgRect, bgBorderPaint);

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
