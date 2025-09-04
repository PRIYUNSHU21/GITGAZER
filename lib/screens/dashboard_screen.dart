import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/design_tokens.dart';
import '../core/services/github_service.dart';
import '../core/services/api_service.dart';
import '../models/repository_analysis.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/cards/stats_card.dart';
import '../widgets/cards/ai_insight_card.dart';
import '../widgets/cards/modern_enhanced_ai_insight_card.dart';
import '../widgets/charts/language_pie_chart.dart';
import '../widgets/charts/commit_activity_chart.dart';

class DashboardScreen extends StatefulWidget {
  final String owner;
  final String repo;

  const DashboardScreen({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  RepositoryAnalysis? _analysis;
  String? _errorMessage;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: DesignTokens.durationSlow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _loadAnalysis();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalysis() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final analysis = await GitHubService.analyzeRepository(
        widget.owner,
        widget.repo,
      );

      if (mounted) {
        setState(() {
          _analysis = analysis;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openInGitHub() async {
    if (_analysis != null) {
      final url = Uri.parse(_analysis!.links.repoUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            expandedHeight: isDesktop ? 230 : 250, // Much taller for mobile
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: DesignTokens.gradient(context),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isDesktop ? DesignTokens.space6 : DesignTokens.space4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Enhanced Logo Design
                            Container(
                              padding:
                                  const EdgeInsets.all(DesignTokens.space4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusLg),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.analytics_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Enhanced repository name with better visibility
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DesignTokens.space4,
                                      vertical: DesignTokens.space3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.black.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          DesignTokens.radiusLg),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                              DesignTokens.space1),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(
                                                DesignTokens.radiusSm),
                                          ),
                                          child: Icon(
                                            Icons.account_circle,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: DesignTokens.space2),
                                        Text(
                                          widget.owner,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: DesignTokens.space2),
                                          width: 2,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(1),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(
                                              DesignTokens.space1),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.secondary
                                                .withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(
                                                DesignTokens.radiusSm),
                                          ),
                                          child: Icon(
                                            Icons.folder,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: DesignTokens.space2),
                                        Text(
                                          widget.repo,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.space2),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: DesignTokens.space2,
                                          vertical: DesignTokens.space1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                              DesignTokens.radiusFull),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.analytics_outlined,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              size: 12,
                                            ),
                                            const SizedBox(
                                                width: DesignTokens.space1),
                                            Text(
                                              'AI Analysis',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          width: DesignTokens.space2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: DesignTokens.space2,
                                          vertical: DesignTokens.space1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                              DesignTokens.radiusFull),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(
                                                width: DesignTokens.space1),
                                            Text(
                                              'Live Data',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DesignTokens.space4),
                        if (!_isLoading && _analysis != null) ...[
                          size.width <= 768
                              ? Wrap(
                                  spacing: DesignTokens.space3,
                                  runSpacing: DesignTokens.space2,
                                  children: [
                                    _buildQuickStat('Stars',
                                        _analysis!.stats.stars.toString()),
                                    _buildQuickStat('Forks',
                                        _analysis!.stats.forks.toString()),
                                    _buildQuickStat('Issues',
                                        _analysis!.stats.openIssues.toString()),
                                  ],
                                )
                              : Row(
                                  children: [
                                    _buildQuickStat('Stars',
                                        _analysis!.stats.stars.toString()),
                                    const SizedBox(width: DesignTokens.space4),
                                    _buildQuickStat('Forks',
                                        _analysis!.stats.forks.toString()),
                                    const SizedBox(width: DesignTokens.space4),
                                    _buildQuickStat('Issues',
                                        _analysis!.stats.openIssues.toString()),
                                  ],
                                ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              if (_analysis != null)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: DesignTokens.glassmorphism(context),
                    child: const Icon(Icons.open_in_new, color: Colors.white),
                  ),
                  onPressed: _openInGitHub,
                  tooltip: 'Open in GitHub',
                ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: DesignTokens.glassmorphism(context),
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                onPressed: _loadAnalysis,
                tooltip: 'Refresh',
              ),
              const SizedBox(width: DesignTokens.space4),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space3,
        vertical: DesignTokens.space2,
      ),
      decoration: DesignTokens.glassmorphism(context),
      child: Column(
        children: [
          Text(
            value,
            style:
                (DesignTokens.headingSm(context) ?? const TextStyle()).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: (DesignTokens.bodyXs(context) ?? const TextStyle()).copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(
        message: 'Analyzing repository...',
      );
    }

    if (_errorMessage != null) {
      return CustomErrorWidget(
        message: _errorMessage!,
        onRetry: _loadAnalysis,
      );
    }

    if (_analysis == null) {
      return const CustomErrorWidget(
        message: 'No analysis data available',
      );
    }

    _animationController.forward();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: _loadAnalysis,
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width > 1024
                  ? DesignTokens.space8
                  : DesignTokens
                      .space4, // Reduced for mobile to give more space
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(),
                const SizedBox(height: DesignTokens.space8),
                _buildAIInsightSection(),
                const SizedBox(height: DesignTokens.space8),
                _buildLanguageSection(),
                const SizedBox(height: DesignTokens.space8),
                _buildCommitSection(),
                const SizedBox(height: DesignTokens.space12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = _analysis!.stats;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    final statsData = [
      {
        'label': 'Stars',
        'value': stats.stars,
        'icon': Icons.star_outline,
        'color': Colors.amber
      },
      {
        'label': 'Forks',
        'value': stats.forks,
        'icon': Icons.fork_right,
        'color': Colors.blue
      },
      {
        'label': 'Open Issues',
        'value': stats.openIssues,
        'icon': Icons.bug_report_outlined,
        'color': Colors.red
      },
      {
        'label': 'License',
        'value': stats.license ?? 'None',
        'icon': Icons.gavel_outlined,
        'color': Colors.green,
        'isString': true
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.space2),
              decoration: BoxDecoration(
                gradient: DesignTokens.primaryGradient(context),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: DesignTokens.space3),
            Text(
              'Repository Statistics',
              style: (DesignTokens.headingMd(context) ?? const TextStyle())
                  .copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.space4),
        if (isDesktop)
          // Desktop layout - 4 columns
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 4.0,
              crossAxisSpacing: DesignTokens.space4,
              mainAxisSpacing: DesignTokens.space4,
            ),
            itemCount: statsData.length,
            itemBuilder: (context, index) => _buildStatCard(statsData[index]),
          )
        else
          // Mobile/Tablet layout - 1 column to prevent overflow
          Column(
            children: statsData
                .map((stat) => Container(
                      margin:
                          const EdgeInsets.only(bottom: DesignTokens.space3),
                      height: 120, // Fixed height to prevent sizing issues
                      child: _buildStatCard(stat),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    final theme = Theme.of(context);
    final color = stat['color'] as Color;
    final isString = stat['isString'] as bool? ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
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
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.space4),
        child: Row(
          children: [
            // Left side - Icon
            Container(
              padding: const EdgeInsets.all(DesignTokens.space3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                stat['icon'] as IconData,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(width: DesignTokens.space4),

            // Middle - Value and Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isString
                        ? stat['value'].toString()
                        : _formatNumber(stat['value'] as int),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                      fontSize: isString ? 20 : 28,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space1),
                  Text(
                    stat['label'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Right side - Live indicator
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space3,
                vertical: DesignTokens.space2,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space1),
                  Text(
                    'LIVE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  Widget _buildLanguageSection() {
    final theme = Theme.of(context);
    final languages = _analysis!.languages;

    if (!languages.hasLanguages) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.languageBreakdown,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                LanguagePieChart(
                  languageData: languages,
                  size: 280,
                ),
                const SizedBox(height: 24),
                _buildLanguageList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageList() {
    final languages = _analysis!.languages.sortedLanguages;

    return Column(
      children: languages.take(5).map((language) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getLanguageColor(language.name),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(language.name),
              ),
              Text(
                language.formattedPercentage,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommitSection() {
    final theme = Theme.of(context);
    final commits = _analysis!.commitActivity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.commitActivity,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.commit,
                value: commits.totalCommits,
                label: AppStrings.totalCommits,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                icon: Icons.trending_up,
                value: commits.last30Days,
                label: AppStrings.recentCommits,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Add commit activity chart
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Commit Activity',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Commits per week over the last year',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),
                CommitActivityChart(
                  commitActivity: commits,
                  height: 250,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightSection() {
    final theme = Theme.of(context);
    final analysis = _analysis!;

    // Debug information
    print('Enhanced AI Insight: ${analysis.enhancedAiInsight}');
    print('Regular AI Insight: ${analysis.aiInsight.summary}');
    print('Has Summary: ${analysis.aiInsight.hasSummary}');

    // Use enhanced AI insights if available with modern card
    if (analysis.enhancedAiInsight != null) {
      print('Showing Modern Enhanced AI Insights');
      return ModernEnhancedAiInsightCard(
        enhancedInsight: analysis.enhancedAiInsight!,
      );
    }

    // Fallback to legacy AI insight
    final insight = analysis.aiInsight;
    print('AI Insight Summary Length: ${insight.summary.length}');

    // Show AI insights section even if empty for debugging
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.space2),
              decoration: BoxDecoration(
                gradient: DesignTokens.primaryGradient(context),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: const Icon(
                Icons.psychology_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: DesignTokens.space3),
            Text(
              AppStrings.aiInsights,
              style: (DesignTokens.headingMd(context) ?? const TextStyle())
                  .copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.space4),
        // Show debug info if no insights
        if (!insight.hasSummary)
          Container(
            padding: const EdgeInsets.all(DesignTokens.space6),
            decoration: DesignTokens.modernCard(context, elevated: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: DesignTokens.space2),
                    Text(
                      'Debug Information:',
                      style:
                          (DesignTokens.headingSm(context) ?? const TextStyle())
                              .copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.space4),
                _buildDebugRow(
                    'Enhanced AI Insight',
                    analysis.enhancedAiInsight != null
                        ? "Available"
                        : "Not Available"),
                _buildDebugRow(
                    'Regular AI Insight Summary', '"${insight.summary}"'),
                _buildDebugRow('Summary Length', '${insight.summary.length}'),
                _buildDebugRow('Has Summary', '${insight.hasSummary}'),
              ],
            ),
          )
        else
          Container(
            decoration: DesignTokens.modernCard(context, elevated: true),
            child: AiInsightCard(insight: insight),
          ),
      ],
    );
  }

  Widget _buildDebugRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLanguageColor(String language) {
    // This should match the colors from your theme
    const languageColors = {
      'JavaScript': Color(0xFFF1E05A),
      'TypeScript': Color(0xFF3178C6),
      'Python': Color(0xFF3776AB),
      'Java': Color(0xFFB07219),
      'C++': Color(0xFFF34B7D),
      'Dart': Color(0xFF0175C2),
      'CSS': Color(0xFF1572B6),
      'HTML': Color(0xFFE34F26),
    };

    return languageColors[language] ?? Colors.grey;
  }
}
