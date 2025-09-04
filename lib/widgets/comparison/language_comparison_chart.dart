import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/design_tokens.dart';
import '../../models/repository_analysis.dart';

class LanguageComparisonChart extends StatelessWidget {
  final RepositoryAnalysis analysis1;
  final RepositoryAnalysis analysis2;

  const LanguageComparisonChart({
    super.key,
    required this.analysis1,
    required this.analysis2,
  });

  @override
  Widget build(BuildContext context) {
    // Get top languages from both repositories
    final langs1 = _getTopLanguages(analysis1.languages);
    final langs2 = _getTopLanguages(analysis2.languages);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildChartsSection(context, langs1, langs2),
          const SizedBox(height: DesignTokens.space6),
          _buildLanguageComparison(context, langs1, langs2),
        ],
      ),
    );
  }

  List<MapEntry<String, double>> _getTopLanguages(LanguageData languages) {
    final total =
        languages.languages.values.fold<double>(0, (sum, bytes) => sum + bytes);
    if (total == 0) return [];

    final percentages = languages.languages.entries
        .map((e) => MapEntry(e.key, (e.value / total) * 100))
        .where((e) => e.value >= 1.0) // Only show languages with 1%+ usage
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return percentages.take(6).toList(); // Top 6 languages
  }

  Widget _buildChartsSection(
    BuildContext context,
    List<MapEntry<String, double>> langs1,
    List<MapEntry<String, double>> langs2,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: DesignTokens.glassmorphism(
        context,
        blur: 10,
        opacity: 0.05,
      ),
      child: Column(
        children: [
          _buildSectionHeader(context, 'Language Distribution'),
          const SizedBox(height: DesignTokens.space6),
          isMobile
              ? Column(
                  children: [
                    _buildPieChart(
                      context,
                      analysis1.fullName,
                      langs1,
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: DesignTokens.space4),
                    _buildPieChart(
                      context,
                      analysis2.fullName,
                      langs2,
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildPieChart(
                        context,
                        analysis1.fullName,
                        langs1,
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.space6),
                    Expanded(
                      child: _buildPieChart(
                        context,
                        analysis2.fullName,
                        langs2,
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.space2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: Icon(
            Icons.code_outlined,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: DesignTokens.space3),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(
    BuildContext context,
    String repoName,
    List<MapEntry<String, double>> languages,
    Color primaryColor,
  ) {
    final theme = Theme.of(context);

    if (languages.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(color: primaryColor.withOpacity(0.4), width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code_off,
                size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: DesignTokens.space3),
              Text(
                'No language data',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: primaryColor.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.space4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DesignTokens.radiusMd),
                topRight: Radius.circular(DesignTokens.radiusMd),
              ),
            ),
            child: Text(
              repoName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _createPieSections(languages, primaryColor),
                centerSpaceRadius: 50,
                sectionsSpace: 8,
                startDegreeOffset: -90,
                pieTouchData: PieTouchData(
                  enabled: false, // Disable touch to prevent interference
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createPieSections(
    List<MapEntry<String, double>> languages,
    Color baseColor,
  ) {
    final colors = _generateColors(baseColor, languages.length);

    return languages.asMap().entries.map((entry) {
      final index = entry.key;
      final lang = entry.value;

      return PieChartSectionData(
        value: lang.value,
        title: lang.value > 8.0
            ? '${lang.value.toStringAsFixed(0)}%'
            : '', // Only show labels for sections > 8%, no decimals
        radius: 50,
        color: colors[index],
        titleStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: _getContrastColor(colors[index]),
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 3,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.8, // Move labels even closer to center
      );
    }).toList();
  }

  List<Color> _generateColors(Color baseColor, int count) {
    final colors = <Color>[];
    final hsl = HSLColor.fromColor(baseColor);

    for (int i = 0; i < count; i++) {
      final saturation = (hsl.saturation - (i * 0.1)).clamp(0.3, 1.0);
      final lightness = (hsl.lightness + (i * 0.05)).clamp(0.3, 0.8);
      colors.add(
          hsl.withSaturation(saturation).withLightness(lightness).toColor());
    }

    return colors;
  }

  Widget _buildLanguageComparison(
    BuildContext context,
    List<MapEntry<String, double>> langs1,
    List<MapEntry<String, double>> langs2,
  ) {
    // Combine all unique languages
    final allLanguages = <String>{};
    allLanguages.addAll(langs1.map((e) => e.key));
    allLanguages.addAll(langs2.map((e) => e.key));

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: DesignTokens.glassmorphism(
        context,
        blur: 10,
        opacity: 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Language Breakdown'),
          const SizedBox(height: DesignTokens.space4),
          ...allLanguages.map((language) {
            final percent1 = _getLanguagePercent(langs1, language);
            final percent2 = _getLanguagePercent(langs2, language);
            return _buildLanguageRow(context, language, percent1, percent2);
          }).toList(),
        ],
      ),
    );
  }

  double _getLanguagePercent(
      List<MapEntry<String, double>> languages, String language) {
    final entry = languages.firstWhere(
      (e) => e.key == language,
      orElse: () => MapEntry(language, 0.0),
    );
    return entry.value;
  }

  Widget _buildLanguageRow(
    BuildContext context,
    String language,
    double percent1,
    double percent2,
  ) {
    final theme = Theme.of(context);
    final maxPercent = [percent1, percent2].reduce((a, b) => a > b ? a : b);
    final winner = percent1 > percent2 ? 1 : (percent2 > percent1 ? 2 : 0);

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.space3),
      padding: const EdgeInsets.all(DesignTokens.space5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.space3,
                  vertical: DesignTokens.space2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  border: Border.all(
                    color: _getLanguageColor(language),
                    width: 2,
                  ),
                ),
                child: Text(
                  language,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getLanguageColor(language),
                  ),
                ),
              ),
              const Spacer(),
              if (winner != 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space2,
                    vertical: DesignTokens.space1,
                  ),
                  decoration: BoxDecoration(
                    color: winner == 1
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusFull),
                  ),
                  child: Text(
                    'Repo $winner',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: winner == 1
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.space3),
          Row(
            children: [
              Expanded(
                child: _buildLanguageBar(
                  context,
                  analysis1.fullName,
                  percent1,
                  maxPercent,
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: DesignTokens.space4),
              Expanded(
                child: _buildLanguageBar(
                  context,
                  analysis2.fullName,
                  percent2,
                  maxPercent,
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBar(
    BuildContext context,
    String repoName,
    double percent,
    double maxPercent,
    Color color,
  ) {
    final theme = Theme.of(context);
    final normalizedPercent = maxPercent > 0 ? percent / maxPercent : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              repoName.split('/')[1], // Show only repo name
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${percent.toStringAsFixed(1)}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.space2),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: normalizedPercent.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getLanguageColor(String language) {
    // Define colors for common programming languages
    const languageColors = {
      'JavaScript': Color(0xFFF7DF1E),
      'TypeScript': Color(0xFF3178C6),
      'Python': Color(0xFF3776AB),
      'Java': Color(0xFFED8B00),
      'C++': Color(0xFF00599C),
      'C#': Color(0xFF239120),
      'Dart': Color(0xFF0175C2),
      'Swift': Color(0xFFFA7343),
      'Kotlin': Color(0xFF0095D5),
      'Go': Color(0xFF00ADD8),
      'Rust': Color(0xFF000000),
      'PHP': Color(0xFF777BB4),
      'Ruby': Color(0xFFCC342D),
      'HTML': Color(0xFFE34F26),
      'CSS': Color(0xFF1572B6),
      'Shell': Color(0xFF89E051),
    };

    return languageColors[language] ?? const Color(0xFF6B7280);
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calculate luminance to determine if we need dark or light text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
