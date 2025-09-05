import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/design_tokens.dart';
import '../providers/bookmark_provider.dart';
import '../models/bookmark.dart';
import 'dashboard_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: DesignTokens.durationNormal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: isDesktop ? 160 : 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Bookmarks',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: DesignTokens.gradient(context),
              ),
            ),
            actions: [
              Consumer<BookmarkProvider>(
                builder: (context, bookmarkProvider, child) {
                  return IconButton(
                    icon: const Icon(Icons.clear_all),
                    onPressed: bookmarkProvider.hasBookmarks
                        ? () => _showClearAllDialog(context, bookmarkProvider)
                        : null,
                    tooltip: 'Clear All Bookmarks',
                  );
                },
              ),
            ],
          ),

          // Search and Filter Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.all(
                  isDesktop ? DesignTokens.space6 : DesignTokens.space4,
                ),
                child: _buildSearchAndFilter(context),
              ),
            ),
          ),

          // Bookmarks List
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      isDesktop ? DesignTokens.space6 : DesignTokens.space4,
                ),
                child: _buildBookmarksList(context, isDesktop),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.space4),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search bookmarks...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              bookmarkProvider.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    bookmarkProvider.setSearchQuery(value);
                  },
                ),

                const SizedBox(height: DesignTokens.space4),

                // Tag Filter
                if (bookmarkProvider.availableTags.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Filter by tags:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space2),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: bookmarkProvider.selectedTag == null,
                          onSelected: (selected) {
                            bookmarkProvider.setSelectedTag(null);
                          },
                        ),
                        const SizedBox(width: DesignTokens.space2),
                        ...bookmarkProvider.availableTags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: DesignTokens.space2),
                            child: FilterChip(
                              label: Text(tag),
                              selected: bookmarkProvider.selectedTag == tag,
                              onSelected: (selected) {
                                bookmarkProvider
                                    .setSelectedTag(selected ? tag : null);
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookmarksList(BuildContext context, bool isDesktop) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        final bookmarks = bookmarkProvider.bookmarks;

        if (!bookmarkProvider.hasBookmarks) {
          return _buildEmptyState(context);
        }

        if (bookmarks.isEmpty) {
          return _buildNoResultsState(context);
        }

        return Column(
          children: bookmarks.map((bookmark) {
            return _buildBookmarkCard(
                context, bookmark, bookmarkProvider, isDesktop);
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            'No Bookmarks Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: DesignTokens.space2),
          Text(
            'Start exploring repositories and bookmark your favorites!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.space6),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.explore),
            label: const Text('Explore Repositories'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            'No Results Found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: DesignTokens.space2),
          Text(
            'Try adjusting your search or filter criteria',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    BookmarkedRepository bookmark,
    BookmarkProvider bookmarkProvider,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.space4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                owner: bookmark.owner,
                repo: bookmark.repo,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Repository Icon
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.space2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.folder_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space3),

                  // Repository Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookmark.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${bookmark.owner}/${bookmark.repo}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Remove Bookmark Button
                  IconButton(
                    icon: const Icon(Icons.bookmark_remove),
                    onPressed: () =>
                        _showRemoveDialog(context, bookmark, bookmarkProvider),
                    tooltip: 'Remove Bookmark',
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.space3),

              // Description
              if (bookmark.description.isNotEmpty) ...[
                Text(
                  bookmark.description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignTokens.space3),
              ],

              // Stats Row
              Row(
                children: [
                  _buildStatChip(
                    context,
                    icon: Icons.star,
                    label: bookmark.stars.toString(),
                    color: Colors.amber,
                  ),
                  const SizedBox(width: DesignTokens.space2),
                  _buildStatChip(
                    context,
                    icon: Icons.fork_right,
                    label: bookmark.forks.toString(),
                    color: Colors.blue,
                  ),
                  const SizedBox(width: DesignTokens.space2),
                  if (bookmark.language.isNotEmpty)
                    _buildStatChip(
                      context,
                      icon: Icons.code,
                      label: bookmark.language,
                      color: Colors.green,
                    ),
                  const Spacer(),
                  Text(
                    _formatDate(bookmark.bookmarkedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),

              // Tags
              if (bookmark.tags.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.space3),
                Wrap(
                  spacing: DesignTokens.space2,
                  children: bookmark.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      labelStyle: theme.textTheme.bodySmall,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space2,
        vertical: DesignTokens.space1,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showRemoveDialog(
    BuildContext context,
    BookmarkedRepository bookmark,
    BookmarkProvider bookmarkProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Bookmark'),
          content: Text('Remove "${bookmark.name}" from bookmarks?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await bookmarkProvider.removeBookmark(
                    bookmark.owner, bookmark.repo);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Removed "${bookmark.name}" from bookmarks'),
                    ),
                  );
                }
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDialog(
      BuildContext context, BookmarkProvider bookmarkProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Bookmarks'),
          content: const Text(
              'Are you sure you want to remove all bookmarks? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await bookmarkProvider.clearAllBookmarks();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All bookmarks cleared'),
                    ),
                  );
                }
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}
