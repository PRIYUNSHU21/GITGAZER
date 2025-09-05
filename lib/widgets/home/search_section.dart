import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/design_tokens.dart';
import '../../core/utils/validators.dart';
import '../../screens/bookmarks_screen.dart';
import '../../providers/theme_provider.dart';

class SearchSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ownerController;
  final TextEditingController repoController;
  final bool isLoading;
  final VoidCallback onAnalyze;
  final bool isDesktop;

  const SearchSection({
    super.key,
    required this.formKey,
    required this.ownerController,
    required this.repoController,
    required this.isLoading,
    required this.onAnalyze,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(
        isDesktop ? DesignTokens.space10 : DesignTokens.space8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius:
            BorderRadius.circular(DesignTokens.radius2xl), // Much rounder
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
        // Glassmorphism backdrop filter effect
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Enhanced Search Header
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: DesignTokens.space2,
                horizontal: DesignTokens.space1,
              ),
              child: Text(
                '🔍 Repository Search',
                style: DesignTokens.headingMd(context)?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ),

            SizedBox(height: DesignTokens.space6),

            // Input Fields
            if (isDesktop)
              Row(
                children: [
                  Expanded(child: _buildOwnerField(context)),
                  const SizedBox(width: DesignTokens.space4),
                  Expanded(child: _buildRepoField(context)),
                ],
              )
            else
              Column(
                children: [
                  _buildOwnerField(context),
                  const SizedBox(height: DesignTokens.space4),
                  _buildRepoField(context),
                ],
              ),

            SizedBox(height: DesignTokens.space6),

            // Analyze Button
            _buildAnalyzeButton(context),

            SizedBox(height: DesignTokens.space6),

            // Action Buttons Row
            _buildActionButtons(context),

            SizedBox(height: DesignTokens.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerField(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: ownerController,
        decoration: InputDecoration(
          labelText: 'Repository Owner',
          hintText: 'e.g., facebook',
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.8),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.space4,
            vertical: DesignTokens.space4,
          ),
        ),
        validator: Validators.validateRepositoryOwner,
        enabled: !isLoading,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRepoField(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: repoController,
        decoration: InputDecoration(
          labelText: 'Repository Name',
          hintText: 'e.g., react',
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              Icons.folder_outlined,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.8),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.space4,
            vertical: DesignTokens.space4,
          ),
        ),
        validator: Validators.validateRepositoryName,
        enabled: !isLoading,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => onAnalyze(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient(context),
        borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
        child: InkWell(
          onTap: isLoading ? null : onAnalyze,
          borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: DesignTokens.space3),
                        Text(
                          'Analyzing...',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusSm),
                          ),
                          child: const Icon(
                            Icons.rocket_launch_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.space3),
                        Text(
                          'Analyze Repository',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Compare Repositories Button
          _buildActionButton(
            context,
            icon: Icons.compare_arrows,
            onPressed: () {
              Navigator.of(context).pushNamed('/compare');
            },
          ),

          // View Bookmarks Button
          _buildActionButton(
            context,
            icon: Icons.bookmarks,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BookmarksScreen(),
                ),
              );
            },
          ),

          // Theme Toggle Button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: DesignTokens.space1),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  child: InkWell(
                    onTap: () {
                      themeProvider.setThemeMode(
                        isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusFull),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusFull),
                        border: Border.all(
                          color: isDark
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.blue.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? Colors.orange : Colors.blue,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.space1),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
