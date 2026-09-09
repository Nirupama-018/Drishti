import '../models/game_result.dart';

class BaselineCalculator {
  double calculateAccuracyBaseline(List<GameResult> sessions) {
    if (sessions.isEmpty) {
      return 0.0;
    }

    double totalAccuracy = 0.0;

    for (final session in sessions) {
      totalAccuracy += session.correct / session.totalTargets;
    }

    return totalAccuracy / sessions.length;
  }
}