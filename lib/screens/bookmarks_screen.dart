import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import '../models/bookmark.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  String _searchQuery = '';
  String? _selectedTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Bookmarks'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              return IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: bookmarkProvider.bookmarkCount > 0
                    ? () => _exportBookmarks(context, bookmarkProvider)
                    : null,
                tooltip: 'Export Bookmarks',
              );
            },
          ),
        ],
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          if (!bookmarkProvider.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (bookmarkProvider.bookmarkCount == 0) {
            return _buildEmptyState();
          }

          final filteredBookmarks = _getFilteredBookmarks(bookmarkProvider);

          return Column(
            children: [
              _buildSearchAndFilters(bookmarkProvider),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBookmarks.length,
                  itemBuilder: (context, index) {
                    return _buildBookmarkCard(
                        filteredBookmarks[index], bookmarkProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start analyzing repositories to bookmark your favorites!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BookmarkProvider bookmarkProvider) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search bookmarks...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
            ),
          ),

          const SizedBox(height: 12),

          // Tag filters
          if (bookmarkProvider.availableTags.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedTag == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTag = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...bookmarkProvider.availableTags.map(
                    (tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tag),
                        selected: _selectedTag == tag,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTag = selected ? tag : null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(
      BookmarkedRepository bookmark, BookmarkProvider bookmarkProvider) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => _analyzeRepository(bookmark),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (bookmark.avatarUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        bookmark.avatarUrl!,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.account_circle, size: 40),
                      ),
                    )
                  else
                    const Icon(Icons.account_circle, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookmark.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (bookmark.description != null)
                          Text(
                            bookmark.description!,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.bookmark, color: colorScheme.primary),
                    onPressed: () => bookmarkProvider.removeBookmark(
                        bookmark.owner, bookmark.name),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (bookmark.language != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bookmark.language!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(Icons.star, size: 16, color: Colors.amber[700]),
                  const SizedBox(width: 4),
                  Text('${bookmark.stars}'),
                  const SizedBox(width: 16),
                  const Icon(Icons.fork_right, size: 16),
                  const SizedBox(width: 4),
                  Text('${bookmark.forks}'),
                  const Spacer(),
                  Text(
                    _formatDate(bookmark.bookmarkedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              if (bookmark.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: bookmark.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 11),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<BookmarkedRepository> _getFilteredBookmarks(
      BookmarkProvider bookmarkProvider) {
    List<BookmarkedRepository> bookmarks = bookmarkProvider.bookmarks;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      bookmarks = bookmarkProvider.searchBookmarks(_searchQuery);
    }

    // Filter by selected tag
    if (_selectedTag != null) {
      bookmarks = bookmarks
          .where((bookmark) => bookmark.tags.contains(_selectedTag))
          .toList();
    }

    return bookmarks;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  void _analyzeRepository(BookmarkedRepository bookmark) {
    Navigator.pushNamed(
      context,
      '/dashboard',
      arguments: {
        'owner': bookmark.owner,
        'repo': bookmark.name,
      },
    );
  }

  void _exportBookmarks(
      BuildContext context, BookmarkProvider bookmarkProvider) {
    final bookmarks = bookmarkProvider.exportBookmarks();

    // Show export dialog or share functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Bookmarks'),
        content: Text('Found ${bookmarks.length} bookmarks to export.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual export functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon!')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}
