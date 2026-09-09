import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../navigation/patient_routes.dart';
import '../widgets/instruction_card.dart';
import '../widgets/patient_app_bar.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/voice_button.dart';

class GameInstructionScreen extends StatelessWidget {
  final GameConfig config;

  const GameInstructionScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final isMemory = config.isMemoryGame;

    final title = isMemory ? 'Remember the Objects' : 'Find the Target';

    final description = isMemory
        ? 'Look carefully at the objects and remember what you see.'
        : 'Look at the target and find the matching object.';

    return Scaffold(
      appBar: PatientAppBar(title: title),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Icon(isMemory ? Icons.psychology : Icons.visibility, size: 80),

              const SizedBox(height: 20),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 19, height: 1.5),
              ),

              const SizedBox(height: 28),

              if (isMemory) ...[
                const InstructionCard(
                  title: 'Look carefully',
                  description: 'Remember the objects shown on the screen.',
                  icon: Icons.visibility,
                ),

                const SizedBox(height: 12),

                const InstructionCard(
                  title: 'Choose the objects you remember',
                  description: 'Tap the objects you saw earlier.',
                  icon: Icons.touch_app,
                ),
              ] else ...[
                const InstructionCard(
                  title: 'Look at the target',
                  description: 'A target object will appear on the screen.',
                  icon: Icons.search,
                ),

                const SizedBox(height: 12),

                const InstructionCard(
                  title: 'Find the match',
                  description: 'Tap the matching object from the choices.',
                  icon: Icons.touch_app,
                ),
              ],

              const SizedBox(height: 20),

              VoiceButton(
                text: 'Hear Instructions',
                onPressed: () {
                  // M5 connects TTS here.
                },
              ),

              const SizedBox(height: 24),

              PrimaryActionButton(
                label: 'Start Activity',
                icon: Icons.play_arrow,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    PatientRoutes.game,
                    arguments: config,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
