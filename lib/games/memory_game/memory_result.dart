class MemoryGameResult {
  final String gameId;
  final int difficultyLevel;
  final int totalTargets;
  final int correct;
  final int incorrect;
  final int missed;
  final double accuracy;
  final double responseTime;
  final bool completed;

  const MemoryGameResult({
    required this.gameId,
    required this.difficultyLevel,
    required this.totalTargets,
    required this.correct,
    required this.incorrect,
    required this.missed,
    required this.accuracy,
    required this.responseTime,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'difficultyLevel': difficultyLevel,
      'totalTargets': totalTargets,
      'correct': correct,
      'incorrect': incorrect,
      'missed': missed,
      'accuracy': accuracy,
      'responseTime': responseTime,
      'completed': completed,
    };
  }
}