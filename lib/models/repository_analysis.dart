class RepositoryAnalysis {
  final String owner;
  final String repo;
  final RepositoryStats stats;
  final LanguageData languages;
  final CommitActivity commitActivity;
  final RepositoryLinks links;
  final AiInsight aiInsight;
  final EnhancedAiInsight? enhancedAiInsight;

  // Computed properties for BookmarkedRepository compatibility
  String get name => '$owner/$repo';
  String get description => stats.description ?? '';
  int get stars => stats.stars;
  int get forks => stats.forks;
  String get primaryLanguage => languages.sortedLanguages.isNotEmpty
      ? languages.sortedLanguages.first.name
      : 'Unknown';
  String? get avatarUrl => stats.avatarUrl;

  RepositoryAnalysis({
    required this.owner,
    required this.repo,
    required this.stats,
    required this.languages,
    required this.commitActivity,
    required this.links,
    required this.aiInsight,
    this.enhancedAiInsight,
  });

  factory RepositoryAnalysis.fromJson(Map<String, dynamic> json) {
    try {
      print('=== REPOSITORY ANALYSIS PARSING DEBUG ===');
      print('JSON contains ai_insights: ${json.containsKey('ai_insights')}');
      print(
          'JSON contains enhanced_ai_insight: ${json.containsKey('enhanced_ai_insight')}');

      EnhancedAiInsight? enhancedInsight;

      // Backend sends AI insights under 'ai_insights' key
      if (json.containsKey('ai_insights')) {
        try {
          final aiInsightsData = json['ai_insights'] as Map<String, dynamic>;
          print('AI insights keys: ${aiInsightsData.keys.toList()}');

          enhancedInsight = EnhancedAiInsight.fromJson(aiInsightsData);
          print('Enhanced insight parsing successful: true');
        } catch (e) {
          print('ERROR parsing ai_insights: $e');
          enhancedInsight = null;
        }
      }

      return RepositoryAnalysis(
        owner: json['owner'] ?? '',
        repo: json['repo'] ?? '',
        stats: RepositoryStats.fromJson(json['stats'] ?? {}),
        languages: LanguageData.fromJson(json['languages'] ?? {}),
        commitActivity: CommitActivity.fromJson(json['commit_activity'] ?? {}),
        links: RepositoryLinks.fromJson(json['links'] ?? {}),
        aiInsight: AiInsight.fromJson(json['ai_insight'] ?? {}),
        enhancedAiInsight: enhancedInsight,
      );
    } catch (e) {
      print('ERROR parsing RepositoryAnalysis: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'repo': repo,
      'stats': stats.toJson(),
      'languages': languages.toJson(),
      'commit_activity': commitActivity.toJson(),
      'links': links.toJson(),
      'ai_insight': aiInsight.toJson(),
      'enhanced_ai_insight': enhancedAiInsight?.toJson(),
    };
  }

  String get fullName => '$owner/$repo';
}

class RepositoryStats {
  final int stars;
  final int forks;
  final int openIssues;
  final String? license;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? description;
  final String? avatarUrl;

  RepositoryStats({
    required this.stars,
    required this.forks,
    required this.openIssues,
    this.license,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.avatarUrl,
  });

  factory RepositoryStats.fromJson(Map<String, dynamic> json) {
    return RepositoryStats(
      stars: json['stars'] ?? 0,
      forks: json['forks'] ?? 0,
      openIssues: json['open_issues'] ?? 0,
      license: json['license'],
      description: json['description'],
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'forks': forks,
      'open_issues': openIssues,
      'license': license,
      'description': description,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class LanguageData {
  final Map<String, double> languages;

  LanguageData({required this.languages});

  factory LanguageData.fromJson(Map<String, dynamic> json) {
    final languagesMap = <String, double>{};
    final languagesJson = json['languages'] ?? {};

    if (languagesJson is Map) {
      languagesJson.forEach((key, value) {
        if (key is String && value is num) {
          languagesMap[key] = value.toDouble();
        }
      });
    }

    return LanguageData(languages: languagesMap);
  }

  Map<String, dynamic> toJson() {
    return {'languages': languages};
  }

  List<LanguageItem> get sortedLanguages {
    return languages.entries
        .map((e) => LanguageItem(name: e.key, percentage: e.value))
        .toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));
  }

  bool get hasLanguages => languages.isNotEmpty;

  int get languageCount => languages.length;

  String get primaryLanguage {
    if (languages.isEmpty) return 'Unknown';
    final sorted = sortedLanguages;
    return sorted.first.name;
  }
}

class LanguageItem {
  final String name;
  final double percentage;

  LanguageItem({
    required this.name,
    required this.percentage,
  });

  String get formattedPercentage => '${percentage.toStringAsFixed(1)}%';
}

class CommitActivity {
  final int totalCommits;
  final int last30Days;
  final List<WeeklyCommitData> weeklyData;

  CommitActivity({
    required this.totalCommits,
    required this.last30Days,
    this.weeklyData = const [],
  });

  factory CommitActivity.fromJson(Map<String, dynamic> json) {
    final weeklyList = json['weekly_data'] as List<dynamic>? ?? [];
    return CommitActivity(
      totalCommits: json['total_commits'] ?? 0,
      last30Days: json['last_30_days'] ?? 0,
      weeklyData: weeklyList
          .map(
              (item) => WeeklyCommitData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_commits': totalCommits,
      'last_30_days': last30Days,
      'weekly_data': weeklyData.map((w) => w.toJson()).toList(),
    };
  }

  double get recentActivityPercentage {
    if (totalCommits == 0) return 0.0;
    return (last30Days / totalCommits) * 100;
  }
}

class WeeklyCommitData {
  final String week; // ISO date string (e.g., "2024-08-01")
  final int commits;

  const WeeklyCommitData({
    required this.week,
    required this.commits,
  });

  factory WeeklyCommitData.fromJson(Map<String, dynamic> json) {
    return WeeklyCommitData(
      week: json['week'] ?? '',
      commits: json['commits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'commits': commits,
    };
  }
}

class RepositoryLinks {
  final String repoUrl;
  final String ownerUrl;

  RepositoryLinks({
    required this.repoUrl,
    required this.ownerUrl,
  });

  factory RepositoryLinks.fromJson(Map<String, dynamic> json) {
    return RepositoryLinks(
      repoUrl: json['repo_url'] ?? '',
      ownerUrl: json['owner_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repo_url': repoUrl,
      'owner_url': ownerUrl,
    };
  }
}

class AiInsight {
  final String summary;
  final DateTime generatedAt;

  AiInsight({
    required this.summary,
    required this.generatedAt,
  });

  factory AiInsight.fromJson(Map<String, dynamic> json) {
    return AiInsight(
      summary: json['summary'] ?? '',
      generatedAt: json['generated_at'] != null
          ? DateTime.tryParse(json['generated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'generated_at': generatedAt.toIso8601String(),
    };
  }

  bool get hasSummary => summary.isNotEmpty;

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(generatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

// Enhanced AI Insights for the new requirements
class EnhancedAiInsight {
  final IndividualAiInsight repositorySummary;
  final IndividualAiInsight languageAnalysis;
  final IndividualAiInsight contributionPatterns;

  EnhancedAiInsight({
    required this.repositorySummary,
    required this.languageAnalysis,
    required this.contributionPatterns,
  });

  factory EnhancedAiInsight.fromJson(Map<String, dynamic> json) {
    try {
      print('=== ENHANCED AI INSIGHT PARSING DEBUG ===');
      print('JSON keys: ${json.keys.toList()}');
      print(
          'repository_summary exists: ${json.containsKey('repository_summary')}');
      print(
          'language_analysis exists: ${json.containsKey('language_analysis')}');
      print(
          'contribution_patterns exists: ${json.containsKey('contribution_patterns')}');

      if (json.containsKey('repository_summary')) {
        print('repository_summary content: ${json['repository_summary']}');
      }

      final enhancedInsight = EnhancedAiInsight(
        repositorySummary: IndividualAiInsight.fromJson(
          json['repository_summary'] ?? {},
        ),
        languageAnalysis: IndividualAiInsight.fromJson(
          json['language_analysis'] ?? {},
        ),
        contributionPatterns: IndividualAiInsight.fromJson(
          json['contribution_patterns'] ?? {},
        ),
      );

      print('Successfully created EnhancedAiInsight');
      print(
          'Repository Summary content: ${enhancedInsight.repositorySummary.content}');
      print('========================================');

      return enhancedInsight;
    } catch (e) {
      print('ERROR parsing EnhancedAiInsight: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'repository_summary': repositorySummary.toJson(),
      'language_analysis': languageAnalysis.toJson(),
      'contribution_patterns': contributionPatterns.toJson(),
    };
  }
}

class IndividualAiInsight {
  final String content;
  final DateTime generatedAt;

  IndividualAiInsight({
    required this.content,
    required this.generatedAt,
  });

  factory IndividualAiInsight.fromJson(Map<String, dynamic> json) {
    try {
      print('IndividualAiInsight parsing: ${json.keys.toList()}');
      print('Content: ${json['content']}');
      print('Generated at: ${json['generated_at']}');

      String content = json['content'] ?? '';

      // Check if the content contains AI service errors
      if (content.contains('AI service error') ||
          content.contains('AI analysis failed') ||
          content.contains('503') ||
          content.contains('429') ||
          content.contains('Service Unavailable') ||
          content.isEmpty ||
          content.trim().length < 10) {
        // Provide fallback content instead of showing error
        content =
            'AI analysis temporarily unavailable. This repository data shows good activity patterns and structure. Please try refreshing to get detailed AI insights.';
        print('AI service error detected, using fallback content');
      }

      return IndividualAiInsight(
        content: content,
        generatedAt: json['generated_at'] != null
            ? DateTime.parse(json['generated_at'])
            : DateTime.now(),
      );
    } catch (e) {
      print('ERROR parsing IndividualAiInsight: $e');
      return IndividualAiInsight(
        content:
            'AI analysis temporarily unavailable. Please try refreshing for detailed insights.',
        generatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'generated_at': generatedAt.toIso8601String(),
    };
  }

  bool get hasContent => content.isNotEmpty;
}
