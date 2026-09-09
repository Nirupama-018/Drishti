import '../models/game_config.dart';
import '../models/game_recommendation.dart';

class RecommendationService {
  Future<GameRecommendation> getRecommendation() async {
    return GameRecommendation(
      gameId: 'visual_memory',
      title: 'Remember the Objects',
      description: 'Look carefully and remember the objects you see.',
      config: GameConfig.memoryLevel1(),
    );
  }
}
