import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/adaptation/adaptive_engine.dart';
import 'package:cognitive_care/ai/history/session_history.dart';
import 'package:cognitive_care/ai/models/cognitive_profile.dart';
import 'package:cognitive_care/ai/models/game_result.dart';

void main() {
  final engine = AdaptiveEngine();

  test('selects memory and starts at level 1 with insufficient data', () {
    final history = SessionHistory();

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.5,
        confidence: 0.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.5,
        confidence: 0.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_memory');
    expect(decision.difficultyLevel, 1);

    expect(decision.memoryConfig, isNotNull);
    expect(decision.memoryConfig!.objectCount, 3);
    expect(decision.memoryConfig!.distractorCount, 3);
    expect(decision.memoryConfig!.exposureTime, 8.0);

    expect(decision.attentionConfig, isNull);
  });

  test('increases memory difficulty when performance is strong',
          () {
        final history = SessionHistory();

        for (int i = 0; i < 4; i++) {
          history.addSession(
            const GameResult(
              gameId: 'visual_memory',
              difficultyLevel: 2,
              totalTargets: 10,
              correct: 9,
              incorrect: 1,
              missed: 1,
              accuracy: 0.9,
              responseTime: 10.0,
              completed: true,
            ),
          );
        }

        const profile = CognitiveProfile(
          visualMemory: CognitiveDomainProfile(
            performance: 0.9,
            trend: 1.0,
            confidence: 1.0,
          ),
          selectiveAttention: CognitiveDomainProfile(
            performance: 0.95,
            trend: 0.5,
            confidence: 1.0,
          ),
          processingSpeed: CognitiveDomainProfile(
            performance: 0.0,
            trend: 0.0,
            confidence: 0.0,
          ),
        );

        final decision = engine.generateNextDecision(
          profile: profile,
          history: history,
        );

        expect(decision.gameId, 'visual_memory');
        expect(decision.difficultyLevel, 3);

        expect(decision.memoryConfig, isNotNull);
        expect(decision.memoryConfig!.objectCount, 7);
      });

  test('decreases memory difficulty when performance is poor', () {
    final history = SessionHistory();

    for (int i = 0; i < 4; i++) {
      history.addSession(
        const GameResult(
          gameId: 'visual_memory',
          difficultyLevel: 2,
          totalTargets: 10,
          correct: 3,
          incorrect: 4,
          missed: 3,
          accuracy: 0.3,
          responseTime: 15.0,
          completed: true,
        ),
      );
    }

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.3,
        trend: 0.0,
        confidence: 1.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.7,
        trend: 0.5,
        confidence: 1.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_memory');
    expect(decision.difficultyLevel, 1);

    expect(decision.memoryConfig, isNotNull);
    expect(decision.memoryConfig!.difficultyLevel, 1);
    expect(decision.memoryConfig!.objectCount, 3);
    expect(decision.memoryConfig!.distractorCount, 3);
    expect(decision.memoryConfig!.exposureTime, 8);
  });
  test('selects weaker cognitive domain', () {
    final history = SessionHistory();

    // Both domains have enough data.
    for (int i = 0; i < 4; i++) {
      history.addSession(
        const GameResult(
          gameId: 'visual_memory',
          difficultyLevel: 2,
          totalTargets: 10,
          correct: 5,
          incorrect: 3,
          missed: 2,
          accuracy: 0.5,
          responseTime: 12.0,
          completed: true,
        ),
      );

      history.addSession(
        const GameResult(
          gameId: 'visual_attention',
          difficultyLevel: 2,
          totalTargets: 10,
          correct: 9,
          incorrect: 1,
          missed: 0,
          accuracy: 0.9,
          responseTime: 8.0,
          completed: true,
        ),
      );
    }

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.5,
        trend: 0.5,
        confidence: 1.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.9,
        trend: 0.5,
        confidence: 1.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_memory');
    expect(decision.difficultyLevel, 2);

    expect(decision.memoryConfig, isNotNull);
    expect(decision.attentionConfig, isNull);
  });

  test('selects attention when attention is the weaker domain', () {
    final history = SessionHistory();

    for (int i = 0; i < 4; i++) {
      history.addSession(
        const GameResult(
          gameId: 'visual_memory',
          difficultyLevel: 2,
          totalTargets: 10,
          correct: 9,
          incorrect: 1,
          missed: 0,
          accuracy: 0.9,
          responseTime: 8.0,
          completed: true,
        ),
      );

      history.addSession(
        const GameResult(
          gameId: 'visual_attention',
          difficultyLevel: 2,
          totalTargets: 10,
          correct: 5,
          incorrect: 3,
          missed: 2,
          accuracy: 0.5,
          responseTime: 12.0,
          completed: true,
        ),
      );
    }

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.9,
        trend: 0.5,
        confidence: 1.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.5,
        trend: 0.5,
        confidence: 1.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_attention');
    expect(decision.difficultyLevel, 2);

    expect(decision.attentionConfig, isNotNull);
    expect(decision.memoryConfig, isNull);
  });

  test('does not increase difficulty when performance is high but trend is declining', () {
    final history = SessionHistory();

    for (int i = 0; i < 4; i++) {
      history.addSession(
        const GameResult(
          gameId: 'visual_memory',
          difficultyLevel: 2,
          totalTargets: 10,
          correct: 8,
          incorrect: 1,
          missed: 1,
          accuracy: 0.8,
          responseTime: 10.0,
          completed: true,
        ),
      );
    }

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.8,
        trend: 0.0,
        confidence: 1.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.9,
        trend: 0.5,
        confidence: 1.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_memory');
    expect(decision.difficultyLevel, 2);

    expect(decision.memoryConfig, isNotNull);
    expect(decision.memoryConfig!.difficultyLevel, 2);
  });

  test('ignores incomplete attempts when building history', () {
    final history = SessionHistory();

    history.addSession(
      const GameResult(
        gameId: 'visual_memory',
        difficultyLevel: 2,
        totalTargets: 5,
        correct: 5,
        incorrect: 0,
        missed: 0,
        accuracy: 1.0,
        responseTime: 8.0,
        completed: true,
      ),
    );

    history.addSession(
      const GameResult(
        gameId: 'visual_memory',
        difficultyLevel: 2,
        totalTargets: 5,
        correct: 0,
        incorrect: 0,
        missed: 5,
        accuracy: 0.0,
        responseTime: 3.0,
        completed: false,
      ),
    );

    expect(history.sessionCount, 1);

    final memorySessions =
    history.getSessionsForGame('visual_memory');

    expect(memorySessions.length, 1);
    expect(memorySessions.first.accuracy, 1.0);
  });

  test('does not increase difficulty above level 3', () {
    final history = SessionHistory();

    history.addSession(
      const GameResult(
        gameId: 'visual_memory',
        difficultyLevel: 3,
        totalTargets: 10,
        correct: 10,
        incorrect: 0,
        missed: 0,
        accuracy: 1.0,
        responseTime: 5.0,
        completed: true,
      ),
    );

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.9,
        trend: 1.0,
        confidence: 1.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.95,
        trend: 0.5,
        confidence: 1.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_memory');
    expect(decision.difficultyLevel, 3);
    expect(decision.memoryConfig!.difficultyLevel, 3);
  });

  test('does not decrease difficulty below level 1', () {
    final history = SessionHistory();

    history.addSession(
      const GameResult(
        gameId: 'visual_memory',
        difficultyLevel: 1,
        totalTargets: 10,
        correct: 1,
        incorrect: 5,
        missed: 4,
        accuracy: 0.1,
        responseTime: 20.0,
        completed: true,
      ),
    );

    const profile = CognitiveProfile(
      visualMemory: CognitiveDomainProfile(
        performance: 0.1,
        trend: 0.0,
        confidence: 1.0,
      ),
      selectiveAttention: CognitiveDomainProfile(
        performance: 0.9,
        trend: 0.5,
        confidence: 1.0,
      ),
      processingSpeed: CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      ),
    );

    final decision = engine.generateNextDecision(
      profile: profile,
      history: history,
    );

    expect(decision.gameId, 'visual_memory');
    expect(decision.difficultyLevel, 1);
    expect(decision.memoryConfig!.difficultyLevel, 1);
  });
}
