import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/history/session_history.dart';
import 'package:cognitive_care/ai/integration/adaptive_game_service.dart';
import 'package:cognitive_care/ai/models/cognitive_profile.dart';

void main() {
  group('AdaptiveGameService', () {
    test('generates a next game decision', () {
      final service = AdaptiveGameService();

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

      final history = SessionHistory();

      final decision = service.getNextGame(
        profile: profile,
        history: history,
      );

      expect(decision.gameId, 'visual_memory');
      expect(decision.difficultyLevel, 1);
      expect(decision.memoryConfig, isNotNull);
    });
  });
}
