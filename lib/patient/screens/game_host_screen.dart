import 'package:flutter/material.dart';

import '../../caregiver/caregiver_service.dart';
import '../../core/models/game_result_adapter.dart';

import '../../games/memory_game/memory_game.dart';
import '../../games/memory_game/memory_config.dart';

import '../../games/attention_game/attention_game.dart';
import '../../games/attention_game/attention_config.dart';

import '../models/game_config.dart';
import '../models/game_result.dart';
import '../services/patient_session_service.dart';
import '../navigation/patient_routes.dart';

class GameHostScreen extends StatelessWidget {
  final GameConfig config;

  const GameHostScreen({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (config.isMemoryGame) {
      return _buildMemoryGame(context);
    }

    if (config.isAttentionGame) {
      return _buildAttentionGame(context);
    }

    return const Scaffold(
      body: Center(
        child: Text(
          'Unknown game',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // MEMORY GAME
  // --------------------------------------------------

  Widget _buildMemoryGame(BuildContext context) {
    final memoryConfig = _getMemoryConfig();

    return MemoryGame(
      config: memoryConfig,
      onGameComplete: (result) async {
        // 1. Convert to patient result model
        final gameResult =
        GameResult.fromMemoryResult(result);

        // 2. Save for patient progress
        await PatientSessionService()
            .saveGameResult(gameResult);

        // 3. Save for caregiver dashboard
        final caregiverSession =
        GameResultAdapter.fromMemoryResult(
          result,
          'P001',
        );

        if (caregiverSession != null) {
          await CaregiverService.instance.addSession(
            caregiverSession,
          );
        }

        // 4. Continue patient flow
        if (!context.mounted) return;

        Navigator.pushReplacementNamed(
          context,
          PatientRoutes.result,
          arguments: gameResult,
        );
      },
    );
  }

  // --------------------------------------------------
  // ATTENTION GAME
  // --------------------------------------------------

  Widget _buildAttentionGame(BuildContext context) {
    final attentionConfig = _getAttentionConfig();

    return AttentionGame(
      config: attentionConfig,
      onGameComplete: (result) async {
        // 1. Convert to patient result model
        final gameResult =
        GameResult.fromAttentionResult(result);

        // 2. Save for patient progress
        await PatientSessionService()
            .saveGameResult(gameResult);

        // 3. Save for caregiver dashboard
        final caregiverSession =
        GameResultAdapter.fromAttentionResult(
          result,
          'P001',
        );

        if (caregiverSession != null) {
          await CaregiverService.instance.addSession(
            caregiverSession,
          );
        }

        // 4. Continue patient flow
        if (!context.mounted) return;

        Navigator.pushReplacementNamed(
          context,
          PatientRoutes.result,
          arguments: gameResult,
        );
      },
    );
  }

  // --------------------------------------------------
  // MEMORY CONFIG
  // --------------------------------------------------

  MemoryGameConfig _getMemoryConfig() {
    switch (config.difficultyLevel) {
      case 2:
        return MemoryGameConfig.level2;

      case 3:
        return MemoryGameConfig.level3;

      case 1:
      default:
        return MemoryGameConfig.level1;
    }
  }

  // --------------------------------------------------
  // ATTENTION CONFIG
  // --------------------------------------------------

  AttentionGameConfig _getAttentionConfig() {
    switch (config.difficultyLevel) {
      case 2:
        return AttentionGameConfig.level2;

      case 3:
        return AttentionGameConfig.level3;

      case 1:
      default:
        return AttentionGameConfig.level1;
    }
  }
}