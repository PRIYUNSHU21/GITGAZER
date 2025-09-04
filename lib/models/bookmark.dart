import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 0)
class BookmarkedRepository extends HiveObject {
  @HiveField(0)
  String owner;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? language;

  @HiveField(4)
  int stars;

  @HiveField(5)
  int forks;

  @HiveField(6)
  DateTime bookmarkedAt;

  @HiveField(7)
  List<String> tags;

  @HiveField(8)
  String? avatarUrl;

  BookmarkedRepository({
    required this.owner,
    required this.name,
    this.description,
    this.language,
    this.stars = 0,
    this.forks = 0,
    required this.bookmarkedAt,
    this.tags = const [],
    this.avatarUrl,
  });

  String get fullName => '$owner/$name';

  String get githubUrl => 'https://github.com/$owner/$name';

  // Convert from RepositoryAnalysis
  factory BookmarkedRepository.fromAnalysis(dynamic analysis) {
    return BookmarkedRepository(
      owner: analysis.owner,
      name: analysis.repo,
      description: null, // RepositoryAnalysis doesn't have description
      language: analysis.languages.primaryLanguage,
      stars: analysis.stats.stars,
      forks: analysis.stats.forks,
      bookmarkedAt: DateTime.now(),
      tags: [],
      avatarUrl: null, // RepositoryAnalysis doesn't have avatar URL
    );
  }

  BookmarkedRepository copyWith({
    String? owner,
    String? name,
    String? description,
    String? language,
    int? stars,
    int? forks,
    DateTime? bookmarkedAt,
    List<String>? tags,
    String? avatarUrl,
  }) {
    return BookmarkedRepository(
      owner: owner ?? this.owner,
      name: name ?? this.name,
      description: description ?? this.description,
      language: language ?? this.language,
      stars: stars ?? this.stars,
      forks: forks ?? this.forks,
      bookmarkedAt: bookmarkedAt ?? this.bookmarkedAt,
      tags: tags ?? this.tags,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
