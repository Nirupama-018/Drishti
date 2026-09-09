import '../../games/memory_game/memory_result.dart';
import '../../games/attention_game/attention_result.dart';
import 'game_performance.dart';

class GameResultAdapter {
  static GamePerformance? fromMemoryResult(
    MemoryGameResult result,
    String patientId,
  ) {
    if (!result.completed) {
      return null;
    }

    return GamePerformance(
      patientId: patientId,
      gameName: 'Remember the Objects',
      difficulty: result.difficultyLevel,
      score: result.accuracy * 100,
      accuracy: result.accuracy * 100,
      responseTime: result.responseTime,
      mistakes: result.incorrect + result.missed,
      timestamp: DateTime.now(),
    );
  }

  static GamePerformance? fromAttentionResult(
    AttentionGameResult result,
    String patientId,
  ) {
    if (!result.completed) {
      return null;
    }

    return GamePerformance(
      patientId: patientId,
      gameName: 'Find the Target',
      difficulty: result.difficultyLevel,
      score: result.accuracy * 100,
      accuracy: result.accuracy * 100,
      responseTime: result.averageResponseTime,
      mistakes: result.incorrect + result.missed,
      timestamp: DateTime.now(),
    );
  }
}