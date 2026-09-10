import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/analysis/performance_analyzer.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

void main() {
  test('Performance analyzer calculates metrics correctly', () {
    const result = GameResult(
      gameId: 'visual_memory',
      difficultyLevel: 2,
      totalTargets: 5,
      correct: 4,
      incorrect: 1,
      missed: 1,
      accuracy: 0.8,
      responseTime: 10.0,
      completed: true,
    );

    final analyzer = PerformanceAnalyzer();
    final metrics = analyzer.analyze(result);

    expect(metrics.accuracy, 0.8);
    expect(metrics.errorRate, 0.2);
    expect(metrics.missRate, 0.2);
    expect(metrics.falseSelectionRate, 0.2);
    expect(metrics.completed, true);
  });
}
