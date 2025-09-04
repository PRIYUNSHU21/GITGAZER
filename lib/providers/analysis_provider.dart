import 'package:flutter/foundation.dart';
import '../models/repository_analysis.dart';
import '../core/services/github_service.dart';
import '../core/services/api_service.dart';

enum AnalysisState {
  initial,
  loading,
  success,
  error,
}

class AnalysisProvider with ChangeNotifier {
  AnalysisState _state = AnalysisState.initial;
  RepositoryAnalysis? _analysis;
  String? _errorMessage;
  bool _isServiceHealthy = true;

  // Getters
  AnalysisState get state => _state;
  RepositoryAnalysis? get analysis => _analysis;
  String? get errorMessage => _errorMessage;
  bool get isServiceHealthy => _isServiceHealthy;
  bool get hasAnalysis => _analysis != null;
  bool get isLoading => _state == AnalysisState.loading;
  bool get hasError => _state == AnalysisState.error;

  // Clear current analysis
  void clearAnalysis() {
    _analysis = null;
    _state = AnalysisState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Check service health
  Future<void> checkServiceHealth() async {
    try {
      _isServiceHealthy = await GitHubService.isServiceHealthy();
    } catch (e) {
      _isServiceHealthy = false;
    }
    notifyListeners();
  }

  // Analyze repository
  Future<void> analyzeRepository(String owner, String repo) async {
    if (owner.isEmpty || repo.isEmpty) {
      _setError('Owner and repository name are required');
      return;
    }

    _setState(AnalysisState.loading);
    _errorMessage = null;

    try {
      final analysis = await GitHubService.analyzeRepository(owner, repo);
      _analysis = analysis;
      _setState(AnalysisState.success);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    }
  }

  // Get basic stats only
  Future<RepositoryStats?> getBasicStats(String owner, String repo) async {
    try {
      return await GitHubService.getBasicStats(owner, repo);
    } catch (e) {
      return null;
    }
  }

  // Private methods
  void _setState(AnalysisState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = AnalysisState.error;
    notifyListeners();
  }

  // Retry analysis
  void retry() {
    if (_analysis != null) {
      analyzeRepository(_analysis!.owner, _analysis!.repo);
    }
  }
}
