import 'package:flutter/material.dart';

import 'games/attention_game/attention_game.dart';
import 'games/attention_game/attention_config.dart';

void main() {
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
      home: const AttentionGame(
        config: AttentionGameConfig.level1,
      ),
    );
  }
}