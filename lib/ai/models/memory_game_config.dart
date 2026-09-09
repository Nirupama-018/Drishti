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
}