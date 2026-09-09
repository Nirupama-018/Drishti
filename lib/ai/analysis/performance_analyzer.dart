import '../models/game_result.dart';

class PerformanceMetrics {
  final double accuracy;
  final double errorRate;
  final double missRate;
  final double falseSelectionRate;
  final double speedScore;
  final bool completed;

  const PerformanceMetrics({
    required this.accuracy,
    required this.errorRate,
    required this.missRate,
    required this.falseSelectionRate,
    required this.speedScore,
    required this.completed,
  });
}

class PerformanceAnalyzer {
  PerformanceMetrics analyze(GameResult result) {
    final accuracy = _calculateAccuracy(result);
    final errorRate = _calculateErrorRate(result);
    final missRate = _calculateMissRate(result);
    final falseSelectionRate = _calculateFalseSelectionRate(result);
    final speedScore = _calculateSpeedScore(result);

    return PerformanceMetrics(
      accuracy: accuracy,
      errorRate: errorRate,
      missRate: missRate,
      falseSelectionRate: falseSelectionRate,
      speedScore: speedScore,
      completed: result.completed,
    );
  }

  double _calculateAccuracy(GameResult result) {
    if (result.totalTargets == 0) {
      return 0.0;
    }

    return result.correct / result.totalTargets;
  }

  double _calculateErrorRate(GameResult result) {
    if (result.totalTargets == 0) {
      return 0.0;
    }

    return result.incorrect / result.totalTargets;
  }

  double _calculateMissRate(GameResult result) {
    if (result.totalTargets == 0) {
      return 0.0;
    }

    return result.missed / result.totalTargets;
  }

  double _calculateFalseSelectionRate(GameResult result) {
    final totalSelections = result.correct + result.incorrect;

    if (totalSelections == 0) {
      return 0.0;
    }

    return result.incorrect / totalSelections;
  }

  double _calculateSpeedScore(GameResult result) {
    if (result.responseTime <= 0) {
      return 0.0;
    }

    // Initial normalized speed score.
    // Lower response time = higher score.
    return 1 / (1 + result.responseTime);
  }
}