import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bookmark.dart';

class BookmarkProvider with ChangeNotifier {
  static const String _boxName = 'bookmarks';
  static const String _tagsBoxName = 'bookmark_tags';

  Box<BookmarkedRepository>? _bookmarkBox;
  Box<String>? _tagsBox;

  List<BookmarkedRepository> _bookmarks = [];
  Set<String> _availableTags = {};
  bool _isInitialized = false;

  // Getters
  List<BookmarkedRepository> get bookmarks => List.unmodifiable(_bookmarks);
  Set<String> get availableTags => Set.unmodifiable(_availableTags);
  bool get isInitialized => _isInitialized;
  int get bookmarkCount => _bookmarks.length;

  // Initialize Hive
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(BookmarkedRepositoryAdapter());
      }

      // Open boxes
      _bookmarkBox = await Hive.openBox<BookmarkedRepository>(_boxName);
      _tagsBox = await Hive.openBox<String>(_tagsBoxName);

      // Load data
      await _loadBookmarks();
      await _loadTags();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing BookmarkProvider: $e');
      }
    }
  }

  Future<void> _loadBookmarks() async {
    if (_bookmarkBox == null) return;

    _bookmarks = _bookmarkBox!.values.toList();
    _bookmarks.sort((a, b) => b.bookmarkedAt.compareTo(a.bookmarkedAt));
  }

  Future<void> _loadTags() async {
    if (_tagsBox == null) return;

    _availableTags = _tagsBox!.values.toSet();
  }

  // Check if repository is bookmarked
  bool isBookmarked(String owner, String name) {
    return _bookmarks.any((bookmark) =>
        bookmark.owner.toLowerCase() == owner.toLowerCase() &&
        bookmark.name.toLowerCase() == name.toLowerCase());
  }

  // Add bookmark
  Future<bool> addBookmark(BookmarkedRepository bookmark) async {
    if (_bookmarkBox == null || isBookmarked(bookmark.owner, bookmark.name)) {
      return false;
    }

    try {
      await _bookmarkBox!.add(bookmark);
      _bookmarks.insert(0, bookmark);

      // Add tags to available tags
      for (String tag in bookmark.tags) {
        if (tag.isNotEmpty && !_availableTags.contains(tag)) {
          _availableTags.add(tag);
          await _tagsBox?.add(tag);
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding bookmark: $e');
      }
      return false;
    }
  }

  // Remove bookmark
  Future<bool> removeBookmark(String owner, String name) async {
    if (_bookmarkBox == null) return false;

    try {
      final index = _bookmarks.indexWhere((bookmark) =>
          bookmark.owner.toLowerCase() == owner.toLowerCase() &&
          bookmark.name.toLowerCase() == name.toLowerCase());

      if (index == -1) return false;

      final bookmark = _bookmarks[index];
      await bookmark.delete();
      _bookmarks.removeAt(index);

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error removing bookmark: $e');
      }
      return false;
    }
  }

  // Toggle bookmark
  Future<bool> toggleBookmark(BookmarkedRepository bookmark) async {
    if (isBookmarked(bookmark.owner, bookmark.name)) {
      return await removeBookmark(bookmark.owner, bookmark.name);
    } else {
      return await addBookmark(bookmark);
    }
  }

  // Update bookmark tags
  Future<bool> updateBookmarkTags(
      String owner, String name, List<String> newTags) async {
    if (_bookmarkBox == null) return false;

    try {
      final index = _bookmarks.indexWhere((bookmark) =>
          bookmark.owner.toLowerCase() == owner.toLowerCase() &&
          bookmark.name.toLowerCase() == name.toLowerCase());

      if (index == -1) return false;

      final bookmark = _bookmarks[index];
      final updatedBookmark = bookmark.copyWith(tags: newTags);

      await bookmark.delete();
      await _bookmarkBox!.add(updatedBookmark);

      _bookmarks[index] = updatedBookmark;

      // Update available tags
      for (String tag in newTags) {
        if (tag.isNotEmpty && !_availableTags.contains(tag)) {
          _availableTags.add(tag);
          await _tagsBox?.add(tag);
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating bookmark tags: $e');
      }
      return false;
    }
  }

  // Get bookmarks by tag
  List<BookmarkedRepository> getBookmarksByTag(String tag) {
    return _bookmarks.where((bookmark) => bookmark.tags.contains(tag)).toList();
  }

  // Get bookmarks by language
  List<BookmarkedRepository> getBookmarksByLanguage(String language) {
    return _bookmarks
        .where((bookmark) =>
            bookmark.language?.toLowerCase() == language.toLowerCase())
        .toList();
  }

  // Search bookmarks
  List<BookmarkedRepository> searchBookmarks(String query) {
    if (query.isEmpty) return _bookmarks;

    final lowercaseQuery = query.toLowerCase();
    return _bookmarks
        .where((bookmark) =>
            bookmark.name.toLowerCase().contains(lowercaseQuery) ||
            bookmark.owner.toLowerCase().contains(lowercaseQuery) ||
            bookmark.description?.toLowerCase().contains(lowercaseQuery) ==
                true ||
            bookmark.tags
                .any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    if (_bookmarkBox == null) return;

    try {
      await _bookmarkBox!.clear();
      _bookmarks.clear();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing bookmarks: $e');
      }
    }
  }

  // Export bookmarks as JSON
  List<Map<String, dynamic>> exportBookmarks() {
    return _bookmarks
        .map((bookmark) => {
              'owner': bookmark.owner,
              'name': bookmark.name,
              'description': bookmark.description,
              'language': bookmark.language,
              'stars': bookmark.stars,
              'forks': bookmark.forks,
              'bookmarkedAt': bookmark.bookmarkedAt.toIso8601String(),
              'tags': bookmark.tags,
              'avatarUrl': bookmark.avatarUrl,
              'githubUrl': bookmark.githubUrl,
            })
        .toList();
  }

  @override
  void dispose() {
    _bookmarkBox?.close();
    _tagsBox?.close();
    super.dispose();
  }
}
