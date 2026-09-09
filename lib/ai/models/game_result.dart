class GameResult {
  final String gameId;
  final int difficultyLevel;
  final int totalTargets;
  final int correct;
  final int incorrect;
  final int missed;
  final double accuracy;
  final double responseTime;
  final bool completed;

  const GameResult({
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
}