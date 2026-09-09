import 'game_config.dart';

class GameRecommendation {
  final String gameId;
  final String title;
  final String description;
  final GameConfig config;

  const GameRecommendation({
    required this.gameId,
    required this.title,
    required this.description,
    required this.config,
  });
}
