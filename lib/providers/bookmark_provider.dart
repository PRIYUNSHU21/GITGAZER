import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bookmark.dart';
import '../models/repository_analysis.dart';

class BookmarkProvider with ChangeNotifier {
  static const String _boxName = 'bookmarks';
  Box<BookmarkedRepository>? _box;
  List<BookmarkedRepository> _bookmarks = [];
  List<String> _availableTags = [];
  String _searchQuery = '';
  String? _selectedTag;

  // Getters
  List<BookmarkedRepository> get bookmarks => _filteredBookmarks();
  List<String> get availableTags => _availableTags;
  String get searchQuery => _searchQuery;
  String? get selectedTag => _selectedTag;
  bool get hasBookmarks => _bookmarks.isNotEmpty;

  Future<void> initialize() async {
    try {
      // Register the adapter if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(BookmarkedRepositoryAdapter());
      }

      _box = await Hive.openBox<BookmarkedRepository>(_boxName);
      _loadBookmarks();
    } catch (e) {
      debugPrint('Error initializing BookmarkProvider: $e');
    }
  }

  void _loadBookmarks() {
    if (_box == null) return;

    _bookmarks = _box!.values.toList();
    _updateAvailableTags();
    notifyListeners();
  }

  void _updateAvailableTags() {
    final tags = <String>{};
    for (final bookmark in _bookmarks) {
      tags.addAll(bookmark.tags);
    }
    _availableTags = tags.toList()..sort();
  }

  List<BookmarkedRepository> _filteredBookmarks() {
    var filtered = _bookmarks;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((bookmark) {
        return bookmark.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            bookmark.owner.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            bookmark.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            bookmark.language
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by selected tag
    if (_selectedTag != null && _selectedTag!.isNotEmpty) {
      filtered = filtered
          .where((bookmark) => bookmark.tags.contains(_selectedTag))
          .toList();
    }

    // Sort by bookmarked date (newest first)
    filtered.sort((a, b) => b.bookmarkedAt.compareTo(a.bookmarkedAt));

    return filtered;
  }

  Future<void> addBookmark(RepositoryAnalysis analysis,
      {List<String>? tags}) async {
    if (_box == null) return;

    // Check if already bookmarked
    if (isBookmarked(analysis.owner, analysis.repo)) {
      return;
    }

    final bookmark = BookmarkedRepository.fromAnalysis(analysis);
    if (tags != null) {
      bookmark.tags.addAll(tags);
    }

    await _box!.add(bookmark);
    _loadBookmarks();
  }

  Future<void> removeBookmark(String owner, String repo) async {
    if (_box == null) return;

    final key = _box!.keys.firstWhere(
      (key) {
        final bookmark = _box!.get(key);
        return bookmark?.owner == owner && bookmark?.repo == repo;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _box!.delete(key);
      _loadBookmarks();
    }
  }

  Future<void> updateBookmarkTags(
      String owner, String repo, List<String> tags) async {
    if (_box == null) return;

    final key = _box!.keys.firstWhere(
      (key) {
        final bookmark = _box!.get(key);
        return bookmark?.owner == owner && bookmark?.repo == repo;
      },
      orElse: () => null,
    );

    if (key != null) {
      final bookmark = _box!.get(key);
      if (bookmark != null) {
        bookmark.tags = tags;
        await bookmark.save();
        _loadBookmarks();
      }
    }
  }

  bool isBookmarked(String owner, String repo) {
    return _bookmarks
        .any((bookmark) => bookmark.owner == owner && bookmark.repo == repo);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedTag(String? tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedTag = null;
    notifyListeners();
  }

  BookmarkedRepository? getBookmark(String owner, String repo) {
    try {
      return _bookmarks.firstWhere(
          (bookmark) => bookmark.owner == owner && bookmark.repo == repo);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllBookmarks() async {
    if (_box == null) return;

    await _box!.clear();
    _loadBookmarks();
  }
}
