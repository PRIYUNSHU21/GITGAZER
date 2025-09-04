import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';

class FeatureCards extends StatelessWidget {
  final bool isDesktop;

  const FeatureCards({
    super.key,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What You Get',
          style: DesignTokens.headingMd(context),
        ),
        const SizedBox(height: DesignTokens.space6),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopLayout = isDesktop || constraints.maxWidth > 1024;
            final isTablet =
                constraints.maxWidth > 768 && constraints.maxWidth <= 1024;

            if (isDesktopLayout) {
              return Row(
                children: [
                  Expanded(child: _buildFeatureCard(context, _features[0])),
                  const SizedBox(width: DesignTokens.space4),
                  Expanded(child: _buildFeatureCard(context, _features[1])),
                  const SizedBox(width: DesignTokens.space4),
                  Expanded(child: _buildFeatureCard(context, _features[2])),
                ],
              );
            } else if (isTablet) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildFeatureCard(context, _features[0])),
                      const SizedBox(width: DesignTokens.space4),
                      Expanded(child: _buildFeatureCard(context, _features[1])),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.space4),
                  _buildFeatureCard(context, _features[2]),
                ],
              );
            } else {
              return Column(
                children: _features
                    .map((feature) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: DesignTokens.space4),
                          child: _buildFeatureCard(context, feature),
                        ))
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, FeatureData feature) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: DesignTokens.glassmorphism(context, opacity: 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.space3),
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            ),
            child: Icon(
              feature.icon,
              color: feature.color,
              size: 32,
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            feature.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DesignTokens.space2),
          Text(
            feature.description,
            style: DesignTokens.bodySm(context)?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          Wrap(
            spacing: DesignTokens.space2,
            runSpacing: DesignTokens.space1,
            children: feature.tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.space2,
                        vertical: DesignTokens.space1,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  static final List<FeatureData> _features = [
    FeatureData(
      icon: Icons.psychology_outlined,
      title: 'AI-Powered Analysis',
      description:
          'Get intelligent insights about repository structure, code quality, and development patterns using advanced AI analysis.',
      color: Colors.purple,
      tags: ['Smart Insights', 'Code Analysis', 'Pattern Recognition'],
    ),
    FeatureData(
      icon: Icons.analytics_outlined,
      title: 'Interactive Visualizations',
      description:
          'Explore repository data through beautiful charts, graphs, and interactive visualizations that make complex data easy to understand.',
      color: Colors.blue,
      tags: ['Charts', 'Graphs', 'Data Viz'],
    ),
    FeatureData(
      icon: Icons.people_outline,
      title: 'Contributor Insights',
      description:
          'Understand team dynamics, contribution patterns, and collaboration metrics to improve project management.',
      color: Colors.green,
      tags: ['Team Analytics', 'Collaboration', 'Metrics'],
    ),
  ];
}

class FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> tags;

  FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.tags,
  });
}
