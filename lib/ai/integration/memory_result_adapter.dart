import '../models/game_result.dart';
import '../../games/memory_game/memory_result.dart';

class MemoryResultAdapter {
  static GameResult toGameResult(MemoryGameResult result) {
    return GameResult(
      gameId: result.gameId,
      difficultyLevel: result.difficultyLevel,
      totalTargets: result.totalTargets,
      correct: result.correct,
      incorrect: result.incorrect,
      missed: result.missed,
      accuracy: result.accuracy,
      responseTime: result.responseTime,
      completed: result.completed,
    );
  }
}