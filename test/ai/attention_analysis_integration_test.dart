import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/analysis/performance_analyzer.dart';
import 'package:cognitive_care/ai/integration/attention_result_adapter.dart';
import 'package:cognitive_care/games/attention_game/attention_result.dart';

void main() {
  test('attention game result integrates with performance analyzer', () {
    const attentionResult = AttentionGameResult(
      gameId: 'visual_attention',
      difficultyLevel: 2,
      totalTrials: 7,
      correct: 5,
      incorrect: 1,
      missed: 1,
      accuracy: 5 / 7,
      averageResponseTime: 4.5,
      completed: true,
    );

    final gameResult =
    AttentionResultAdapter.toGameResult(attentionResult);

    final analyzer = PerformanceAnalyzer();
    final metrics = analyzer.analyze(gameResult);

    expect(metrics.accuracy, closeTo(5 / 7, 0.0001));
    expect(metrics.errorRate, closeTo(1 / 7, 0.0001));
    expect(metrics.missRate, closeTo(1 / 7, 0.0001));

    // falseSelectionRate = incorrect / (correct + incorrect)
    expect(metrics.falseSelectionRate, closeTo(1 / 6, 0.0001));

    expect(metrics.speedScore, closeTo(1 / 5.5, 0.0001));
    expect(metrics.completed, true);
  });
}
