
class GamePerformance {
final String patientId;
final String gameName;
final int difficulty;
final double score;
final double accuracy;
final double responseTime;
final int mistakes;
final DateTime timestamp;

const GamePerformance({
required this.patientId,
required this.gameName,
required this.difficulty,
required this.score,
required this.accuracy,
required this.responseTime,
required this.mistakes,
required this.timestamp,
});
}
