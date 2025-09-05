import 'package:flutter/material.dart';
import '../../models/repository_analysis.dart';

class EnhancedAiInsights extends StatelessWidget {
  final EnhancedAiInsight aiInsights;

  const EnhancedAiInsights({
    super.key,
    required this.aiInsights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI-Generated Insights',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Repository Summary
        _buildInsightCard(
          context,
          title: '📄 Repository Summary',
          content: aiInsights.repositorySummary.content,
          generatedAt: aiInsights.repositorySummary.generatedAt,
          icon: Icons.description_outlined,
        ),

        const SizedBox(height: 16),

        // Language Analysis
        _buildInsightCard(
          context,
          title: '🔧 Technology Stack Analysis',
          content: aiInsights.languageAnalysis.content,
          generatedAt: aiInsights.languageAnalysis.generatedAt,
          icon: Icons.code_outlined,
        ),

        const SizedBox(height: 16),

        // Contribution Patterns
        _buildInsightCard(
          context,
          title: '👥 Contribution Patterns',
          content: aiInsights.contributionPatterns.content,
          generatedAt: aiInsights.contributionPatterns.generatedAt,
          icon: Icons.people_outline,
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required String title,
    required String content,
    required DateTime generatedAt,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDate(generatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
