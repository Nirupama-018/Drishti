import '../models/game_result.dart';
import '../../games/attention_game/attention_result.dart';

class AttentionResultAdapter {
  static GameResult toGameResult(AttentionGameResult result) {
    return GameResult(
      gameId: result.gameId,
      difficultyLevel: result.difficultyLevel,
      totalTargets: result.totalTrials,
      correct: result.correct,
      incorrect: result.incorrect,
      missed: result.missed,
      accuracy: result.accuracy,
      responseTime: result.averageResponseTime,
      completed: result.completed,
    );
  }
}