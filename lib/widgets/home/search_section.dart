import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import '../../core/utils/validators.dart';

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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 800 : double.infinity,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.space2 : 0,
      ),
      padding: EdgeInsets.all(
        isMobile
            ? DesignTokens.space4
            : isDesktop
                ? DesignTokens.space10
                : DesignTokens.space6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withOpacity(0.95),
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? DesignTokens.radiusXl : DesignTokens.radius2xl,
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: isMobile ? 16 : 24,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Enhanced Search Header with better mobile layout
            _buildSearchHeader(context),

            SizedBox(
                height: isMobile ? DesignTokens.space4 : DesignTokens.space6),

            // Input Fields with improved responsive layout
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
                  SizedBox(
                      height:
                          isMobile ? DesignTokens.space3 : DesignTokens.space4),
                  _buildRepoField(context),
                ],
              ),

            SizedBox(
                height: isMobile ? DesignTokens.space4 : DesignTokens.space6),

            // Analyze Button
            _buildAnalyzeButton(context),

            SizedBox(height: DesignTokens.space3),

            // Compare Button
            _buildCompareButton(context),

            SizedBox(
                height: isMobile ? DesignTokens.space4 : DesignTokens.space6),

            // Example text with enhanced styling
            _buildExampleText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? DesignTokens.space1 : DesignTokens.space2,
        horizontal: DesignTokens.space1,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
                isMobile ? DesignTokens.space1 : DesignTokens.space2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: isMobile ? 18 : 20,
            ),
          ),
          SizedBox(width: isMobile ? DesignTokens.space2 : DesignTokens.space3),
          Expanded(
            child: Text(
              '🔍 Repository Search',
              style: isMobile
                  ? DesignTokens.headingSm(context)?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    )
                  : DesignTokens.headingMd(context)?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleText(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.space3 : DesignTokens.space4,
        vertical: isMobile ? DesignTokens.space2 : DesignTokens.space3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            theme.colorScheme.surfaceContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: isMobile ? 14 : 16,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
          SizedBox(width: isMobile ? DesignTokens.space1 : DesignTokens.space2),
          Expanded(
            child: Text(
              isMobile
                  ? 'e.g. facebook/react'
                  : 'Example: facebook/react or microsoft/typescript',
              style: DesignTokens.bodySm(context)?.copyWith(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerField(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            margin: EdgeInsets.all(isMobile ? 6 : 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.15),
                  theme.colorScheme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: theme.colorScheme.primary,
              size: isMobile ? 18 : 20,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.9),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? DesignTokens.space3 : DesignTokens.space4,
            vertical: isMobile ? DesignTokens.space3 : DesignTokens.space4,
          ),
          labelStyle: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        validator: Validators.validateRepositoryOwner,
        enabled: !isLoading,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRepoField(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            margin: EdgeInsets.all(isMobile ? 6 : 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.15),
                  theme.colorScheme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              Icons.folder_outlined,
              color: theme.colorScheme.primary,
              size: isMobile ? 18 : 20,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.9),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? DesignTokens.space3 : DesignTokens.space4,
            vertical: isMobile ? DesignTokens.space3 : DesignTokens.space4,
          ),
          labelStyle: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        validator: Validators.validateRepositoryName,
        enabled: !isLoading,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => onAnalyze(),
        style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      height: isMobile ? 56 : 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? DesignTokens.radiusXl : DesignTokens.radius2xl,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: isMobile ? 12 : 16,
            offset: const Offset(0, 4),
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
        borderRadius: BorderRadius.circular(
          isMobile ? DesignTokens.radiusXl : DesignTokens.radius2xl,
        ),
        child: InkWell(
          onTap: isLoading ? null : onAnalyze,
          borderRadius: BorderRadius.circular(
            isMobile ? DesignTokens.radiusXl : DesignTokens.radius2xl,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                isMobile ? DesignTokens.radiusXl : DesignTokens.radius2xl,
              ),
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
                        SizedBox(
                          width: isMobile ? 20 : 24,
                          height: isMobile ? 20 : 24,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(
                            width: isMobile
                                ? DesignTokens.space2
                                : DesignTokens.space3),
                        Text(
                          'Analyzing...',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMobile ? 3 : 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusSm),
                          ),
                          child: Icon(
                            Icons.rocket_launch_rounded,
                            color: Colors.white,
                            size: isMobile ? 18 : 20,
                          ),
                        ),
                        SizedBox(
                            width: isMobile
                                ? DesignTokens.space2
                                : DesignTokens.space3),
                        Text(
                          'Analyze Repository',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 14 : 16,
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

  Widget _buildCompareButton(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/compare');
          },
          icon: Icon(
            Icons.compare_arrows_rounded,
            size: isMobile ? 16 : 18,
            color: theme.colorScheme.primary,
          ),
          label: Text(
            'Compare Repositories',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? DesignTokens.space4 : DesignTokens.space6,
              vertical: isMobile ? DesignTokens.space2 : DesignTokens.space3,
            ),
            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              side: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
