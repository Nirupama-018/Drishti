import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/integration/memory_result_adapter.dart';
import 'package:cognitive_care/ai/analysis/performance_analyzer.dart';
import 'package:cognitive_care/games/memory_game/memory_result.dart';

void main() {
  test('memory game result flows through adapter and performance analyzer', () {
    const memoryResult = MemoryGameResult(
      gameId: 'visual_memory',
      difficultyLevel: 2,
      totalTargets: 5,
      correct: 4,
      incorrect: 1,
      missed: 1,
      accuracy: 0.8,
      responseTime: 12.5,
      completed: true,
    );

    final gameResult =
    MemoryResultAdapter.toGameResult(memoryResult);

    final analyzer = PerformanceAnalyzer();

    final metrics = analyzer.analyze(gameResult);

    expect(metrics.accuracy, closeTo(0.8, 0.0001));
    expect(metrics.errorRate, closeTo(0.2, 0.0001));
    expect(metrics.missRate, closeTo(0.2, 0.0001));
    expect(metrics.falseSelectionRate, closeTo(0.2, 0.0001));
    expect(metrics.speedScore, closeTo(1 / 13.5, 0.0001));
    expect(metrics.completed, true);
  });
}
