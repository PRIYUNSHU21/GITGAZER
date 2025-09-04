import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';
import '../../core/utils/formatters.dart';

class CommitActivityComparison extends StatelessWidget {
  final RepositoryAnalysis analysis1;
  final RepositoryAnalysis analysis2;

  const CommitActivityComparison({
    super.key,
    required this.analysis1,
    required this.analysis2,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildActivityChart(context),
          const SizedBox(height: DesignTokens.space6),
          _buildActivityStats(context),
        ],
      ),
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    final theme = Theme.of(context);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Weekly Commit Activity'),
          const SizedBox(height: DesignTokens.space6),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        final weekIndex = value.toInt();
                        if (weekIndex >= 0 && weekIndex < 52) {
                          return Text(
                            'W${weekIndex + 1}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.2)),
                    bottom: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.2)),
                  ),
                ),
                lineBarsData: [
                  _createLineData(
                    analysis1.commitActivity.weeklyData,
                    theme.colorScheme.primary,
                    'Repository 1',
                  ),
                  _createLineData(
                    analysis2.commitActivity.weeklyData,
                    theme.colorScheme.secondary,
                    'Repository 2',
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: theme.colorScheme.surfaceContainerHighest,
                    tooltipRoundedRadius: DesignTokens.radiusMd,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isRepo1 = spot.barIndex == 0;
                        final repoName =
                            isRepo1 ? analysis1.fullName : analysis2.fullName;
                        return LineTooltipItem(
                          '$repoName\n${spot.y.toInt()} commits',
                          TextStyle(
                            color: spot.bar.color,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.space2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: Icon(
            Icons.timeline_outlined,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: DesignTokens.space3),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  LineChartBarData _createLineData(
    List<WeeklyCommitData> weeks,
    Color color,
    String label,
  ) {
    final spots = weeks.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.commits.toDouble(),
      );
    }).toList();

    return LineChartBarData(
      spots: spots,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          context,
          analysis1.fullName,
          theme.colorScheme.primary,
        ),
        const SizedBox(width: DesignTokens.space6),
        _buildLegendItem(
          context,
          analysis2.fullName,
          theme.colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: DesignTokens.space2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActivityStats(BuildContext context) {
    final stats1 = _calculateStats(analysis1.commitActivity.weeklyData);
    final stats2 = _calculateStats(analysis2.commitActivity.weeklyData);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Activity Statistics'),
          const SizedBox(height: DesignTokens.space6),
          _buildStatComparison(
            context,
            'Total Commits',
            Icons.commit_outlined,
            stats1['total']!,
            stats2['total']!,
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildStatComparison(
            context,
            'Average per Week',
            Icons.trending_up_outlined,
            stats1['average']!,
            stats2['average']!,
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildStatComparison(
            context,
            'Peak Week',
            Icons.north_outlined,
            stats1['peak']!,
            stats2['peak']!,
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildStatComparison(
            context,
            'Active Weeks',
            Icons.event_available_outlined,
            stats1['activeWeeks']!,
            stats2['activeWeeks']!,
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats(List<WeeklyCommitData> weeks) {
    final totalCommits = weeks.fold<int>(0, (sum, week) => sum + week.commits);
    final activeWeeks = weeks.where((week) => week.commits > 0).length;
    final averagePerWeek =
        activeWeeks > 0 ? (totalCommits / activeWeeks).round() : 0;
    final peakWeek = weeks.isEmpty
        ? 0
        : weeks.map((w) => w.commits).reduce((a, b) => a > b ? a : b);

    return {
      'total': totalCommits,
      'average': averagePerWeek,
      'peak': peakWeek,
      'activeWeeks': activeWeeks,
    };
  }

  Widget _buildStatComparison(
    BuildContext context,
    String label,
    IconData icon,
    int value1,
    int value2,
  ) {
    final theme = Theme.of(context);
    final winner = value1 > value2 ? 1 : (value2 > value1 ? 2 : 0);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: DesignTokens.space3),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
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
                    color: (winner == 1
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary)
                        .withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusFull),
                  ),
                  child: Text(
                    'Repository $winner',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: winner == 1
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.space3),
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
      padding: const EdgeInsets.all(DesignTokens.space3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: isWinner
            ? Border.all(color: color, width: 3)
            : Border.all(color: color.withOpacity(0.6), width: 2),
        boxShadow: isWinner
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Text(
            repoName.split('/')[1], // Show only repo name
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (isWinner) ...[
                const SizedBox(width: DesignTokens.space1),
                Icon(
                  Icons.emoji_events,
                  color: color,
                  size: 16,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
