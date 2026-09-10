import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/integration/memory_result_adapter.dart';
import 'package:cognitive_care/games/memory_game/memory_result.dart';

void main() {
  test('converts MemoryGameResult to GameResult', () {
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

    expect(gameResult.gameId, 'visual_memory');
    expect(gameResult.difficultyLevel, 2);
    expect(gameResult.totalTargets, 5);
    expect(gameResult.correct, 4);
    expect(gameResult.incorrect, 1);
    expect(gameResult.missed, 1);
    expect(gameResult.accuracy, 0.8);
    expect(gameResult.responseTime, 12.5);
    expect(gameResult.completed, true);
  });
}
