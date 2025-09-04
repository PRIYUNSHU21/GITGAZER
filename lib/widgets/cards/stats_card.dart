import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../core/constants/design_tokens.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final dynamic value;
  final String label;
  final Color? color;

  const StatsCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardColor.withOpacity(0.1),
            cardColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: cardColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          onTap: () {}, // Add subtle interaction
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.space2), // Tiny padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(
                      DesignTokens.space1), // Minimal padding
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: 16, // Much smaller icon
                    color: cardColor,
                  ),
                ),
                const SizedBox(height: DesignTokens.space1), // Tiny spacing
                Text(
                  _formatValue(value),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cardColor,
                    fontSize: 18, // Much smaller font
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 10, // Tiny label font
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value is num) {
      return Formatters.formatNumber(value);
    }
    return value?.toString() ?? 'N/A';
  }
}
