import 'package:hive/hive.dart';
import 'repository_analysis.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 0)
class BookmarkedRepository extends HiveObject {
  @HiveField(0)
  String owner;

  @HiveField(1)
  String repo;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  int stars;

  @HiveField(5)
  int forks;

  @HiveField(6)
  String language;

  @HiveField(7)
  DateTime bookmarkedAt;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  String? avatarUrl;

  BookmarkedRepository({
    required this.owner,
    required this.repo,
    required this.name,
    required this.description,
    required this.stars,
    required this.forks,
    required this.language,
    required this.bookmarkedAt,
    required this.tags,
    this.avatarUrl,
  });

  factory BookmarkedRepository.fromAnalysis(RepositoryAnalysis analysis) {
    return BookmarkedRepository(
      owner: analysis.owner,
      repo: analysis.repo,
      name: analysis.name,
      description: analysis.description,
      stars: analysis.stars,
      forks: analysis.forks,
      language: analysis.primaryLanguage,
      bookmarkedAt: DateTime.now(),
      tags: [],
      avatarUrl: analysis.avatarUrl,
    );
  }

  String get fullName => '$owner/$repo';

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'repo': repo,
      'name': name,
      'description': description,
      'stars': stars,
      'forks': forks,
      'language': language,
      'bookmarkedAt': bookmarkedAt.toIso8601String(),
      'tags': tags,
      'avatarUrl': avatarUrl,
    };
  }
}
