import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/adaptation/game_selector.dart';
import 'package:cognitive_care/ai/history/session_history.dart';
import 'package:cognitive_care/ai/models/cognitive_profile.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

CognitiveDomainProfile createDomain({
  required double performance,
  required double confidence,
}) {
  return CognitiveDomainProfile(
    performance: performance,
    trend: 0.5,
    confidence: confidence,
  );
}

CognitiveProfile createProfile({
  required double memoryPerformance,
  required double memoryConfidence,
  required double attentionPerformance,
  required double attentionConfidence,
}) {
  return CognitiveProfile(
    visualMemory: createDomain(
      performance: memoryPerformance,
      confidence: memoryConfidence,
    ),
    selectiveAttention: createDomain(
      performance: attentionPerformance,
      confidence: attentionConfidence,
    ),
    processingSpeed: const CognitiveDomainProfile(
      performance: 0.0,
      trend: 0.0,
      confidence: 0.0,
    ),
  );
}

GameResult createResult(String gameId) {
  return GameResult(
    gameId: gameId,
    difficultyLevel: 1,
    totalTargets: 10,
    correct: 7,
    incorrect: 2,
    missed: 1,
    accuracy: 0.7,
    responseTime: 10.0,
    completed: true,
  );
}

void main() {
  final selector = GameSelector();

  test('Selects memory when memory is weaker', () {
    final profile = createProfile(
      memoryPerformance: 0.55,
      memoryConfidence: 1.0,
      attentionPerformance: 0.80,
      attentionConfidence: 1.0,
    );

    final history = SessionHistory();

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_memory',
    );
  });

  test('Selects attention when attention is weaker', () {
    final profile = createProfile(
      memoryPerformance: 0.80,
      memoryConfidence: 1.0,
      attentionPerformance: 0.55,
      attentionConfidence: 1.0,
    );

    final history = SessionHistory();

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_attention',
    );
  });

  test('Alternates when both domains have equal performance', () {
    final profile = createProfile(
      memoryPerformance: 0.70,
      memoryConfidence: 1.0,
      attentionPerformance: 0.70,
      attentionConfidence: 1.0,
    );

    final history = SessionHistory();

    history.addSession(
      createResult('visual_memory'),
    );

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_attention',
    );
  });

  test('Alternates to memory after attention', () {
    final profile = createProfile(
      memoryPerformance: 0.70,
      memoryConfidence: 1.0,
      attentionPerformance: 0.70,
      attentionConfidence: 1.0,
    );

    final history = SessionHistory();

    history.addSession(
      createResult('visual_attention'),
    );

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_memory',
    );
  });

  test('Chooses memory when memory has insufficient data', () {
    final profile = createProfile(
      memoryPerformance: 0.0,
      memoryConfidence: 0.25,
      attentionPerformance: 0.80,
      attentionConfidence: 1.0,
    );

    final history = SessionHistory();

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_memory',
    );
  });

  test('Chooses attention when attention has insufficient data', () {
    final profile = createProfile(
      memoryPerformance: 0.80,
      memoryConfidence: 1.0,
      attentionPerformance: 0.0,
      attentionConfidence: 0.25,
    );

    final history = SessionHistory();

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_attention',
    );
  });

  test('Uses memory as default when there is no data', () {
    final profile = createProfile(
      memoryPerformance: 0.0,
      memoryConfidence: 0.0,
      attentionPerformance: 0.0,
      attentionConfidence: 0.0,
    );

    final history = SessionHistory();

    expect(
      selector.selectGame(
        profile: profile,
        history: history,
      ),
      'visual_memory',
    );
  });
}
