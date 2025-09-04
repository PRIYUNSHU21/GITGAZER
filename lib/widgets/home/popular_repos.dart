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
      decoration: DesignTokens.modernCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_outline,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: DesignTokens.space3),
              Text(
                'Popular Repositories',
                style: DesignTokens.headingMd(context),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            'Try analyzing these popular repositories:',
            style: DesignTokens.bodySm(context),
          ),
          const SizedBox(height: DesignTokens.space4),
          Wrap(
            spacing: DesignTokens.space3,
            runSpacing: DesignTokens.space2,
            children: [
              _buildRepoChip(context, 'facebook/react', '⚛️'),
              _buildRepoChip(context, 'microsoft/typescript', '📘'),
              _buildRepoChip(context, 'flutter/flutter', '💙'),
              _buildRepoChip(context, 'vercel/next.js', '▲'),
              _buildRepoChip(context, 'nodejs/node', '💚'),
              _buildRepoChip(context, 'angular/angular', '🅰️'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepoChip(BuildContext context, String repo, String emoji) {
    final theme = Theme.of(context);
    final parts = repo.split('/');
    final owner = parts.length >= 2 ? parts[0] : '';
    final repoName = parts.length >= 2 ? parts[1] : repo;

    return InkWell(
      onTap: () {
        if (onRepositoryTap != null && parts.length >= 2) {
          onRepositoryTap!(owner, repoName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Click to auto-fill: $repo'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space4,
          vertical: DesignTokens.space2,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: DesignTokens.space2),
            Text(
              repo,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
