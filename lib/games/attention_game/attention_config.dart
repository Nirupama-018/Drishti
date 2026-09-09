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

  static const level1 = AttentionGameConfig(
    difficultyLevel: 1,
    choiceCount: 4,
    trialCount: 5,
    timeLimit: 10.0,
  );

  static const level2 = AttentionGameConfig(
    difficultyLevel: 2,
    choiceCount: 6,
    trialCount: 7,
    timeLimit: 8.0,
  );

  static const level3 = AttentionGameConfig(
    difficultyLevel: 3,
    choiceCount: 8,
    trialCount: 10,
    timeLimit: 6.0,
  );

  static AttentionGameConfig forLevel(int level) {
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

  AttentionGameConfig copyWith({
    String? gameId,
    int? difficultyLevel,
    int? choiceCount,
    int? trialCount,
    double? timeLimit,
  }) {
    return AttentionGameConfig(
      gameId: gameId ?? this.gameId,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      choiceCount: choiceCount ?? this.choiceCount,
      trialCount: trialCount ?? this.trialCount,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'difficultyLevel': difficultyLevel,
      'choiceCount': choiceCount,
      'trialCount': trialCount,
      'timeLimit': timeLimit,
    };
  }
}