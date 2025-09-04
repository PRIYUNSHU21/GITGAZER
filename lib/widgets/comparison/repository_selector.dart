import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';

class RepositorySelector extends StatelessWidget {
  final String title;
  final TextEditingController ownerController;
  final TextEditingController repoController;
  final IconData icon;
  final Color color;

  const RepositorySelector({
    super.key,
    required this.title,
    required this.ownerController,
    required this.repoController,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding:
          EdgeInsets.all(isMobile ? DesignTokens.space4 : DesignTokens.space6),
      decoration: DesignTokens.glassmorphism(
        context,
        blur: 10,
        opacity: 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.space2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isMobile ? 16 : 18,
                ),
              ),
              const SizedBox(width: DesignTokens.space3),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    fontSize: isMobile ? 16 : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
              height: isMobile ? DesignTokens.space4 : DesignTokens.space6),
          _buildTextField(
            context: context,
            controller: ownerController,
            label: 'Owner/Organization',
            hint: 'e.g., facebook',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: DesignTokens.space4),
          _buildTextField(
            context: context,
            controller: repoController,
            label: 'Repository Name',
            hint: 'e.g., react',
            icon: Icons.folder_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: isMobile ? 12 : null,
          ),
        ),
        const SizedBox(height: DesignTokens.space2),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              size: isMobile ? 18 : 20,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              borderSide: BorderSide(
                color: color,
                width: 2,
              ),
            ),
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontSize: isMobile ? 12 : 14,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: DesignTokens.space4,
              vertical: isMobile ? DesignTokens.space2 : DesignTokens.space3,
            ),
          ),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: isMobile ? 12 : 14,
          ),
        ),
      ],
    );
  }
}
