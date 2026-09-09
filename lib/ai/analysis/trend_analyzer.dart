import '../models/game_result.dart';

enum PerformanceTrend {
  improving,
  stable,
  declining,
  insufficientData,
}

class TrendAnalyzer {
  PerformanceTrend analyze(List<GameResult> sessions) {
    if (sessions.length < 4) {
      return PerformanceTrend.insufficientData;
    }

    final midpoint = sessions.length ~/ 2;

    final earlierSessions = sessions.sublist(0, midpoint);
    final recentSessions = sessions.sublist(midpoint);

    final earlierAverage = _averageAccuracy(earlierSessions);
    final recentAverage = _averageAccuracy(recentSessions);

    final difference = recentAverage - earlierAverage;

    if (difference > 0.05) {
      return PerformanceTrend.improving;
    }

    if (difference < -0.05) {
      return PerformanceTrend.declining;
    }

    return PerformanceTrend.stable;
  }

  double _averageAccuracy(List<GameResult> sessions) {
    if (sessions.isEmpty) {
      return 0.0;
    }

    double total = 0.0;

    for (final session in sessions) {
      if (session.totalTargets > 0) {
        total += session.correct / session.totalTargets;
      }
    }

    return total / sessions.length;
  }
}