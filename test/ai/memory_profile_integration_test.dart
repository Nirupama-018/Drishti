import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/integration/memory_result_adapter.dart';
import 'package:cognitive_care/ai/history/session_history.dart';
import 'package:cognitive_care/ai/analysis/cognitive_profile_builder.dart';
import 'package:cognitive_care/games/memory_game/memory_result.dart';
void main() {
  test('memory game results build a visual memory profile', () {
    const results = [
      MemoryGameResult(
        gameId: 'visual_memory',
        difficultyLevel: 1,
        totalTargets: 5,
        correct: 3,
        incorrect: 1,
        missed: 1,
        accuracy: 0.6,
        responseTime: 15.0,
        completed: true,
      ),
      MemoryGameResult(
        gameId: 'visual_memory',
        difficultyLevel: 1,
        totalTargets: 5,
        correct: 4,
        incorrect: 1,
        missed: 0,
        accuracy: 0.8,
        responseTime: 14.0,
        completed: true,
      ),
      MemoryGameResult(
        gameId: 'visual_memory',
        difficultyLevel: 1,
        totalTargets: 5,
        correct: 4,
        incorrect: 0,
        missed: 1,
        accuracy: 0.8,
        responseTime: 13.0,
        completed: true,
      ),
      MemoryGameResult(
        gameId: 'visual_memory',
        difficultyLevel: 1,
        totalTargets: 5,
        correct: 5,
        incorrect: 0,
        missed: 0,
        accuracy: 1.0,
        responseTime: 11.0,
        completed: true,
      ),
    ];

    final history = SessionHistory();

    for (final result in results) {
      final gameResult =
      MemoryResultAdapter.toGameResult(result);

      history.addSession(gameResult);
    }

    final builder = CognitiveProfileBuilder();

    final profile = builder.build(history);

    expect(
      profile.visualMemory.performance,
      closeTo(0.8, 0.0001),
    );

    expect(
      profile.visualMemory.trend,
      1.0,
    );

    expect(
      profile.visualMemory.confidence,
      1.0,
    );
  });
}
