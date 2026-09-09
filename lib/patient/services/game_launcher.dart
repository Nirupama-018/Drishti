import '../models/game_config.dart';

class GameLauncher {
  static bool canLaunch(GameConfig config) {
    return config.gameId == 'visual_memory' ||
        config.gameId == 'visual_attention';
  }
}
