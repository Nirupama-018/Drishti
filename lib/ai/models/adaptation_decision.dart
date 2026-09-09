import 'memory_game_config.dart';
import 'attention_game_config.dart';

class AdaptationDecision {
  final String gameId;
  final int difficultyLevel;

  final MemoryGameConfig? memoryConfig;
  final AttentionGameConfig? attentionConfig;

  const AdaptationDecision({
    required this.gameId,
    required this.difficultyLevel,
    this.memoryConfig,
    this.attentionConfig,
  });
}