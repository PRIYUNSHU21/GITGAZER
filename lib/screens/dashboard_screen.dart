import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/design_tokens.dart';
import '../core/services/github_service.dart';
import '../core/services/api_service.dart';
import '../models/repository_analysis.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/cards/stats_card.dart';
import '../widgets/cards/ai_insight_card.dart';
import '../widgets/cards/modern_enhanced_ai_insight_card.dart';
import '../widgets/charts/language_pie_chart.dart';
import '../widgets/charts/commit_activity_chart.dart';
import 'bookmarks_screen.dart';
import 'repository_compare_screen.dart';

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

  Future<void> _toggleBookmark(BookmarkProvider bookmarkProvider) async {
    if (_analysis == null) return;

    final isBookmarked = bookmarkProvider.isBookmarked(
      _analysis!.owner,
      _analysis!.repo,
    );

    if (isBookmarked) {
      await bookmarkProvider.removeBookmark(_analysis!.owner, _analysis!.repo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed ${_analysis!.name} from bookmarks'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      await bookmarkProvider.addBookmark(_analysis!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${_analysis!.name} to bookmarks'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => _navigateToBookmarks(context),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _navigateToBookmarks(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BookmarksScreen(),
      ),
    );
  }

  void _navigateToCompare(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RepositoryCompareScreen(),
      ),
    );
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
            expandedHeight: isDesktop ? 210 : 220,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: DesignTokens.gradient(context),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isDesktop ? DesignTokens.space6 : DesignTokens.space3,
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
                                        Flexible(
                                          child: Text(
                                            widget.owner,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                                        Flexible(
                                          child: Text(
                                            widget.repo,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.space3),
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
                          // Quick Stats Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildQuickStat('Stars',
                                        _analysis!.stats.stars.toString()),
                                    SizedBox(
                                        width: isDesktop
                                            ? DesignTokens.space4
                                            : DesignTokens.space2),
                                    _buildQuickStat('Forks',
                                        _analysis!.stats.forks.toString()),
                                    SizedBox(
                                        width: isDesktop
                                            ? DesignTokens.space4
                                            : DesignTokens.space2),
                                    _buildQuickStat('Issues',
                                        _analysis!.stats.openIssues.toString()),
                                  ],
                                ),
                              ),
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
              if (_analysis != null) ...[
                // Enhanced Menu Button with all actions
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.space2),
                  child: PopupMenuButton<String>(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusFull),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.98),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusLg),
                      side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    offset: const Offset(0, 50),
                    onSelected: (value) {
                      switch (value) {
                        case 'bookmark':
                          final bookmarkProvider =
                              Provider.of<BookmarkProvider>(context,
                                  listen: false);
                          _toggleBookmark(bookmarkProvider);
                          break;
                        case 'github':
                          _openInGitHub();
                          break;
                        case 'bookmarks':
                          _navigateToBookmarks(context);
                          break;
                        case 'compare':
                          _navigateToCompare(context);
                          break;
                        case 'refresh':
                          _loadAnalysis();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      // Bookmark Menu Item
                      PopupMenuItem<String>(
                        value: 'bookmark',
                        height: 48,
                        child: Consumer<BookmarkProvider>(
                          builder: (context, bookmarkProvider, child) {
                            final isBookmarked = bookmarkProvider.isBookmarked(
                              _analysis!.owner,
                              _analysis!.repo,
                            );
                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        DesignTokens.radiusSm),
                                  ),
                                  child: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.space3),
                                Expanded(
                                  child: Text(
                                    isBookmarked
                                        ? 'Remove Bookmark'
                                        : 'Add Bookmark',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // GitHub Menu Item
                      PopupMenuItem<String>(
                        value: 'github',
                        height: 48,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusSm),
                              ),
                              child: Icon(
                                Icons.open_in_new,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space3),
                            Expanded(
                              child: Text(
                                'Open in GitHub',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bookmarks List Menu Item
                      PopupMenuItem<String>(
                        value: 'bookmarks',
                        height: 48,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusSm),
                              ),
                              child: Icon(
                                Icons.bookmarks,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space3),
                            Expanded(
                              child: Text(
                                'View Bookmarks',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Compare Menu Item
                      PopupMenuItem<String>(
                        value: 'compare',
                        height: 48,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusSm),
                              ),
                              child: Icon(
                                Icons.compare_arrows,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space3),
                            Expanded(
                              child: Text(
                                'Compare Repositories',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Refresh Menu Item
                      PopupMenuItem<String>(
                        value: 'refresh',
                        height: 48,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusSm),
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space3),
                            Expanded(
                              child: Text(
                                'Refresh Data',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.space2 : DesignTokens.space3,
        vertical: isMobile ? DesignTokens.space1 : DesignTokens.space2,
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
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          Text(
            label,
            style: (DesignTokens.bodyXs(context) ?? const TextStyle()).copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: isMobile ? 10 : 12,
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
              MediaQuery.of(context).size.width < 600
                  ? DesignTokens.space3
                  : MediaQuery.of(context).size.width > 1024
                      ? DesignTokens
                          .space4 // Reduced from space8 to space4 for wider cards
                      : DesignTokens
                          .space5, // Reduced from space6 to space5 for tablets
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
    final isMobile = size.width < 768;

    final statsData = [
      {
        'label': 'Stars',
        'value': stats.stars,
        'icon': Icons.star,
        'color': Colors.amber,
        'gradient': [Colors.amber.shade400, Colors.orange.shade500],
        'description': 'Community Interest'
      },
      {
        'label': 'Forks',
        'value': stats.forks,
        'icon': Icons.fork_right,
        'color': Colors.blue,
        'gradient': [Colors.blue.shade400, Colors.indigo.shade500],
        'description': 'Code Adoption'
      },
      {
        'label': 'Open Issues',
        'value': stats.openIssues,
        'icon': Icons.bug_report,
        'color': Colors.red,
        'gradient': [Colors.red.shade400, Colors.pink.shade500],
        'description': 'Active Development'
      },
      {
        'label': 'License',
        'value': stats.license ?? 'None',
        'icon': Icons.gavel,
        'color': Colors.green,
        'gradient': [Colors.green.shade400, Colors.teal.shade500],
        'description': 'Legal Framework',
        'isString': true
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.space2 : DesignTokens.space4,
        vertical: DesignTokens.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.space3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space2),
                  decoration: BoxDecoration(
                    gradient: DesignTokens.primaryGradient(context),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: DesignTokens.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repository Statistics',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      Text(
                        'Real-time metrics and insights',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.space4),

          // Stats Grid with single row per card layout
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 6.0, // Adjusted for horizontal layout
              mainAxisSpacing: DesignTokens.space2,
            ),
            itemCount: statsData.length,
            itemBuilder: (context, index) => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildEnhancedStatCard(statsData[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(Map<String, dynamic> stat) {
    final theme = Theme.of(context);
    final color = stat['color'] as Color;
    final gradient = stat['gradient'] as List<Color>;
    final isString = stat['isString'] as bool? ?? false;
    final description = stat['description'] as String;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: isMobile ? 80 : 70, // Reduced height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile
            ? DesignTokens.space2
            : DesignTokens.space3), // Reduced padding
        child: Row(
          children: [
            // Left side - Icon and label
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.space1),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: Colors.white,
                      size: isMobile ? 20 : 18, // Increased from 18/16
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          stat['label'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            fontSize:
                                isMobile ? 16 : 14, // Increased from 14/12
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!isMobile) ...[
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 12, // Increased from 10
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right side - Value
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isString
                        ? stat['value'].toString()
                        : _formatNumber(stat['value'] as int),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: gradient,
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      fontSize: isMobile ? 28 : 24, // Increased from 24/20
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: color.withOpacity(0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Column(
      children: languages.take(isMobile ? 3 : 5).map((language) {
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
                child: Text(
                  language.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
