import '../history/session_history.dart';
import '../models/adaptation_decision.dart';
import '../models/cognitive_profile.dart';
import 'configuration_generator.dart';
import 'difficulty_adjuster.dart';
import 'game_selector.dart';

class AdaptiveEngine {
  final GameSelector gameSelector;
  final DifficultyAdjuster difficultyAdjuster;
  final ConfigurationGenerator configurationGenerator;

  AdaptiveEngine({
    GameSelector? gameSelector,
    DifficultyAdjuster? difficultyAdjuster,
    ConfigurationGenerator? configurationGenerator,
  })  : gameSelector = gameSelector ?? GameSelector(),
        difficultyAdjuster =
            difficultyAdjuster ?? DifficultyAdjuster(),
        configurationGenerator =
            configurationGenerator ?? ConfigurationGenerator();

  AdaptationDecision generateNextDecision({
    required CognitiveProfile profile,
    required SessionHistory history,
  }) {
    // Step 1: Select the next game.
    final gameId = gameSelector.selectGame(
      profile: profile,
      history: history,
    );

    // Step 2: Find the most recent difficulty for that game.
    final currentDifficulty =
    _getCurrentDifficulty(gameId, history);

    // Step 3: Get the profile for the selected game.
    final domainProfile = _getDomainProfile(
      gameId,
      profile,
    );

    // Step 4: Adjust the difficulty.
    final difficultyLevel =
    difficultyAdjuster.adjustDifficulty(
      profile: domainProfile,
      currentDifficulty: currentDifficulty,
    );

    // Step 5: Generate the actual game configuration.
    if (gameId == 'visual_memory') {
      final config =
      configurationGenerator.generateMemoryConfig(
        difficultyLevel,
      );

      return AdaptationDecision(
        gameId: gameId,
        difficultyLevel: difficultyLevel,
        memoryConfig: config,
      );
    }

    final config =
    configurationGenerator.generateAttentionConfig(
      difficultyLevel,
    );

    return AdaptationDecision(
      gameId: gameId,
      difficultyLevel: difficultyLevel,
      attentionConfig: config,
    );
  }

  int _getCurrentDifficulty(
      String gameId,
      SessionHistory history,
      ) {
    final sessions =
    history.getSessionsForGame(gameId);

    if (sessions.isEmpty) {
      return 1;
    }

    return sessions.last.difficultyLevel;
  }

  CognitiveDomainProfile _getDomainProfile(
      String gameId,
      CognitiveProfile profile,
      ) {
    if (gameId == 'visual_memory') {
      return profile.visualMemory;
    }

    return profile.selectiveAttention;
  }
}