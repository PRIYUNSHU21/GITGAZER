import 'package:flutter/material.dart';
import '../core/constants/design_tokens.dart';
import '../core/services/github_service.dart';
import '../models/repository_analysis.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/comparison/repository_selector.dart';
import '../widgets/comparison/comparison_results.dart';

class RepositoryCompareScreen extends StatefulWidget {
  const RepositoryCompareScreen({super.key});

  @override
  State<RepositoryCompareScreen> createState() =>
      _RepositoryCompareScreenState();
}

class _RepositoryCompareScreenState extends State<RepositoryCompareScreen>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();

  // Repository 1 controllers
  final _owner1Controller = TextEditingController();
  final _repo1Controller = TextEditingController();

  // Repository 2 controllers
  final _owner2Controller = TextEditingController();
  final _repo2Controller = TextEditingController();

  RepositoryAnalysis? _analysis1;
  RepositoryAnalysis? _analysis2;

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _owner1Controller.dispose();
    _repo1Controller.dispose();
    _owner2Controller.dispose();
    _repo2Controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _compareRepositories() async {
    if (_owner1Controller.text.isEmpty ||
        _repo1Controller.text.isEmpty ||
        _owner2Controller.text.isEmpty ||
        _repo2Controller.text.isEmpty) {
      _showError('Please fill in all repository fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _analysis1 = null;
      _analysis2 = null;
    });

    try {
      // Analyze both repositories in parallel
      final futures = await Future.wait([
        GitHubService.analyzeRepository(
          _owner1Controller.text.trim(),
          _repo1Controller.text.trim(),
        ),
        GitHubService.analyzeRepository(
          _owner2Controller.text.trim(),
          _repo2Controller.text.trim(),
        ),
      ]);

      setState(() {
        _analysis1 = futures[0];
        _analysis2 = futures[1];
        _isLoading = false;
      });

      // Scroll to results
      _scrollToResults();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to analyze repositories: ${e.toString()}';
      });
    }
  }

  void _scrollToResults() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        600,
        duration: DesignTokens.durationSlow,
        curve: Curves.easeInOut,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
      ),
    );
  }

  void _clearComparison() {
    setState(() {
      _analysis1 = null;
      _analysis2 = null;
      _errorMessage = null;
    });

    _owner1Controller.clear();
    _repo1Controller.clear();
    _owner2Controller.clear();
    _repo2Controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildBody(theme),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.space2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              Icons.compare_arrows_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: DesignTokens.space3),
          Flexible(
            child: Text(
              isMobile ? 'Compare' : 'Repository Comparison',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      actions: [
        if (_analysis1 != null || _analysis2 != null)
          IconButton(
            onPressed: _clearComparison,
            icon: const Icon(Icons.clear_all_rounded),
            tooltip: 'Clear comparison',
          ),
        const SizedBox(width: DesignTokens.space2),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      controller: _scrollController,
      padding:
          EdgeInsets.all(isMobile ? DesignTokens.space4 : DesignTokens.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(theme),
          const SizedBox(height: DesignTokens.space8),
          _buildRepositoryInputs(theme),
          const SizedBox(height: DesignTokens.space8),
          _buildActionButton(theme),
          if (_isLoading) ...[
            const SizedBox(height: DesignTokens.space8),
            _buildLoadingSection(),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: DesignTokens.space8),
            _buildErrorSection(theme),
          ],
          if (_analysis1 != null && _analysis2 != null) ...[
            const SizedBox(height: DesignTokens.space8),
            _buildComparisonResults(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding:
          EdgeInsets.all(isMobile ? DesignTokens.space6 : DesignTokens.space8),
      decoration: DesignTokens.glassmorphism(
        context,
        blur: 15,
        opacity: 0.05,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.space4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: isMobile ? 36 : 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: DesignTokens.space6),
          Text(
            'Compare Repositories',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: isMobile ? 20 : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.space3),
          Text(
            'Analyze and compare two GitHub repositories side by side.\nGet insights on stats, languages, commit activity, and AI analysis.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
              fontSize: isMobile ? 14 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepositoryInputs(ThemeData theme) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return Column(
        children: [
          RepositorySelector(
            title: 'Repository 1',
            ownerController: _owner1Controller,
            repoController: _repo1Controller,
            icon: Icons.folder_outlined,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: DesignTokens.space4),
          Container(
            padding: const EdgeInsets.all(DesignTokens.space3),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Icon(
              Icons.compare_arrows_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          RepositorySelector(
            title: 'Repository 2',
            ownerController: _owner2Controller,
            repoController: _repo2Controller,
            icon: Icons.folder_outlined,
            color: theme.colorScheme.secondary,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: RepositorySelector(
            title: 'Repository 1',
            ownerController: _owner1Controller,
            repoController: _repo1Controller,
            icon: Icons.folder_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: DesignTokens.space4),
        Container(
          padding: const EdgeInsets.all(DesignTokens.space3),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          ),
          child: Icon(
            Icons.compare_arrows_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: DesignTokens.space4),
        Expanded(
          child: RepositorySelector(
            title: 'Repository 2',
            ownerController: _owner2Controller,
            repoController: _repo2Controller,
            icon: Icons.folder_outlined,
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _compareRepositories,
        icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.analytics),
        label: Text(_isLoading ? 'Analyzing...' : 'Compare Repositories'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.space8,
            vertical: DesignTokens.space4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          elevation: DesignTokens.elevationMd,
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space8),
      decoration: DesignTokens.glassmorphism(context),
      child: Column(
        children: [
          const LoadingWidget(message: 'Analyzing repositories...'),
          const SizedBox(height: DesignTokens.space4),
          Text(
            'This may take a few moments while we fetch and analyze both repositories.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: DesignTokens.space3),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonResults(ThemeData theme) {
    return ComparisonResults(
      analysis1: _analysis1!,
      analysis2: _analysis2!,
    );
  }
}
