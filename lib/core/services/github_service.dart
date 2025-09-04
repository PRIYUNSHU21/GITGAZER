import '../services/api_service.dart';
import '../constants/app_constants.dart';
import '../../models/repository_analysis.dart';

class GitHubService {
  static Future<RepositoryAnalysis> analyzeRepository(
    String owner,
    String repo,
  ) async {
    print('Calling API with owner: $owner, repo: $repo');
    final data = await ApiService.post(ApiConstants.analyzeEndpoint, {
      'owner': owner,
      'repo': repo,
    });

    print('=== API RESPONSE DEBUG ===');
    print('Response keys: ${data.keys.toList()}');
    print('Has ai_insights: ${data.containsKey('ai_insights')}');

    if (data.containsKey('ai_insights')) {
      final aiInsights = data['ai_insights'] as Map<String, dynamic>;
      print('AI insights keys: ${aiInsights.keys.toList()}');
    }
    print('========================');

    final analysis = RepositoryAnalysis.fromJson(data);
    print(
        'Final Enhanced AI Insight: ${analysis.enhancedAiInsight != null ? "SUCCESS" : "FAILED"}');

    return analysis;
  }

  static Future<RepositoryStats> getBasicStats(
    String owner,
    String repo,
  ) async {
    final data = await ApiService.get(
        '${ApiConstants.statsEndpoint}/$owner/$repo/stats');
    return RepositoryStats.fromJson(data);
  }

  static Future<Map<String, dynamic>> checkHealth() async {
    return await ApiService.get(ApiConstants.healthEndpoint);
  }

  static Future<bool> isServiceHealthy() async {
    try {
      final healthData = await checkHealth();
      return healthData['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }
}
