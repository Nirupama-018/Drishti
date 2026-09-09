import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../models/game_result.dart';
import '../models/game_recommendation.dart';

import '../screens/patient_home_screen.dart';
import '../screens/activity_selection_screen.dart';
import '../screens/game_instruction_screen.dart';
import '../screens/game_host_screen.dart';
import '../screens/game_result_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/reminder_screen.dart';

class PatientRoutes {
  static const String home = '/patient';
  static const String activities = '/patient/activities';
  static const String instructions = '/patient/instructions';
  static const String game = '/patient/game';
  static const String result = '/patient/result';
  static const String progress = '/patient/progress';
  static const String reminders = '/patient/reminders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // --------------------------------------------------
    // HOME
    // --------------------------------------------------

      case home:
        return MaterialPageRoute(
          builder: (_) => const PatientHomeScreen(),
        );

    // --------------------------------------------------
    // ACTIVITY SELECTION
    // --------------------------------------------------

      case activities:
        return MaterialPageRoute(
          builder: (_) => const ActivitySelectionScreen(),
        );

    // --------------------------------------------------
    // GAME INSTRUCTIONS
    // --------------------------------------------------

      case instructions:
        final recommendation =
        settings.arguments as GameRecommendation;

        return MaterialPageRoute(
          builder: (_) => GameInstructionScreen(
            config: recommendation.config,
          ),
        );

    // --------------------------------------------------
    // GAME HOST
    // --------------------------------------------------

      case game:
        final config = settings.arguments as GameConfig;

        return MaterialPageRoute(
          builder: (_) => GameHostScreen(
            config: config,
          ),
        );

    // --------------------------------------------------
    // GAME RESULT
    // --------------------------------------------------

      case result:
        final result = settings.arguments as GameResult;

        return MaterialPageRoute(
          builder: (_) => GameResultScreen(
            result: result,
          ),
        );

    // --------------------------------------------------
    // PROGRESS
    // --------------------------------------------------

      case progress:
        return MaterialPageRoute(
          builder: (_) => const ProgressScreen(),
        );

    // --------------------------------------------------
    // REMINDERS
    // --------------------------------------------------

      case reminders:
        return MaterialPageRoute(
          builder: (_) => const ReminderScreen(),
        );

    // --------------------------------------------------
    // UNKNOWN ROUTE
    // --------------------------------------------------

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Page not found',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
    }
  }
}