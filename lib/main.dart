import 'package:flutter/material.dart';

// Localization
import 'localization/localization_manager.dart';

// Attention Game
import 'games/attention_game/attention_game.dart';
import 'games/attention_game/attention_config.dart';
import 'voice/voice_test_screen.dart';
import 'games/attention_game/attention_result.dart';

// Memory Game
import 'games/memory_game/memory_game.dart';
import 'games/memory_game/memory_config.dart';
import 'games/memory_game/memory_result.dart';

// Caregiver & Performance
import 'core/models/game_result_adapter.dart';
import 'caregiver/caregiver_service.dart';
import 'caregiver/caregiver_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load previously saved game sessions
  await CaregiverService.instance.loadSessions();

  runApp(const CognitiveCareApp());
}

class CognitiveCareApp extends StatelessWidget {
  const CognitiveCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cognitive Care',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LanguageSelectionScreen(),
    );
  }
}

// ============================================================
// LANGUAGE SELECTION
// ============================================================

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {
  final LocalizationManager _localization =
  LocalizationManager();

  void _selectLanguage(String languageCode) {
    _localization.setLanguage(languageCode);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IntegrationTestScreen(
          localization: _localization,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cognitive Care'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.language,
                size: 80,
              ),

              const SizedBox(height: 30),

              const Text(
                'Choose Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // English
              SizedBox(
                width: 280,
                height: 64,
                child: FilledButton(
                  onPressed: () => _selectLanguage('en'),
                  child: const Text(
                    'English',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Assamese
              SizedBox(
                width: 280,
                height: 64,
                child: FilledButton(
                  onPressed: () => _selectLanguage('as'),
                  child: const Text(
                    'অসমীয়া',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Malayalam
              SizedBox(
                width: 280,
                height: 64,
                child: FilledButton(
                  onPressed: () => _selectLanguage('ml'),
                  child: const Text(
                    'മലയാളം',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INTEGRATION TEST SCREEN
// ============================================================

class IntegrationTestScreen extends StatelessWidget {
  final LocalizationManager localization;

  const IntegrationTestScreen({
    super.key,
    required this.localization,
  });

  // Start Attention Game
  void _startAttentionGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttentionGame(
          config: AttentionGameConfig.level1,
          localization: localization,
          onGameComplete: (AttentionGameResult result) async {
            final performance =
            GameResultAdapter.fromAttentionResult(
              result,
              'P001',
            );

            if (performance != null) {
              await CaregiverService.instance.addSession(
                performance,
              );
            }
          },
        ),
      ),
    );
  }

  // Start Memory Game
  void _startMemoryGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryGame(
          config: MemoryGameConfig.level1,
          localization: localization,
          onGameComplete: (MemoryGameResult result) async {
            final performance =
            GameResultAdapter.fromMemoryResult(
              result,
              'P001',
            );

            if (performance != null) {
              await CaregiverService.instance.addSession(
                performance,
              );
            }
          },
        ),
      ),
    );
  }

  // Open Caregiver Dashboard
  void _openCaregiverDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CaregiverDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cognitive Care'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Integration Test',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Language: ${localization.currentLanguage}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 35),

              // Attention Game
              SizedBox(
                width: 280,
                child: ElevatedButton(
                  onPressed: () =>
                      _startAttentionGame(context),
                  child: const Text(
                    'Start Attention Game',
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Memory Game
              SizedBox(
                width: 280,
                child: ElevatedButton(
                  onPressed: () =>
                      _startMemoryGame(context),
                  child: const Text(
                    'Start Memory Game',
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Caregiver Dashboard
              SizedBox(
                width: 280,
                child: OutlinedButton(
                  onPressed: () =>
                      _openCaregiverDashboard(context),
                  child: const Text(
                    'Open Caregiver Dashboard',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}