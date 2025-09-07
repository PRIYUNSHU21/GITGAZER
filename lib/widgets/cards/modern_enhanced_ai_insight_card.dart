import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';

// Content section types for better text processing
enum SectionType {
  heading,
  paragraph,
  list,
}

// Structured content section
class ContentSection {
  SectionType type;
  String content;
  List<String> items;

  ContentSection({
    required this.type,
    required this.content,
    required this.items,
  });
}

// Tab configuration for insights
class InsightTab {
  final String title;
  final IconData icon;
  final Color color;

  const InsightTab({
    required this.title,
    required this.icon,
    required this.color,
  });
}

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
  late TabController _tabController;

  final List<InsightTab> _tabs = [
    InsightTab(
      title: 'Summary',
      icon: Icons.description_outlined,
      color: Colors.blue,
    ),
    InsightTab(
      title: 'Languages',
      icon: Icons.code_outlined,
      color: Colors.green,
    ),
    InsightTab(
      title: 'Activity',
      icon: Icons.timeline_outlined,
      color: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive width constraints - increased for wider card
    final maxWidth = screenWidth > 1400
        ? screenWidth * 0.95 // Very wide screens: 95% of screen width
        : screenWidth > 1024
            ? screenWidth * 0.92 // Desktop: 92% of screen width
            : screenWidth > 768
                ? screenWidth * 0.95 // Tablet: 95% of screen width
                : screenWidth - 32; // Mobile: full width minus smaller padding

    // Minimal margins for wider appearance
    final cardMargin = screenWidth > 1024
        ? const EdgeInsets.symmetric(
            horizontal: DesignTokens.space2,
            vertical: DesignTokens.space4) // Much less margin on desktop
        : screenWidth > 768
            ? const EdgeInsets.symmetric(
                horizontal: DesignTokens.space3,
                vertical: DesignTokens.space4) // Less margin on tablet
            : const EdgeInsets.symmetric(
                horizontal: DesignTokens.space4, vertical: DesignTokens.space4);

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: 400,
        maxHeight: 700,
      ),
      child: Card(
        elevation: 2,
        margin: cardMargin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: screenWidth > 1024
                  ? const EdgeInsets.all(
                      DesignTokens.space6) // More padding on desktop
                  : const EdgeInsets.all(DesignTokens.space5),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(DesignTokens.radiusLg),
                  topRight: Radius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    color: colorScheme.primary,
                    size: 28, // Larger icon
                  ),
                  const SizedBox(width: DesignTokens.space4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'AI Analysis',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space1),
                        Text(
                          'Intelligent insights powered by advanced AI',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space3),
                  Chip(
                    label: const Text('AI'),
                    backgroundColor: colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: _tabs
                  .map((tab) => Tab(
                        icon: Icon(tab.icon, size: 24), // Only show icon
                      ))
                  .toList(),
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: colorScheme.outline.withOpacity(0.2),
              padding:
                  const EdgeInsets.symmetric(horizontal: DesignTokens.space4),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInsightContent(
                      widget.enhancedInsight.repositorySummary, _tabs[0]),
                  _buildInsightContent(
                      widget.enhancedInsight.languageAnalysis, _tabs[1]),
                  _buildInsightContent(
                      widget.enhancedInsight.contributionPatterns, _tabs[2]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightContent(IndividualAiInsight insight, InsightTab tab) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    if (!insight.hasContent) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: DesignTokens.space3),
            Text(
              'No ${tab.title.toLowerCase()} available',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    final isError =
        insight.content.contains('AI analysis temporarily unavailable');

    return SingleChildScrollView(
      padding: screenWidth > 1024
          ? const EdgeInsets.all(DesignTokens.space6) // More padding on desktop
          : const EdgeInsets.all(DesignTokens.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content Header
          Container(
            width: double.infinity,
            padding: screenWidth > 1024
                ? const EdgeInsets.all(DesignTokens.space5)
                : const EdgeInsets.all(DesignTokens.space4),
            decoration: BoxDecoration(
              color: isError
                  ? colorScheme.errorContainer
                  : tab.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: isError ? colorScheme.error : tab.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space2),
                  decoration: BoxDecoration(
                    color: isError
                        ? colorScheme.error.withOpacity(0.1)
                        : tab.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  ),
                  child: Icon(
                    isError ? Icons.warning_amber : tab.icon,
                    color: isError ? colorScheme.error : tab.color,
                    size: 24, // Larger icon
                  ),
                ),
                const SizedBox(width: DesignTokens.space4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tab.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isError ? colorScheme.error : tab.color,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isError) ...[
                        const SizedBox(height: DesignTokens.space1),
                        Text(
                          'Detailed analysis and insights',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isError) ...[
                  const SizedBox(width: DesignTokens.space3),
                  TextButton.icon(
                    onPressed: () {
                      // Handle retry
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      textStyle: theme.textTheme.labelMedium,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.space3,
                        vertical: DesignTokens.space2,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.space4),

          // Main Content
          Container(
            width: double.infinity,
            padding: screenWidth > 1024
                ? const EdgeInsets.all(
                    DesignTokens.space6) // More padding on desktop
                : const EdgeInsets.all(DesignTokens.space5),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Formatted Content
                _buildFormattedContent(insight.content, theme, colorScheme),

                const SizedBox(height: DesignTokens.space5),

                // Copy Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // Copy functionality would be implemented here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Content copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      textStyle: theme.textTheme.labelMedium,
                    ),
                  ),
                ),

                const SizedBox(height: DesignTokens.space4),

                // Metadata
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.space4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: DesignTokens.space3),
                      Expanded(
                        child: Text(
                          'Generated ${_formatTimestamp(insight.generatedAt)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space3,
                          vertical: DesignTokens.space2,
                        ),
                        decoration: BoxDecoration(
                          color: tab.color.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.smart_toy,
                              size: 14,
                              color: tab.color,
                            ),
                            const SizedBox(width: DesignTokens.space2),
                            Text(
                              'AI Generated',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: tab.color,
                                fontWeight: FontWeight.w500,
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

  Widget _buildFormattedContent(
      String content, ThemeData theme, ColorScheme colorScheme) {
    // Clean and preprocess the content - remove all ** markers first
    final cleanedContent = content.trim().replaceAll('**', '');

    // Split content into logical sections
    final sections = _parseContentSections(cleanedContent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.space4),
          child: _buildContentSection(section, theme, colorScheme),
        );
      }).toList(),
    );
  }

  List<ContentSection> _parseContentSections(String content) {
    final sections = <ContentSection>[];
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty);

    ContentSection? currentSection;

    for (final line in lines) {
      final trimmed = line.trim();

      // Check if it's a heading
      if (_isHeading(trimmed)) {
        // Save previous section if exists
        if (currentSection != null) {
          sections.add(currentSection);
        }

        // Start new section
        currentSection = ContentSection(
          type: SectionType.heading,
          content: _cleanHeading(trimmed),
          items: [],
        );
      }
      // Check if it's a list item
      else if (_isListItem(trimmed)) {
        if (currentSection == null) {
          currentSection = ContentSection(
            type: SectionType.paragraph,
            content: '',
            items: [],
          );
        }

        currentSection.items.add(_cleanListItem(trimmed));
        currentSection.type = SectionType.list;
      }
      // Regular content
      else {
        if (currentSection == null ||
            currentSection.type == SectionType.heading) {
          // Save previous section if it was a heading
          if (currentSection != null) {
            sections.add(currentSection);
          }

          // Start new paragraph section
          currentSection = ContentSection(
            type: SectionType.paragraph,
            content: trimmed,
            items: [],
          );
        } else {
          // Append to current paragraph
          currentSection.content +=
              (currentSection.content.isEmpty ? '' : ' ') + trimmed;
        }
      }
    }

    // Add the last section
    if (currentSection != null) {
      sections.add(currentSection);
    }

    return sections;
  }

  bool _isHeading(String text) {
    // Check for various heading patterns
    final upperCaseWords = text
        .split(' ')
        .where((word) => word.isNotEmpty && word[0].toUpperCase() == word[0]);

    // If more than 60% of words start with uppercase, likely a heading
    if (upperCaseWords.length / text.split(' ').length > 0.6 &&
        text.length < 80) {
      return true;
    }

    // Check for common heading patterns
    return text.endsWith(':') ||
        text.startsWith('**') && text.endsWith('**') ||
        text.toUpperCase() == text && text.length < 50;
  }

  bool _isListItem(String text) {
    // Check for bullet points or numbered lists
    return text.startsWith('•') ||
        text.startsWith('-') ||
        text.startsWith('*') ||
        RegExp(r'^\d+\.').hasMatch(text) ||
        text.startsWith('**') && text.contains('**') && text.length < 100;
  }

  String _cleanHeading(String text) {
    // Remove markdown bold markers
    if (text.startsWith('**') && text.endsWith('**')) {
      return text.substring(2, text.length - 2);
    }
    // Remove colon if present
    if (text.endsWith(':')) {
      return text.substring(0, text.length - 1);
    }
    // Remove any remaining ** markers
    return text.replaceAll('**', '');
  }

  String _cleanListItem(String text) {
    // Remove bullet markers
    if (text.startsWith('•') || text.startsWith('-') || text.startsWith('*')) {
      return text.substring(1).trim();
    }
    // Remove numbered list markers
    final numberMatch = RegExp(r'^\d+\.\s*').firstMatch(text);
    if (numberMatch != null) {
      return text.substring(numberMatch.end);
    }
    // Remove all markdown bold markers
    return text.replaceAll('**', '').trim();
  }

  Widget _buildContentSection(
      ContentSection section, ThemeData theme, ColorScheme colorScheme) {
    switch (section.type) {
      case SectionType.heading:
        return _buildHeadingSection(section.content, theme, colorScheme);

      case SectionType.list:
        return _buildListSection(section.items, theme, colorScheme);

      case SectionType.paragraph:
        return _buildParagraphSection(section.content, theme, colorScheme);
    }
  }

  Widget _buildHeadingSection(
      String heading, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.space2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Text(
        heading,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildListSection(
      List<String> items, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: DesignTokens.space3, left: DesignTokens.space2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom bullet point
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.space4),
              Expanded(
                child: _buildRichTextWithBold(
                  item,
                  theme,
                  colorScheme,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParagraphSection(
      String content, ThemeData theme, ColorScheme colorScheme) {
    // Check if content contains bold text
    if (content.contains('**')) {
      return _buildRichTextWithBold(content, theme, colorScheme);
    }

    // Split long paragraphs into more readable chunks
    final sentences = content.split('.').where((s) => s.trim().isNotEmpty);

    if (sentences.length <= 2) {
      // Short paragraph - remove any ** markers
      final cleanedContent = content.replaceAll('**', '');
      return SelectableText(
        cleanedContent,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.8,
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
      );
    }

    // Long paragraph - format as bullet points for better readability
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sentences.map((sentence) {
        final trimmed = sentence.trim();
        if (trimmed.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.space3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: DesignTokens.space4),
              Expanded(
                child: SelectableText(
                  '${trimmed.replaceAll('**', '')}.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRichTextWithBold(
      String text, ThemeData theme, ColorScheme colorScheme,
      {double fontSize = 16}) {
    // Since we remove ** markers upfront, just display the cleaned text
    return SelectableText(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        height: 1.8,
        color: colorScheme.onSurface,
        fontSize: fontSize,
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
