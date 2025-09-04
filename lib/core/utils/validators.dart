class Validators {
  static String? validateRepositoryOwner(String? value) {
    if (value == null || value.isEmpty) {
      return 'Repository owner is required';
    }

    if (value.length < 2) {
      return 'Owner name must be at least 2 characters';
    }

    if (value.length > 39) {
      return 'Owner name must be less than 40 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9-_]+$').hasMatch(value)) {
      return 'Owner name can only contain letters, numbers, hyphens, and underscores';
    }

    if (value.startsWith('-') || value.endsWith('-')) {
      return 'Owner name cannot start or end with hyphens';
    }

    return null;
  }

  static String? validateRepositoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Repository name is required';
    }

    if (value.length < 2) {
      return 'Repository name must be at least 2 characters';
    }

    if (value.length > 100) {
      return 'Repository name must be less than 100 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9-_.]+$').hasMatch(value)) {
      return 'Repository name contains invalid characters';
    }

    if (value.startsWith('.') || value.endsWith('.')) {
      return 'Repository name cannot start or end with periods';
    }

    return null;
  }

  static bool isValidGitHubUrl(String url) {
    final gitHubUrlPattern = RegExp(
      r'^https?://github\.com/[a-zA-Z0-9-_]+/[a-zA-Z0-9-_.]+/?$',
      caseSensitive: false,
    );
    return gitHubUrlPattern.hasMatch(url);
  }

  static Map<String, String>? parseGitHubUrl(String url) {
    final gitHubUrlPattern = RegExp(
      r'^https?://github\.com/([a-zA-Z0-9-_]+)/([a-zA-Z0-9-_.]+)/?$',
      caseSensitive: false,
    );

    final match = gitHubUrlPattern.firstMatch(url);
    if (match != null) {
      return {
        'owner': match.group(1)!,
        'repo': match.group(2)!,
      };
    }

    return null;
  }
}
