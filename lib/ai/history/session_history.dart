import '../models/game_result.dart';

class SessionHistory {
  final List<GameResult> sessions;

  SessionHistory({
    List<GameResult>? sessions,
  }) : sessions = sessions ?? [];

  void addSession(GameResult result) {
    if (result.completed) {
      sessions.add(result);
    }
  }

  List<GameResult> getSessionsForGame(String gameId) {
    return sessions
        .where((session) => session.gameId == gameId)
        .toList();
  }

  int get sessionCount => sessions.length;
}