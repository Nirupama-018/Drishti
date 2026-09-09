
import 'package:flutter/material.dart';
import 'performance_chart.dart';
import 'caregiver_service.dart';
import '../core/models/game_performance.dart';

class CaregiverDashboard extends StatefulWidget {
const CaregiverDashboard({super.key});

@override
State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
final CaregiverService service = CaregiverService.instance;

final String patientId = 'P001';

bool _loading = true;

@override
void initState() {
super.initState();
_loadSessions();
}

Future<void> _loadSessions() async {
await service.loadSessions();

if (mounted) {
setState(() {
_loading = false;
});
}
}

@override
Widget build(BuildContext context) {
if (_loading) {
return const Scaffold(
body: Center(
child: CircularProgressIndicator(),
),
);
}

final sessions = service.getSessions(patientId);

final averageScore = _averageScore(sessions);
final averageAccuracy = _averageAccuracy(sessions);

final currentLevel = sessions.isEmpty
? 1
    : sessions.last.difficulty;

final memoryProgress = _gameProgress(
sessions,
'Remember the Objects',
);

final attentionProgress = _gameProgress(
sessions,
'Find the Target',
);

return Scaffold(
appBar: AppBar(
title: const Text('Caregiver Dashboard'),
centerTitle: true,
),

body: RefreshIndicator(
onRefresh: _loadSessions,
child: SingleChildScrollView(
physics: const AlwaysScrollableScrollPhysics(),
padding: const EdgeInsets.all(20),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Patient Overview
const Text(
'Patient Overview',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

Card(
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.person),
),
title: const Text(
'Patient ID: P001',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: const Text('Age: 72'),
),
),

const SizedBox(height: 25),

// Cognitive Performance
const Text(
'Cognitive Performance',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

Row(
children: [
Expanded(
child: _summaryCard(
'Average Score',
'${averageScore.round()}%',
Icons.score,
),
),

const SizedBox(width: 12),

Expanded(
child: _summaryCard(
'Accuracy',
'${averageAccuracy.round()}%',
Icons.check_circle,
),
),
],
),

const SizedBox(height: 12),

Row(
children: [
Expanded(
child: _summaryCard(
'Games Played',
'${sessions.length}',
Icons.games,
),
),

const SizedBox(width: 12),

Expanded(
child: _summaryCard(
'Current Level',
'$currentLevel',
Icons.trending_up,
),
),
],
),

const SizedBox(height: 25),

// Recent Progress
const Text(
'Recent Progress',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

Card(
child: Padding(
padding: const EdgeInsets.all(20),

child: Column(
children: [
_progressRow(
'Memory Game',
memoryProgress,
),

const SizedBox(height: 18),

_progressRow(
'Attention Game',
attentionProgress,
),
],
),
),
),

const SizedBox(height: 25),

const PerformanceChart(),

const SizedBox(height: 25),

// Monitoring Alert
const Text(
'Monitoring Alert',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

_buildAlert(sessions),

const SizedBox(height: 20),

// Session information
Card(
child: ListTile(
leading: const Icon(Icons.history),

title: const Text(
'Recent Sessions',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),

subtitle: Text(
'${sessions.length} game sessions recorded',
),
),
),
],
),
),
),
);
}

double _averageScore(List<GamePerformance> sessions) {
if (sessions.isEmpty) {
return 0;
}

final total = sessions.fold<double>(
0,
(sum, session) => sum + session.score,
);

return total / sessions.length;
}

double _averageAccuracy(List<GamePerformance> sessions) {
if (sessions.isEmpty) {
return 0;
}

final total = sessions.fold<double>(
0,
(sum, session) => sum + session.accuracy,
);

return total / sessions.length;
}

double _gameProgress(
List<GamePerformance> sessions,
String gameName,
) {
final gameSessions = sessions
    .where((session) => session.gameName == gameName)
    .toList();

if (gameSessions.isEmpty) {
return 0;
}

final total = gameSessions.fold<double>(
0,
(sum, session) => sum + session.accuracy,
);

return (total / gameSessions.length) / 100;
}

Widget _buildAlert(List<GamePerformance> sessions) {
if (sessions.length < 2) {
return const Card(
child: ListTile(
leading: Icon(Icons.info_outline),
title: Text(
'Not enough data yet',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
'More game sessions are needed to identify performance changes.',
),
),
);
}

final previous = sessions[sessions.length - 2];
final latest = sessions.last;

final decreased = latest.accuracy < previous.accuracy - 10;

if (decreased) {
return Card(
color: Colors.orange.shade50,
child: const ListTile(
leading: Icon(
Icons.warning_amber,
color: Colors.orange,
),
title: Text(
'Performance needs attention',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
'Recent accuracy has decreased compared to the previous session.',
),
),
);
}

return const Card(
child: ListTile(
leading: Icon(
Icons.check_circle_outline,
),
title: Text(
'Performance is stable',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
'No significant decrease was detected in recent performance.',
),
),
);
}

static Widget _summaryCard(
String title,
String value,
IconData icon,
) {
return Card(
child: Padding(
padding: const EdgeInsets.all(16),

child: Column(
children: [
Icon(
icon,
size: 30,
),

const SizedBox(height: 8),

Text(
value,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 5),

Text(
title,
textAlign: TextAlign.center,
),
],
),
),
);
}

static Widget _progressRow(
String game,
double progress,
) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(game),

Text(
'${(progress * 100).round()}%',
),
],
),

const SizedBox(height: 8),

LinearProgressIndicator(
value: progress.clamp(0.0, 1.0),
minHeight: 10,
),
],
);
}
}
