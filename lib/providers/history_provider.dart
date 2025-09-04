import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchHistoryItem {
  final String owner;
  final String repo;
  final DateTime timestamp;

  SearchHistoryItem({
    required this.owner,
    required this.repo,
    required this.timestamp,
  });

  String get fullName => '$owner/$repo';

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'repo': repo,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      owner: json['owner'],
      repo: json['repo'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class HistoryProvider with ChangeNotifier {
  static const String _historyKey = 'search_history';
  static const int _maxHistoryItems = 20;

  List<SearchHistoryItem> _history = [];
  bool _isLoaded = false;

  // Getters
  List<SearchHistoryItem> get history => List.unmodifiable(_history);
  bool get hasHistory => _history.isNotEmpty;
  bool get isLoaded => _isLoaded;

  // Load history from storage
  Future<void> loadHistory() async {
    if (_isLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);

      if (historyJson != null) {
        final List<dynamic> historyData = json.decode(historyJson);
        _history = historyData
            .map((item) => SearchHistoryItem.fromJson(item))
            .toList();

        // Sort by timestamp (most recent first)
        _history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, start with empty history
      _history = [];
      _isLoaded = true;
      notifyListeners();
    }
  }

  // Add search to history
  Future<void> addSearch(String owner, String repo) async {
    if (owner.isEmpty || repo.isEmpty) return;

    // Remove existing entry if it exists
    _history.removeWhere((item) =>
        item.owner.toLowerCase() == owner.toLowerCase() &&
        item.repo.toLowerCase() == repo.toLowerCase());

    // Add new entry at the beginning
    _history.insert(
        0,
        SearchHistoryItem(
          owner: owner,
          repo: repo,
          timestamp: DateTime.now(),
        ));

    // Limit history size
    if (_history.length > _maxHistoryItems) {
      _history = _history.take(_maxHistoryItems).toList();
    }

    await _saveHistory();
    notifyListeners();
  }

  // Remove specific search from history
  Future<void> removeSearch(SearchHistoryItem item) async {
    _history.remove(item);
    await _saveHistory();
    notifyListeners();
  }

  // Clear all history
  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
    notifyListeners();
  }

  // Get recent searches (limited)
  List<SearchHistoryItem> getRecentSearches([int limit = 5]) {
    return _history.take(limit).toList();
  }

  // Check if a search exists in history
  bool hasSearch(String owner, String repo) {
    return _history.any((item) =>
        item.owner.toLowerCase() == owner.toLowerCase() &&
        item.repo.toLowerCase() == repo.toLowerCase());
  }

  // Search within history
  List<SearchHistoryItem> searchHistory(String query) {
    if (query.isEmpty) return history;

    final lowerQuery = query.toLowerCase();
    return _history.where((item) {
      return item.owner.toLowerCase().contains(lowerQuery) ||
          item.repo.toLowerCase().contains(lowerQuery) ||
          item.fullName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Private method to save history
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson =
          json.encode(_history.map((item) => item.toJson()).toList());
      await prefs.setString(_historyKey, historyJson);
    } catch (e) {
      // Handle save error silently
      debugPrint('Failed to save search history: $e');
    }
  }
}
