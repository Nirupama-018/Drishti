import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../navigation/patient_routes.dart';
import '../widgets/activity_card.dart';
import '../widgets/patient_app_bar.dart';

class ActivitySelectionScreen extends StatelessWidget {
  const ActivitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PatientAppBar(title: 'Choose an Activity'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an activity to begin.',
                style: TextStyle(fontSize: 19),
              ),

              const SizedBox(height: 24),

              ActivityCard(
                title: 'Remember the Objects',
                description: 'Look carefully and remember the objects you see.',
                icon: Icons.psychology,
                config: GameConfig.memoryLevel1(),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PatientRoutes.instructions,
                    arguments: GameConfig.memoryLevel1(),
                  );
                },
              ),

              const SizedBox(height: 16),

              ActivityCard(
                title: 'Find the Target',
                description: 'Find the matching object from the choices.',
                icon: Icons.visibility,
                config: GameConfig.attentionLevel1(),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PatientRoutes.instructions,
                    arguments: GameConfig.attentionLevel1(),
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
