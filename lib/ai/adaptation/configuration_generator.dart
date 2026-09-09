import '../models/memory_game_config.dart';
import '../models/attention_game_config.dart';

class ConfigurationGenerator {
  MemoryGameConfig generateMemoryConfig(int difficultyLevel) {
    switch (difficultyLevel) {
      case 1:
        return const MemoryGameConfig(
          difficultyLevel: 1,
          objectCount: 3,
          distractorCount: 3,
          exposureTime: 8,
        );

      case 2:
        return const MemoryGameConfig(
          difficultyLevel: 2,
          objectCount: 5,
          distractorCount: 3,
          exposureTime: 7,
        );

      case 3:
        return const MemoryGameConfig(
          difficultyLevel: 3,
          objectCount: 7,
          distractorCount: 3,
          exposureTime: 6,
        );

      default:
        return const MemoryGameConfig(
          difficultyLevel: 1,
          objectCount: 3,
          distractorCount: 3,
          exposureTime: 8,
        );
    }
  }

  AttentionGameConfig generateAttentionConfig(int difficultyLevel) {
    switch (difficultyLevel) {
      case 1:
        return const AttentionGameConfig(
          difficultyLevel: 1,
          choiceCount: 4,
          trialCount: 5,
          timeLimit: 10.0,
        );

      case 2:
        return const AttentionGameConfig(
          difficultyLevel: 2,
          choiceCount: 6,
          trialCount: 7,
          timeLimit: 8.0,
        );

      case 3:
        return const AttentionGameConfig(
          difficultyLevel: 3,
          choiceCount: 8,
          trialCount: 10,
          timeLimit: 6.0,
        );

      default:
        return const AttentionGameConfig(
          difficultyLevel: 1,
          choiceCount: 4,
          trialCount: 5,
          timeLimit: 10.0,
        );
    }
  }
}