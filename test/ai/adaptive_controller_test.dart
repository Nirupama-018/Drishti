import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/adaptation/adaptive_controller.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

void main() {
  test('processes a completed result and generates next decision', () {
    final controller = AdaptiveController();

    const result = GameResult(
      gameId: 'visual_memory',
      difficultyLevel: 1,
      totalTargets: 5,
      correct: 4,
      incorrect: 1,
      missed: 0,
      accuracy: 0.8,
      responseTime: 8.0,
      completed: true,
    );

    final decision = controller.processResult(result);

    expect(controller.history.sessionCount, 1);

    expect(decision.gameId, isNotNull);
    expect(decision.difficultyLevel, inInclusiveRange(1, 3));
  });

  test('ignores incomplete result', () {
    final controller = AdaptiveController();

    const result = GameResult(
      gameId: 'visual_memory',
      difficultyLevel: 1,
      totalTargets: 5,
      correct: 0,
      incorrect: 0,
      missed: 5,
      accuracy: 0.0,
      responseTime: 3.0,
      completed: false,
    );

    controller.processResult(result);

    expect(controller.history.sessionCount, 0);
  });

  test('updates cognitive profile after completed result', () {
    final controller = AdaptiveController();

    const result = GameResult(
      gameId: 'visual_memory',
      difficultyLevel: 1,
      totalTargets: 5,
      correct: 4,
      incorrect: 1,
      missed: 0,
      accuracy: 0.8,
      responseTime: 8.0,
      completed: true,
    );

    controller.processResult(result);

    expect(
      controller.currentProfile.visualMemory.performance,
      closeTo(0.8, 0.0001),
    );

    expect(
      controller.currentProfile.visualMemory.confidence,
      closeTo(0.25, 0.0001),
    );
  });
}
