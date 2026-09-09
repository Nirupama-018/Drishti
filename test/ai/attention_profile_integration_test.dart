import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/history/session_history.dart';
import 'package:cognitive_care/ai/integration/attention_result_adapter.dart';
import 'package:cognitive_care/ai/analysis/cognitive_profile_builder.dart';
import 'package:cognitive_care/games/attention_game/attention_result.dart';

void main() {
  test('attention game results build selective attention profile', () {
    const results = [
      AttentionGameResult(
        gameId: 'visual_attention',
        difficultyLevel: 1,
        totalTrials: 5,
        correct: 3,
        incorrect: 1,
        missed: 1,
        accuracy: 0.6,
        averageResponseTime: 6.0,
        completed: true,
      ),
      AttentionGameResult(
        gameId: 'visual_attention',
        difficultyLevel: 1,
        totalTrials: 5,
        correct: 4,
        incorrect: 1,
        missed: 0,
        accuracy: 0.8,
        averageResponseTime: 5.0,
        completed: true,
      ),
      AttentionGameResult(
        gameId: 'visual_attention',
        difficultyLevel: 2,
        totalTrials: 7,
        correct: 5,
        incorrect: 1,
        missed: 1,
        accuracy: 5 / 7,
        averageResponseTime: 4.5,
        completed: true,
      ),
      AttentionGameResult(
        gameId: 'visual_attention',
        difficultyLevel: 2,
        totalTrials: 7,
        correct: 6,
        incorrect: 1,
        missed: 0,
        accuracy: 6 / 7,
        averageResponseTime: 4.0,
        completed: true,
      ),
    ];

    final history = SessionHistory();

    for (final attentionResult in results) {
      final gameResult =
      AttentionResultAdapter.toGameResult(attentionResult);

      history.addSession(gameResult);
    }

    final builder = CognitiveProfileBuilder();
    final profile = builder.build(history);

    expect(
      profile.selectiveAttention.performance,
      closeTo((0.6 + 0.8 + (5 / 7) + (6 / 7)) / 4, 0.0001),
    );

    expect(profile.selectiveAttention.trend, 1.0);
    expect(profile.selectiveAttention.confidence, 1.0);

    expect(profile.visualMemory.confidence, 0.0);
  });
}
