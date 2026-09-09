class MemoryGameConfig {
  final String gameId;
  final int difficultyLevel;
  final int objectCount;
  final int distractorCount;
  final int exposureTime;

  const MemoryGameConfig({
    this.gameId = 'visual_memory',
    required this.difficultyLevel,
    required this.objectCount,
    required this.distractorCount,
    required this.exposureTime,
  });

  /// Default configuration for Level 1.
  static const level1 = MemoryGameConfig(
    difficultyLevel: 1,
    objectCount: 3,
    distractorCount: 3,
    exposureTime: 8,
  );

  /// Default configuration for Level 2.
  static const level2 = MemoryGameConfig(
    difficultyLevel: 2,
    objectCount: 5,
    distractorCount: 3,
    exposureTime: 7,
  );

  /// Default configuration for Level 3.
  static const level3 = MemoryGameConfig(
    difficultyLevel: 3,
    objectCount: 7,
    distractorCount: 3,
    exposureTime: 6,
  );

  /// Returns the default configuration for a given difficulty level.
  static MemoryGameConfig forLevel(int level) {
    switch (level) {
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      default:
        return level1;
    }
  }

  /// Creates a configuration that can be supplied by the AI.
  MemoryGameConfig copyWith({
    String? gameId,
    int? difficultyLevel,
    int? objectCount,
    int? distractorCount,
    int? exposureTime,
  }) {
    return MemoryGameConfig(
      gameId: gameId ?? this.gameId,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      objectCount: objectCount ?? this.objectCount,
      distractorCount: distractorCount ?? this.distractorCount,
      exposureTime: exposureTime ?? this.exposureTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'difficultyLevel': difficultyLevel,
      'objectCount': objectCount,
      'distractorCount': distractorCount,
      'exposureTime': exposureTime,
    };
  }
}