class AttentionGameConfig {
  final String gameId;
  final int difficultyLevel;
  final int choiceCount;
  final int trialCount;
  final double timeLimit;

  const AttentionGameConfig({
    this.gameId = 'visual_attention',
    required this.difficultyLevel,
    required this.choiceCount,
    required this.trialCount,
    required this.timeLimit,
  });
}