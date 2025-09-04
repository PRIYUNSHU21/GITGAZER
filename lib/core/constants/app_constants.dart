class ApiConstants {
  // Base URL for the GitHub Analyzer Backend
  static const String baseUrl =
      'https://github-analyzer-backend-g300.onrender.com';

  // API Endpoints
  static const String healthEndpoint = '/api/v1/health';
  static const String analyzeEndpoint = '/api/v1/analyze';
  static const String statsEndpoint = '/api/v1/repo';

  // Timeout duration - increased for slow backend responses
  static const Duration timeoutDuration = Duration(seconds: 60);

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

class AppStrings {
  // App Title
  static const String appTitle = 'GitHub Repository Analyzer';
  static const String appSubtitle = 'AI-Powered Repository Insights';

  // Home Screen
  static const String enterRepoDetails = 'Enter Repository Details';
  static const String ownerHint = 'Owner (e.g., facebook)';
  static const String repoHint = 'Repository (e.g., react)';
  static const String analyzeButton = 'Analyze Repository';
  static const String recentSearches = 'Recent Searches';
  static const String noRecentSearches = 'No recent searches';

  // Dashboard Screen
  static const String repoStats = 'Repository Statistics';
  static const String languageBreakdown = 'Language Breakdown';
  static const String commitActivity = 'Commit Activity';
  static const String aiInsights = 'AI Insights';
  static const String openInGitHub = 'Open in GitHub';
  static const String shareAnalysis = 'Share Analysis';

  // Stats Labels
  static const String stars = 'Stars';
  static const String forks = 'Forks';
  static const String issues = 'Issues';
  static const String license = 'License';
  static const String totalCommits = 'Total Commits';
  static const String recentCommits = 'Recent (30 days)';

  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String repoNotFound = 'Repository not found';
  static const String invalidFormat = 'Invalid request format';
  static const String serverError = 'Server error. Please try again later.';
  static const String unexpectedError = 'An unexpected error occurred';
  static const String requiredField = 'This field is required';
  static const String invalidOwner = 'Invalid owner name';
  static const String invalidRepo = 'Invalid repository name';

  // Loading Messages
  static const String loading = 'Loading...';
  static const String analyzing = 'Analyzing repository...';
  static const String fetchingData = 'Fetching data...';
  static const String generatingInsights = 'Generating AI insights...';

  // Empty States
  static const String noDataAvailable = 'No data available';
  static const String noLanguagesFound = 'No languages found';
  static const String noCommitData = 'No commit data available';
  static const String noInsightsGenerated = 'No insights generated';

  // Navigation
  static const String home = 'Home';
  static const String dashboard = 'Dashboard';
  static const String history = 'History';
  static const String settings = 'Settings';

  // Settings
  static const String theme = 'Theme';
  static const String darkTheme = 'Dark Theme';
  static const String lightTheme = 'Light Theme';
  static const String about = 'About';
  static const String version = 'Version';
  static const String clearHistory = 'Clear History';

  // Actions
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String share = 'Share';
  static const String copy = 'Copy';
  static const String refresh = 'Refresh';
  static const String search = 'Search';
  static const String clear = 'Clear';
}
