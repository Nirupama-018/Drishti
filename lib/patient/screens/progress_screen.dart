import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Here is how you are doing with your activities.',
                style: TextStyle(fontSize: 18, height: 1.4),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // ACTIVITIES COMPLETED
              // --------------------------------------------------
              _buildProgressCard(
                icon: Icons.check_circle_outline,
                title: 'Activities completed',
                value: '5',
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // AVERAGE ACCURACY
              // --------------------------------------------------
              _buildProgressCard(
                icon: Icons.star_outline,
                title: 'Average accuracy',
                value: '82%',
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // ENCOURAGEMENT
              // --------------------------------------------------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events_outlined, size: 48),

                      const SizedBox(height: 14),

                      const Text(
                        'Keep going!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Regular practice is more important '
                        'than getting everything right.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // BACK BUTTON
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 42),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
