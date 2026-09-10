class AttentionGameResult {
  final String gameId;
  final int difficultyLevel;
  final int totalTrials;
  final int correct;
  final int incorrect;
  final int missed;
  final double accuracy;
  final double averageResponseTime;
  final bool completed;

  const AttentionGameResult({
    required this.gameId,
    required this.difficultyLevel,
    required this.totalTrials,
    required this.correct,
    required this.incorrect,
    required this.missed,
    required this.accuracy,
    required this.averageResponseTime,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'difficultyLevel': difficultyLevel,
      'totalTrials': totalTrials,
      'correct': correct,
      'incorrect': incorrect,
      'missed': missed,
      'accuracy': accuracy,
      'averageResponseTime': averageResponseTime,
      'completed': completed,
    };
  }
}