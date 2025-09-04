import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';

class ModernEnhancedAiInsightCard extends StatefulWidget {
  final EnhancedAiInsight enhancedInsight;

  const ModernEnhancedAiInsightCard({
    super.key,
    required this.enhancedInsight,
  });

  @override
  State<ModernEnhancedAiInsightCard> createState() =>
      _ModernEnhancedAiInsightCardState();
}

class _ModernEnhancedAiInsightCardState
    extends State<ModernEnhancedAiInsightCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  final List<InsightConfig> _insights = [
    InsightConfig(
      title: 'Repository Summary',
      icon: Icons.description_outlined,
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
      accentColor: Color(0xFF667eea),
    ),
    InsightConfig(
      title: 'Language Analysis',
      icon: Icons.code_outlined,
      gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
      accentColor: Color(0xFFf093fb),
    ),
    InsightConfig(
      title: 'Contribution Patterns',
      icon: Icons.people_outline,
      gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      accentColor: Color(0xFF4facfe),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignTokens.durationSlow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(
                isDesktop ? DesignTokens.space8 : DesignTokens.space6,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(DesignTokens.radiusLg),
                  topRight: Radius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.space3),
                    decoration: BoxDecoration(
                      gradient: DesignTokens.primaryGradient(context),
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Analysis',
                          style: (DesignTokens.headingLg(context) ??
                                  const TextStyle())
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Powered by advanced machine learning',
                          style: (DesignTokens.bodySm(context) ??
                                  const TextStyle())
                              .copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.space3,
                      vertical: DesignTokens.space2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: DesignTokens.space1),
                        Text(
                          'PREMIUM',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation tabs
            Container(
              decoration: DesignTokens.modernCard(context),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(DesignTokens.space2),
                    child: Row(
                      children: _insights.asMap().entries.map((entry) {
                        int index = entry.key;
                        InsightConfig config = entry.value;
                        bool isSelected = _selectedIndex == index;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              _pageController.animateToPage(
                                index,
                                duration: DesignTokens.durationNormal,
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: DesignTokens.durationNormal,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.space1),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(colors: config.gradient)
                                    : null,
                                color: isSelected
                                    ? null
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusMd),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: config.accentColor
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      config.icon,
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                      size: 18,
                                    ),
                                    if (isDesktop) ...[
                                      const SizedBox(
                                          width: DesignTokens.space2),
                                      Flexible(
                                        child: Text(
                                          config.title,
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : theme.colorScheme.onSurface
                                                    .withOpacity(0.7),
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Content
                  SizedBox(
                    height: isDesktop ? 400 : 350,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      children: [
                        _buildInsightContent(
                          context,
                          widget.enhancedInsight.repositorySummary,
                          _insights[0],
                        ),
                        _buildInsightContent(
                          context,
                          widget.enhancedInsight.languageAnalysis,
                          _insights[1],
                        ),
                        _buildInsightContent(
                          context,
                          widget.enhancedInsight.contributionPatterns,
                          _insights[2],
                        ),
                      ],
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

  Widget _buildInsightContent(
    BuildContext context,
    IndividualAiInsight insight,
    InsightConfig config,
  ) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    if (!insight.hasContent) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: DesignTokens.space4),
            Text(
              'No ${config.title.toLowerCase()} available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    // Check if this is a fallback message (AI service unavailable)
    final isAiServiceError =
        insight.content.contains('AI analysis temporarily unavailable');

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        isDesktop ? DesignTokens.space8 : DesignTokens.space6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Insight header with animation
          Container(
            padding: const EdgeInsets.all(DesignTokens.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAiServiceError
                    ? [
                        Colors.orange.withOpacity(0.1),
                        Colors.orange.withOpacity(0.05),
                      ]
                    : [
                        config.accentColor.withOpacity(0.1),
                        config.accentColor.withOpacity(0.05),
                      ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: isAiServiceError
                    ? Colors.orange.withOpacity(0.3)
                    : config.accentColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space2),
                  decoration: BoxDecoration(
                    color: isAiServiceError
                        ? Colors.orange.withOpacity(0.2)
                        : config.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Icon(
                    isAiServiceError ? Icons.refresh : config.icon,
                    color:
                        isAiServiceError ? Colors.orange : config.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: DesignTokens.space3),
                Expanded(
                  child: Text(
                    config.title,
                    style:
                        (DesignTokens.headingMd(context) ?? const TextStyle())
                            .copyWith(
                      color:
                          isAiServiceError ? Colors.orange : config.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isAiServiceError)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.space2,
                      vertical: DesignTokens.space1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          size: 12,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: DesignTokens.space1),
                        Text(
                          'RETRY',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.space6),

          // Main content with enhanced typography
          Container(
            padding: const EdgeInsets.all(DesignTokens.space6),
            decoration: DesignTokens.modernCard(context, elevated: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText.rich(
                  _parseMarkdownText(insight.content, theme),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: DesignTokens.space4),

                // Metadata with improved styling
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: DesignTokens.space2),
                      Text(
                        'Generated ${_formatDate(insight.generatedAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space2,
                          vertical: DesignTokens.space1,
                        ),
                        decoration: BoxDecoration(
                          color: config.accentColor.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 12,
                              color: config.accentColor,
                            ),
                            const SizedBox(width: DesignTokens.space1),
                            Text(
                              'AI',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: config.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'just now';
      }
    } catch (e) {
      return 'recently';
    }
  }

  // Simple markdown parser for bold text
  TextSpan _parseMarkdownText(String text, ThemeData theme) {
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (final Match match in boldRegex.allMatches(text)) {
      // Add text before the bold part
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurface,
            fontSize: 16,
          ),
        ));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          color: theme.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
      ));
    }

    return TextSpan(children: spans);
  }
}

class InsightConfig {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final Color accentColor;

  InsightConfig({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.accentColor,
  });
}
