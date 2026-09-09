import 'package:flutter/material.dart';

import '../../games/attention_game/attention_config.dart';
import '../../games/attention_game/attention_game.dart';
import '../../games/memory_game/memory_config.dart';
import '../../games/memory_game/memory_game.dart';

import '../models/game_config.dart';
import '../models/game_result.dart';
import '../navigation/patient_routes.dart';
import '../services/patient_session_service.dart';

class GameHostScreen extends StatelessWidget {
  final GameConfig config;

  const GameHostScreen({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (config.isMemoryGame) {
      final memoryConfig = MemoryGameConfig(
        gameId: config.gameId,
        difficultyLevel: config.difficultyLevel,
        objectCount: config.objectCount ?? 3,
        distractorCount: config.distractorCount ?? 3,
        exposureTime: config.exposureTime ?? 8,
      );

      return MemoryGame(
        config: memoryConfig,
        onGameComplete: (result) async {
          final gameResult =
          GameResult.fromMemoryResult(result);

          await PatientSessionService().saveGameResult(gameResult);

          if (!context.mounted) return;

          Navigator.pushReplacementNamed(
            context,
            PatientRoutes.result,
            arguments: gameResult,
          );
        },
      );
    }

    if (config.isAttentionGame) {
      final attentionConfig = AttentionGameConfig(
        gameId: config.gameId,
        difficultyLevel: config.difficultyLevel,
        choiceCount: config.choiceCount ?? 4,
        trialCount: config.trialCount ?? 5,
        timeLimit: config.timeLimit ?? 10.0,
      );

      return AttentionGame(
        config: attentionConfig,
        onGameComplete: (result) async {
          final gameResult =
          GameResult.fromAttentionResult(result);

          await PatientSessionService().saveGameResult(gameResult);

          if (!context.mounted) return;

          Navigator.pushReplacementNamed(
            context,
            PatientRoutes.result,
            arguments: gameResult,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: const Center(
        child: Text(
          'Unknown game configuration.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}