class GameResult {
  final String gameId;
  final int difficultyLevel;

  final int totalTrials;
  final int correct;
  final int incorrect;
  final int missed;

  final double accuracy;
  final double responseTime;

  final bool completed;

  const GameResult({
    required this.gameId,
    required this.difficultyLevel,
    required this.totalTrials,
    required this.correct,
    required this.incorrect,
    required this.missed,
    required this.accuracy,
    required this.responseTime,
    required this.completed,
  });

  factory GameResult.fromMemoryResult(dynamic result) {
    return GameResult(
      gameId: result.gameId,
      difficultyLevel: result.difficultyLevel,
      totalTrials: result.totalTargets,
      correct: result.correct,
      incorrect: result.incorrect,
      missed: result.missed,
      accuracy: result.accuracy,
      responseTime: result.responseTime,
      completed: result.completed,
    );
  }

  factory GameResult.fromAttentionResult(dynamic result) {
    return GameResult(
      gameId: result.gameId,
      difficultyLevel: result.difficultyLevel,
      totalTrials: result.totalTrials,
      correct: result.correct,
      incorrect: result.incorrect,
      missed: result.missed,
      accuracy: result.accuracy,
      responseTime: result.averageResponseTime,
      completed: result.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'difficultyLevel': difficultyLevel,
      'totalTrials': totalTrials,
      'correct': correct,
      'incorrect': incorrect,
      'missed': missed,
      'accuracy': accuracy,
      'responseTime': responseTime,
      'completed': completed,
    };
  }

  String get gameName {
    if (gameId == 'visual_memory') {
      return 'Remember the Objects';
    }

    if (gameId == 'visual_attention') {
      return 'Find the Target';
    }

    return 'Cognitive Activity';
  }

  int get percentage {
    return (accuracy * 100).round();
  }
}
