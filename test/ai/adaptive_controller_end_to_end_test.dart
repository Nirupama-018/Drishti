import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/adaptation/adaptive_controller.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

void main() {
  test('adaptive controller works with both cognitive games', () {
    final controller = AdaptiveController();

    const memoryResult = GameResult(
      gameId: 'visual_memory',
      difficultyLevel: 1,
      totalTargets: 5,
      correct: 3,
      incorrect: 1,
      missed: 1,
      accuracy: 0.6,
      responseTime: 8.0,
      completed: true,
    );

    final firstDecision = controller.processResult(memoryResult);

    expect(controller.history.sessionCount, 1);
    expect(firstDecision.gameId, isNotNull);

    const attentionResult = GameResult(
      gameId: 'visual_attention',
      difficultyLevel: 1,
      totalTargets: 5,
      correct: 5,
      incorrect: 0,
      missed: 0,
      accuracy: 1.0,
      responseTime: 4.0,
      completed: true,
    );

    final secondDecision =
    controller.processResult(attentionResult);

    expect(controller.history.sessionCount, 2);
    expect(secondDecision.gameId, isNotNull);

    final profile = controller.currentProfile;

    expect(
      profile.visualMemory.performance,
      closeTo(0.6, 0.0001),
    );

    expect(
      profile.selectiveAttention.performance,
      closeTo(1.0, 0.0001),
    );
  });

  test('prioritizes weaker cognitive domain after both games have data', () {
    final controller = AdaptiveController();

    for (int i = 0; i < 4; i++) {
      controller.processResult(
        const GameResult(
          gameId: 'visual_memory',
          difficultyLevel: 2,
          totalTargets: 5,
          correct: 2,
          incorrect: 2,
          missed: 1,
          accuracy: 0.4,
          responseTime: 10.0,
          completed: true,
        ),
      );

      controller.processResult(
        const GameResult(
          gameId: 'visual_attention',
          difficultyLevel: 2,
          totalTargets: 5,
          correct: 5,
          incorrect: 0,
          missed: 0,
          accuracy: 1.0,
          responseTime: 4.0,
          completed: true,
        ),
      );
    }

    final decision = controller.processResult(
      const GameResult(
        gameId: 'visual_memory',
        difficultyLevel: 2,
        totalTargets: 5,
        correct: 2,
        incorrect: 2,
        missed: 1,
        accuracy: 0.4,
        responseTime: 10.0,
        completed: true,
      ),
    );

    expect(decision.gameId, 'visual_memory');
  });

  test('keeps generated difficulty within valid range', () {
    final controller = AdaptiveController();

    const result = GameResult(
      gameId: 'visual_attention',
      difficultyLevel: 2,
      totalTargets: 7,
      correct: 7,
      incorrect: 0,
      missed: 0,
      accuracy: 1.0,
      responseTime: 4.0,
      completed: true,
    );

    final decision = controller.processResult(result);

    expect(decision.difficultyLevel, greaterThanOrEqualTo(1));
    expect(decision.difficultyLevel, lessThanOrEqualTo(3));
  });
}
