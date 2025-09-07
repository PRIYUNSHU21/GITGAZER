import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';

class PopularReposSection extends StatelessWidget {
  final Function(String owner, String repo)? onRepositoryTap;
  final bool isDesktop;

  const PopularReposSection({
    super.key,
    this.onRepositoryTap,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: DesignTokens.space2,
              horizontal: DesignTokens.space1,
            ),
            child: Row(
              children: [
                const SizedBox(width: DesignTokens.space3),
                Text(
                  'Popular Repositories',
                  style: DesignTokens.headingMd(context)?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.space4),

          // Enhanced Description
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space2,
              vertical: DesignTokens.space2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_rounded,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(0.8),
                ),
                const SizedBox(width: DesignTokens.space2),
                Expanded(
                  child: Text(
                    'Click any repository to auto-fill the search form',
                    style: DesignTokens.bodySm(context)?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.space6),

          // Horizontal Repository Cards
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: DesignTokens.space2),
              children: [
                _buildHorizontalRepoCard(
                    context, 'facebook/react', '⚛️', 'JavaScript Library'),
                _buildHorizontalRepoCard(
                    context, 'microsoft/typescript', '📘', 'TypeScript'),
                _buildHorizontalRepoCard(
                    context, 'flutter/flutter', '💙', 'UI Framework'),
                _buildHorizontalRepoCard(
                    context, 'vercel/next.js', '▲', 'React Framework'),
                _buildHorizontalRepoCard(
                    context, 'nodejs/node', '💚', 'JavaScript Runtime'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalRepoCard(
      BuildContext context, String repo, String emoji, String description) {
    final theme = Theme.of(context);
    final parts = repo.split('/');
    final owner = parts.length >= 2 ? parts[0] : '';
    final repoName = parts.length >= 2 ? parts[1] : repo;

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: DesignTokens.space4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        child: InkWell(
          onTap: () {
            if (onRepositoryTap != null && parts.length >= 2) {
              onRepositoryTap!(owner, repoName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Auto-filling: $repo'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.space4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji and Title Row
                Row(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: DesignTokens.space3),
                    Expanded(
                      child: Text(
                        repoName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.space2),

                // Owner
                Text(
                  owner,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: DesignTokens.space1),

                // Description
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
