class GameConfig {
  final String gameId;
  final int difficultyLevel;

  // Remember the Objects
  final int? objectCount;
  final int? distractorCount;
  final int? exposureTime;

  // Find the Target
  final int? choiceCount;
  final int? trialCount;
  final double? timeLimit;

  const GameConfig({
    required this.gameId,
    required this.difficultyLevel,
    this.objectCount,
    this.distractorCount,
    this.exposureTime,
    this.choiceCount,
    this.trialCount,
    this.timeLimit,
  });

  bool get isMemoryGame => gameId == 'visual_memory';

  bool get isAttentionGame => gameId == 'visual_attention';

  // -------------------------
  // MEMORY DEFAULTS
  // -------------------------

  factory GameConfig.memoryLevel1() {
    return const GameConfig(
      gameId: 'visual_memory',
      difficultyLevel: 1,
      objectCount: 3,
      distractorCount: 3,
      exposureTime: 8,
    );
  }

  factory GameConfig.memoryLevel2() {
    return const GameConfig(
      gameId: 'visual_memory',
      difficultyLevel: 2,
      objectCount: 5,
      distractorCount: 3,
      exposureTime: 7,
    );
  }

  factory GameConfig.memoryLevel3() {
    return const GameConfig(
      gameId: 'visual_memory',
      difficultyLevel: 3,
      objectCount: 7,
      distractorCount: 3,
      exposureTime: 6,
    );
  }

  // -------------------------
  // ATTENTION DEFAULTS
  // -------------------------

  factory GameConfig.attentionLevel1() {
    return const GameConfig(
      gameId: 'visual_attention',
      difficultyLevel: 1,
      choiceCount: 4,
      trialCount: 5,
      timeLimit: 10.0,
    );
  }

  factory GameConfig.attentionLevel2() {
    return const GameConfig(
      gameId: 'visual_attention',
      difficultyLevel: 2,
      choiceCount: 6,
      trialCount: 7,
      timeLimit: 8.0,
    );
  }

  factory GameConfig.attentionLevel3() {
    return const GameConfig(
      gameId: 'visual_attention',
      difficultyLevel: 3,
      choiceCount: 8,
      trialCount: 10,
      timeLimit: 6.0,
    );
  }
}
