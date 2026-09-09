import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../navigation/patient_routes.dart';
import '../widgets/patient_app_bar.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/result_card.dart';
import '../widgets/secondary_action_button.dart';

class GameResultScreen extends StatelessWidget {
  final GameResult result;

  const GameResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PatientAppBar(title: 'Activity Complete'),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Icon(
                result.completed
                    ? Icons.celebration
                    : Icons.pause_circle_outline,
                size: 80,
              ),

              const SizedBox(height: 18),

              Text(
                result.completed ? 'Well done!' : 'Activity stopped',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                result.completed
                    ? 'You completed today\'s activity.'
                    : 'You can try again whenever you are ready.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),

              const SizedBox(height: 28),

              if (result.completed) ...[
                Row(
                  children: [
                    Expanded(
                      child: ResultCard(
                        title: 'Accuracy',
                        value: '${result.percentage}%',
                        icon: Icons.check_circle_outline,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ResultCard(
                        title: 'Correct',
                        value: '${result.correct}',
                        icon: Icons.star_outline,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ResultCard(
                  title: 'Activity',
                  value: result.gameName,
                  icon: result.gameId == 'visual_memory'
                      ? Icons.psychology
                      : Icons.visibility,
                ),
              ],

              const SizedBox(height: 30),

              PrimaryActionButton(
                label: 'Back to Home',
                icon: Icons.home,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PatientRoutes.home,
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 12),

              SecondaryActionButton(
                label: 'Choose Another Activity',
                icon: Icons.grid_view,
                onPressed: () {
                  Navigator.pushNamed(context, PatientRoutes.activities);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
