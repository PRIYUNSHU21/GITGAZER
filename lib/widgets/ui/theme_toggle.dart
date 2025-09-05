import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool showLabel;
  final IconData? lightIcon;
  final IconData? darkIcon;
  final String? tooltip;

  const ThemeToggleButton({
    super.key,
    this.showLabel = false,
    this.lightIcon,
    this.darkIcon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final icon = isDark
            ? (lightIcon ?? Icons.light_mode)
            : (darkIcon ?? Icons.dark_mode);

        if (showLabel) {
          return FilledButton.icon(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(icon),
            label: Text(isDark ? 'Light Mode' : 'Dark Mode'),
          );
        }

        return IconButton(
          onPressed: () => themeProvider.toggleTheme(),
          icon: Icon(icon),
          tooltip: tooltip ??
              (isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
        );
      },
    );
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _ThemeOption(
                  title: 'Light',
                  subtitle: 'Light theme with bright colors',
                  icon: Icons.light_mode,
                  isSelected: themeProvider.isLightMode,
                  onTap: () => themeProvider.setLightTheme(),
                ),
                _ThemeOption(
                  title: 'Dark',
                  subtitle: 'Dark theme for low light environments',
                  icon: Icons.dark_mode,
                  isSelected: themeProvider.isDarkMode,
                  onTap: () => themeProvider.setDarkTheme(),
                ),
                _ThemeOption(
                  title: 'System',
                  subtitle: 'Follow system theme settings',
                  icon: Icons.settings_suggest,
                  isSelected: themeProvider.isSystemMode,
                  onTap: () => themeProvider.setSystemTheme(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimaryContainer.withOpacity(0.8)
                : colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: colorScheme.onPrimaryContainer,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
