import 'package:flutter/material.dart';

import 'games/memory_game/memory_game.dart';
import 'games/memory_game/memory_config.dart';

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
      home: const MemoryGame(
        config: MemoryGameConfig.level1,
      ),
    );
  }
}