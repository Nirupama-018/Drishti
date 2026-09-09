import '../models/game_result.dart';

class PatientSessionService {
  static final PatientSessionService _instance =
      PatientSessionService._internal();

  factory PatientSessionService() {
    return _instance;
  }

  PatientSessionService._internal();

  final List<GameResult> _results = [];

  Future<void> saveGameResult(GameResult result) async {
    _results.add(result);
  }

  List<GameResult> getResults() {
    return List.unmodifiable(_results);
  }

  int get completedActivities {
    return _results.where((r) => r.completed).length;
  }

  double get averageAccuracy {
    final completed = _results.where((r) => r.completed).toList();

    if (completed.isEmpty) {
      return 0;
    }

    final total = completed.fold<double>(
      0,
      (sum, result) => sum + result.accuracy,
    );

    return total / completed.length;
  }
}
