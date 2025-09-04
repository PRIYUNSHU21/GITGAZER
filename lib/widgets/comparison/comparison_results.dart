import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';
import 'stats_comparison_card.dart';
import 'language_comparison_chart.dart';
import 'commit_activity_comparison.dart';
import '../ai/enhanced_ai_insights.dart';

class ComparisonResults extends StatefulWidget {
  final RepositoryAnalysis analysis1;
  final RepositoryAnalysis analysis2;

  const ComparisonResults({
    super.key,
    required this.analysis1,
    required this.analysis2,
  });

  @override
  State<ComparisonResults> createState() => _ComparisonResultsState();
}

class _ComparisonResultsState extends State<ComparisonResults>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: DesignTokens.durationSlow,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            _buildRepositoryTitles(theme),
            const SizedBox(height: DesignTokens.space6),
            _buildTabBar(theme),
            const SizedBox(height: DesignTokens.space6),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.space6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.space3),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            ),
            child: Icon(
              Icons.analytics_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: DesignTokens.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comparison Results',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Side-by-side analysis of repository metrics and insights',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepositoryTitles(ThemeData theme) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? DesignTokens.space4 : DesignTokens.space6),
      child: isMobile
          ? Column(
              children: [
                _buildRepoTitle(
                  theme,
                  widget.analysis1,
                  theme.colorScheme.primary,
                  'Repository 1',
                ),
                const SizedBox(height: DesignTokens.space3),
                _buildRepoTitle(
                  theme,
                  widget.analysis2,
                  theme.colorScheme.secondary,
                  'Repository 2',
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _buildRepoTitle(
                    theme,
                    widget.analysis1,
                    theme.colorScheme.primary,
                    'Repository 1',
                  ),
                ),
                const SizedBox(width: DesignTokens.space4),
                Expanded(
                  child: _buildRepoTitle(
                    theme,
                    widget.analysis2,
                    theme.colorScheme.secondary,
                    'Repository 2',
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRepoTitle(
    ThemeData theme,
    RepositoryAnalysis analysis,
    Color color,
    String label,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding:
          EdgeInsets.all(isMobile ? DesignTokens.space3 : DesignTokens.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 10 : null,
            ),
          ),
          const SizedBox(height: DesignTokens.space1),
          Text(
            analysis.fullName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: isMobile ? 14 : null,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: isMobile ? 2 : 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.space3 : DesignTokens.space6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: isMobile ? 10 : 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: isMobile ? 10 : 12,
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? DesignTokens.space1 : DesignTokens.space2,
        ),
        tabs: isMobile
            ? const [
                Tab(icon: Icon(Icons.bar_chart, size: 16), text: 'Stats'),
                Tab(icon: Icon(Icons.code, size: 16), text: 'Lang'),
                Tab(icon: Icon(Icons.timeline, size: 16), text: 'Activity'),
                Tab(icon: Icon(Icons.psychology, size: 16), text: 'AI'),
              ]
            : const [
                Tab(icon: Icon(Icons.bar_chart, size: 18), text: 'Stats'),
                Tab(icon: Icon(Icons.code, size: 18), text: 'Languages'),
                Tab(icon: Icon(Icons.timeline, size: 18), text: 'Activity'),
                Tab(
                    icon: Icon(Icons.psychology, size: 18),
                    text: 'AI Insights'),
              ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: 600,
      padding: const EdgeInsets.all(DesignTokens.space6),
      child: TabBarView(
        controller: _tabController,
        children: [
          StatsComparisonCard(
            analysis1: widget.analysis1,
            analysis2: widget.analysis2,
          ),
          LanguageComparisonChart(
            analysis1: widget.analysis1,
            analysis2: widget.analysis2,
          ),
          CommitActivityComparison(
            analysis1: widget.analysis1,
            analysis2: widget.analysis2,
          ),
          _buildAIInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildAIInsightsTab() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(
            isMobile ? DesignTokens.space3 : DesignTokens.space4),
        child: isMobile
            ? Column(
                children: [
                  _buildAIInsightSection(
                      'Repository 1', widget.analysis1, isMobile),
                  const SizedBox(height: DesignTokens.space4),
                  _buildAIInsightSection(
                      'Repository 2', widget.analysis2, isMobile),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildAIInsightSection(
                        'Repository 1', widget.analysis1, isMobile),
                  ),
                  const SizedBox(width: DesignTokens.space4),
                  Expanded(
                    child: _buildAIInsightSection(
                        'Repository 2', widget.analysis2, isMobile),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAIInsightSection(
      String title, RepositoryAnalysis analysis, bool isMobile) {
    return Column(
      children: [
        _buildAIInsightHeader(title, analysis),
        const SizedBox(height: DesignTokens.space4),
        Container(
          height: isMobile ? 300 : 400,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                  isMobile ? DesignTokens.space3 : DesignTokens.space4),
              child: EnhancedAiInsights(
                aiInsights: analysis.enhancedAiInsight!,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightHeader(String title, RepositoryAnalysis analysis) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: DesignTokens.space2),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            analysis.fullName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
