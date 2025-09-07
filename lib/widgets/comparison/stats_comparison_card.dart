import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';
import '../../core/utils/formatters.dart';

class StatsComparisonCard extends StatelessWidget {
  final RepositoryAnalysis analysis1;
  final RepositoryAnalysis analysis2;

  const StatsComparisonCard({
    super.key,
    required this.analysis1,
    required this.analysis2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatRow(
            context,
            'Stars',
            Icons.star_outlined,
            analysis1.stats.stars,
            analysis2.stats.stars,
            theme.colorScheme.primary,
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildStatRow(
            context,
            'Forks',
            Icons.call_split_outlined,
            analysis1.stats.forks,
            analysis2.stats.forks,
            theme.colorScheme.secondary,
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildStatRow(
            context,
            'Open Issues',
            Icons.bug_report_outlined,
            analysis1.stats.openIssues,
            analysis2.stats.openIssues,
            theme.colorScheme.error,
          ),
          const SizedBox(height: DesignTokens.space6),
          _buildDateComparison(context),
          const SizedBox(height: DesignTokens.space6),
          _buildLicenseComparison(context),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    IconData icon,
    int value1,
    int value2,
    Color color,
  ) {
    final theme = Theme.of(context);
    final winner = value1 > value2 ? 1 : (value2 > value1 ? 2 : 0);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.space2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: DesignTokens.space3),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (winner != 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space3,
                    vertical: DesignTokens.space1,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusFull),
                  ),
                  child: Text(
                    'Repository $winner leads',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.space4),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  analysis1.fullName,
                  value1,
                  theme.colorScheme.primary,
                  isWinner: winner == 1,
                ),
              ),
              const SizedBox(width: DesignTokens.space4),
              Expanded(
                child: _buildStatCard(
                  context,
                  analysis2.fullName,
                  value2,
                  theme.colorScheme.secondary,
                  isWinner: winner == 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String repoName, int value, Color color,
      {bool isWinner = false}) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: isWinner
            ? Border.all(
                color: Colors.green, width: 3) // Green outline for winner
            : Border.all(color: color.withOpacity(0.6), width: 2),
        boxShadow: isWinner
            ? [
                BoxShadow(
                  color:
                      Colors.green.withOpacity(0.3), // Green shadow for winner
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Text(
            repoName,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignTokens.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Formatters.formatNumber(value),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              // Removed cup icon for winner - now using green outline instead
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateComparison(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: DesignTokens.glassmorphism(
        context,
        blur: 10,
        opacity: 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.space2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(
                  Icons.schedule_outlined,
                  color: theme.colorScheme.tertiary,
                  size: 18,
                ),
              ),
              const SizedBox(width: DesignTokens.space3),
              Text(
                'Repository Timeline',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space4),
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  context,
                  analysis1.fullName,
                  'Created',
                  analysis1.stats.createdAt,
                  'Updated',
                  analysis1.stats.updatedAt,
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: DesignTokens.space4),
              Expanded(
                child: _buildDateCard(
                  context,
                  analysis2.fullName,
                  'Created',
                  analysis2.stats.createdAt,
                  'Updated',
                  analysis2.stats.updatedAt,
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(
    BuildContext context,
    String repoName,
    String label1,
    DateTime? date1,
    String label2,
    DateTime? date2,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repoName,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignTokens.space3),
          _buildDateInfo(context, label1, date1),
          const SizedBox(height: DesignTokens.space2),
          _buildDateInfo(context, label2, date2),
        ],
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context, String label, DateTime? date) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          date != null ? Formatters.formatDate(date) : 'N/A',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseComparison(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: DesignTokens.glassmorphism(
        context,
        blur: 10,
        opacity: 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.space2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: theme.colorScheme.onSurface,
                  size: 18,
                ),
              ),
              const SizedBox(width: DesignTokens.space3),
              Text(
                'License Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space4),
          Row(
            children: [
              Expanded(
                child: _buildLicenseCard(
                  context,
                  analysis1.fullName,
                  analysis1.stats.license,
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: DesignTokens.space4),
              Expanded(
                child: _buildLicenseCard(
                  context,
                  analysis2.fullName,
                  analysis2.stats.license,
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseCard(
    BuildContext context,
    String repoName,
    String? license,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repoName,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignTokens.space2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space3,
              vertical: DesignTokens.space2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Text(
              license ?? 'No License',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
