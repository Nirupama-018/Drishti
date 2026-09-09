import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/integration/attention_result_adapter.dart';
import 'package:cognitive_care/games/attention_game/attention_result.dart';
void main() {
  test('maps AttentionGameResult to generic GameResult', () {
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

    final result =
    AttentionResultAdapter.toGameResult(attentionResult);

    expect(result.gameId, 'visual_attention');
    expect(result.difficultyLevel, 2);
    expect(result.totalTargets, 7);
    expect(result.correct, 5);
    expect(result.incorrect, 1);
    expect(result.missed, 1);
    expect(result.accuracy, closeTo(5 / 7, 0.0001));
    expect(result.responseTime, 4.5);
    expect(result.completed, true);
  });
}
