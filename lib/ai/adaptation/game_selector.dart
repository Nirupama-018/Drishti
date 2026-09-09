import '../history/session_history.dart';
import '../models/cognitive_profile.dart';

class GameSelector {
  String selectGame({
    required CognitiveProfile profile,
    required SessionHistory history,
  }) {
    final memoryConfidence = profile.visualMemory.confidence;
    final attentionConfidence =
        profile.selectiveAttention.confidence;

    // If neither domain has enough data,
    // use a balanced default.
    if (memoryConfidence < 0.5 &&
        attentionConfidence < 0.5) {
      return _alternateGame(history);
    }

    // If memory has insufficient data but
    // attention has enough data, choose memory.
    if (memoryConfidence < 0.5 &&
        attentionConfidence >= 0.5) {
      return 'visual_memory';
    }

    // If attention has insufficient data but
    // memory has enough data, choose attention.
    if (attentionConfidence < 0.5 &&
        memoryConfidence >= 0.5) {
      return 'visual_attention';
    }

    // Both domains have enough data.
    final memoryPerformance =
        profile.visualMemory.performance;

    final attentionPerformance =
        profile.selectiveAttention.performance;

    // Prioritize the weaker domain.
    if (memoryPerformance < attentionPerformance) {
      return 'visual_memory';
    }

    if (attentionPerformance < memoryPerformance) {
      return 'visual_attention';
    }

    // Equal performance → alternate.
    return _alternateGame(history);
  }

  String _alternateGame(SessionHistory history) {
    if (history.sessionCount == 0) {
      return 'visual_memory';
    }

    final lastGame = history.sessions.last.gameId;

    if (lastGame == 'visual_memory') {
      return 'visual_attention';
    }

    return 'visual_memory';
  }
}