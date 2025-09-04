import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/design_tokens.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/feature_cards.dart';
import '../widgets/home/search_section.dart';
import '../widgets/home/popular_repos.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _ownerController = TextEditingController();
  final _repoController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _repoController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _analyzeRepository() async {
    if (!_formKey.currentState!.validate()) return;

    // Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    try {
      // Navigate to dashboard screen with the repository info
      await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DashboardScreen(
            owner: _ownerController.text.trim(),
            repo: _repoController.text.trim(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: DesignTokens.durationNormal,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1600;
    final isTablet = size.width > 768 && size.width <= 1600;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1200 : double.infinity,
            ),
            margin: EdgeInsets.symmetric(
              horizontal:
                  isDesktop ? DesignTokens.space16 : DesignTokens.space6,
            ),
            child: Column(
              children: [
                // Hero Section
                HeroSection(
                  isDesktop: isDesktop,
                  isTablet: isTablet,
                ),

                SizedBox(height: DesignTokens.space12),

                // Search Section with extra padding
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        isDesktop ? DesignTokens.space8 : DesignTokens.space4,
                  ),
                  child: SearchSection(
                    formKey: _formKey,
                    ownerController: _ownerController,
                    repoController: _repoController,
                    isLoading: _isLoading,
                    onAnalyze: _analyzeRepository,
                    isDesktop: isDesktop,
                  ),
                ),

                SizedBox(height: DesignTokens.space12),

                // Popular Repositories Section
                PopularReposSection(
                  onRepositoryTap: (owner, repo) {
                    _ownerController.text = owner;
                    _repoController.text = repo;
                    // Optionally auto-analyze
                    // _analyzeRepository();
                  },
                  isDesktop: isDesktop,
                ),

                SizedBox(height: DesignTokens.space12),

                // Feature Cards
                FeatureCards(isDesktop: isDesktop),

                SizedBox(height: DesignTokens.space16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
