import 'package:flutter/material.dart';
import 'performance_chart.dart';
import 'caregiver_service.dart';

class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  final CaregiverService service = CaregiverService.instance;

  final String patientId = 'P001';

  @override
  Widget build(BuildContext context) {
    final sessions = service.getSessions(patientId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Dashboard'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
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
                    '72%',
                    Icons.score,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _summaryCard(
                    'Accuracy',
                    '78%',
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
                    '3',
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
                      0.78,
                    ),

                    const SizedBox(height: 18),

                    _progressRow(
                      'Attention Game',
                      0.65,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Performance Chart
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

            Card(
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
                  'Recent accuracy has decreased compared to previous sessions.',
                ),
              ),
            ),

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
    );
  }

  // Summary card
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

  // Progress bar
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
          value: progress,
          minHeight: 10,
        ),
      ],
    );
  }
}