import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/analysis/trend_analyzer.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

GameResult createResult(double accuracy) {
  return GameResult(
    gameId: 'visual_memory',
    difficultyLevel: 1,
    totalTargets: 100,
    correct: (accuracy * 100).round(),
    incorrect: 0,
    missed: 0,
    accuracy: accuracy,
    responseTime: 10.0,
    completed: true,
  );
}

void main() {
  final analyzer = TrendAnalyzer();

  test('Detects improving performance', () {
    final sessions = [
      createResult(0.50),
      createResult(0.55),
      createResult(0.70),
      createResult(0.75),
    ];

    expect(
      analyzer.analyze(sessions),
      PerformanceTrend.improving,
    );
  });

  test('Detects declining performance', () {
    final sessions = [
      createResult(0.80),
      createResult(0.75),
      createResult(0.60),
      createResult(0.55),
    ];

    expect(
      analyzer.analyze(sessions),
      PerformanceTrend.declining,
    );
  });

  test('Detects stable performance', () {
    final sessions = [
      createResult(0.70),
      createResult(0.72),
      createResult(0.71),
      createResult(0.70),
    ];

    expect(
      analyzer.analyze(sessions),
      PerformanceTrend.stable,
    );
  });

  test('Returns insufficient data for fewer than four sessions', () {
    final sessions = [
      createResult(0.70),
      createResult(0.72),
      createResult(0.71),
    ];

    expect(
      analyzer.analyze(sessions),
      PerformanceTrend.insufficientData,
    );
  });
}
