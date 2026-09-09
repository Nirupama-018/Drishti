import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/analysis/cognitive_profile_builder.dart';
import 'package:cognitive_care/ai/history/session_history.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

GameResult createResult({
  required String gameId,
  required double accuracy,
}) {
  return GameResult(
    gameId: gameId,
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
  test('Builds visual memory profile correctly', () {
    final history = SessionHistory();

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.60,
      ),
    );

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.70,
      ),
    );

    final builder = CognitiveProfileBuilder();
    final profile = builder.build(history);

    expect(
      profile.visualMemory.performance,
      closeTo(0.65, 0.0001),
    );
    expect(profile.visualMemory.confidence, 0.50);
  });

  test('Builds improving trend correctly', () {
    final history = SessionHistory();

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.50,
      ),
    );

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.55,
      ),
    );

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.70,
      ),
    );

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.75,
      ),
    );

    final builder = CognitiveProfileBuilder();
    final profile = builder.build(history);

    expect(profile.visualMemory.trend, 1.0);
    expect(profile.visualMemory.confidence, 1.0);
  });

  test('Separates memory and attention sessions', () {
    final history = SessionHistory();

    history.addSession(
      createResult(
        gameId: 'visual_memory',
        accuracy: 0.80,
      ),
    );

    history.addSession(
      createResult(
        gameId: 'visual_attention',
        accuracy: 0.60,
      ),
    );

    final builder = CognitiveProfileBuilder();
    final profile = builder.build(history);

    expect(profile.visualMemory.performance, 0.80);
    expect(profile.selectiveAttention.performance, 0.60);
  });

  test('Empty history produces zero confidence', () {
    final history = SessionHistory();

    final builder = CognitiveProfileBuilder();
    final profile = builder.build(history);

    expect(profile.visualMemory.performance, 0.0);
    expect(profile.visualMemory.confidence, 0.0);

    expect(profile.selectiveAttention.performance, 0.0);
    expect(profile.selectiveAttention.confidence, 0.0);
  });
}
