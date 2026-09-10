import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/game_performance.dart';

class CaregiverService {
  CaregiverService._();

  static final CaregiverService instance = CaregiverService._();

  final List<GamePerformance> sessions = [];

  static const String _storageKey = 'game_performance_sessions';

  // Load saved sessions
  Future<void> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString(_storageKey);

    if (savedData == null) {
      _addDemoSessions();
      await _saveSessions();
      return;
    }

    final List<dynamic> data = jsonDecode(savedData);

    sessions.clear();

    for (final item in data) {
      sessions.add(
        GamePerformance(
          patientId: item['patientId'],
          gameName: item['gameName'],
          difficulty: item['difficulty'],
          score: (item['score'] as num).toDouble(),
          accuracy: (item['accuracy'] as num).toDouble(),
          responseTime: (item['responseTime'] as num).toDouble(),
          mistakes: item['mistakes'],
          timestamp: DateTime.parse(item['timestamp']),
        ),
      );
    }
  }

  // Add a new session and save it
  Future<void> addSession(GamePerformance session) async {
    sessions.add(session);
    await _saveSessions();
  }

  // Save sessions locally
  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();

    final data = sessions.map((session) {
      return {
        'patientId': session.patientId,
        'gameName': session.gameName,
        'difficulty': session.difficulty,
        'score': session.score,
        'accuracy': session.accuracy,
        'responseTime': session.responseTime,
        'mistakes': session.mistakes,
        'timestamp': session.timestamp.toIso8601String(),
      };
    }).toList();

    await prefs.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  // Get sessions for a patient
  List<GamePerformance> getSessions(String patientId) {
    return sessions
        .where((session) => session.patientId == patientId)
        .toList();
  }

  // Initial demo sessions
  void _addDemoSessions() {
    sessions.addAll([
      GamePerformance(
        patientId: 'P001',
        gameName: 'Remember the Objects',
        difficulty: 1,
        score: 70,
        accuracy: 70,
        responseTime: 50,
        mistakes: 3,
        timestamp: DateTime.now().subtract(
          const Duration(days: 4),
        ),
      ),

      GamePerformance(
        patientId: 'P001',
        gameName: 'Remember the Objects',
        difficulty: 2,
        score: 75,
        accuracy: 75,
        responseTime: 48,
        mistakes: 2,
        timestamp: DateTime.now().subtract(
          const Duration(days: 3),
        ),
      ),

      GamePerformance(
        patientId: 'P001',
        gameName: 'Find the Target',
        difficulty: 2,
        score: 65,
        accuracy: 65,
        responseTime: 55,
        mistakes: 4,
        timestamp: DateTime.now().subtract(
          const Duration(days: 2),
        ),
      ),

      GamePerformance(
        patientId: 'P001',
        gameName: 'Remember the Objects',
        difficulty: 3,
        score: 72,
        accuracy: 72,
        responseTime: 45,
        mistakes: 2,
        timestamp: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      ),
    ]);
  }
}