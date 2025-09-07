import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';

class HeroSection extends StatefulWidget {
  final bool isDesktop;
  final bool isTablet;

  const HeroSection({
    super.key,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Floating animation controller
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Logo scale and rotation animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Floating animation
    _floatingAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Fade in animation
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Start animations
    _logoController.forward();
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: widget.isDesktop ? 600 : 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: DesignTokens.surfaceGradient(context),
      ),
      child: Stack(
        children: [
          // Animated background elements
          ..._buildBackgroundElements(context),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                _buildAnimatedLogo(context),

                SizedBox(height: widget.isDesktop ? 25 : 20),

                // Title with animation
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _logoController,
                      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                    )),
                    child: Text(
                      'GITGAZER',
                      style: TextStyle(
                        fontSize: widget.isDesktop ? 56 : 40,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 3.0,
                        height: 1.0,
                        shadows: [
                          Shadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: widget.isDesktop ? 50 : 35),

                // Feature badges with staggered animation
                _buildFeatureBadges(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoScaleAnimation,
        _floatingAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _floatingAnimation,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: widget.isDesktop ? 140 : 120,
                height: widget.isDesktop ? 140 : 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: DesignTokens.primaryGradient(context),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: _logoRotationAnimation.value * 0.1,
                  child: Icon(
                    Icons.analytics_rounded,
                    size: widget.isDesktop ? 70 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureBadges(BuildContext context) {
    final features = [
      {'icon': Icons.psychology_outlined, 'text': 'AI Analysis'},
      {'icon': Icons.insert_chart_outlined, 'text': 'Interactive Charts'},
      {'icon': Icons.people_outline, 'text': 'Contributor Insights'},
      {'icon': Icons.trending_up_outlined, 'text': 'Activity Tracking'},
    ];

    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
        )),
        child: Wrap(
          spacing: widget.isDesktop ? 20 : 12,
          runSpacing: widget.isDesktop ? 16 : 12,
          alignment: WrapAlignment.center,
          children: features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 800 + (index * 200)),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: _buildFeatureBadge(
                    context,
                    feature['icon'] as IconData,
                    feature['text'] as String,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop ? 20 : 16,
        vertical: widget.isDesktop ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: widget.isDesktop ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundElements(BuildContext context) {
    final theme = Theme.of(context);

    return [
      // Floating circles
      Positioned(
        top: 50,
        left: 30,
        child: _buildFloatingCircle(theme.colorScheme.primary.withOpacity(0.1),
            widget.isDesktop ? 80 : 50, 3),
      ),
      Positioned(
        top: 200,
        right: 50,
        child: _buildFloatingCircle(
            theme.colorScheme.secondary.withOpacity(0.1),
            widget.isDesktop ? 120 : 70,
            4),
      ),
      Positioned(
        bottom: 100,
        left: 80,
        child: _buildFloatingCircle(theme.colorScheme.tertiary.withOpacity(0.1),
            widget.isDesktop ? 60 : 40, 2.5),
      ),
      Positioned(
        bottom: 50,
        right: 100,
        child: _buildFloatingCircle(theme.colorScheme.primary.withOpacity(0.08),
            widget.isDesktop ? 100 : 60, 3.5),
      ),
    ];
  }

  Widget _buildFloatingCircle(Color color, double size, double duration) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: duration.toInt()),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            0,
            (value * 20 * (duration / 3)) - (10 * (duration / 3)),
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
    );
  }
}
