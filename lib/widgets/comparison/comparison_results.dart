import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';
import 'stats_comparison_card.dart';
import 'language_comparison_chart.dart';
import 'commit_activity_comparison.dart';
import '../cards/modern_enhanced_ai_insight_card.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.space6),
      child: Row(
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
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space4),
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
            ),
          ),
          const SizedBox(height: DesignTokens.space1),
          Text(
            analysis.fullName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.space6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.bar_chart, size: 18),
            text: 'Stats',
          ),
          Tab(
            icon: Icon(Icons.code, size: 18),
            text: 'Languages',
          ),
          Tab(
            icon: Icon(Icons.timeline, size: 18),
            text: 'Activity',
          ),
          Tab(
            icon: Icon(Icons.psychology, size: 18),
            text: 'AI Insights',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      height: isMobile
          ? size.height * 0.75
          : 800, // Increased height for modern AI cards
      padding: EdgeInsets.all(
        isMobile ? DesignTokens.space3 : DesignTokens.space6,
      ),
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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (isMobile)
            // Mobile: Stack vertically
            Column(
              children: [
                _buildAIInsightSection('Repository 1', widget.analysis1),
                const SizedBox(height: DesignTokens.space6),
                _buildAIInsightSection('Repository 2', widget.analysis2),
              ],
            )
          else
            // Desktop: Side by side
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      _buildAIInsightSection('Repository 1', widget.analysis1),
                ),
                const SizedBox(width: DesignTokens.space4),
                Expanded(
                  child:
                      _buildAIInsightSection('Repository 2', widget.analysis2),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAIInsightSection(String title, RepositoryAnalysis analysis) {
    return Column(
      children: [
        _buildAIInsightHeader(title, analysis),
        const SizedBox(height: DesignTokens.space4),
        Container(
          height: MediaQuery.of(context).size.width < 768
              ? 500
              : 600, // Increased height for modern AI card
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            child: ModernEnhancedAiInsightCard(
              enhancedInsight: analysis.enhancedAiInsight!,
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
