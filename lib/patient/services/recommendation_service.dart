import '../../ai/analysis/cognitive_profile_builder.dart';
import '../../ai/history/session_history.dart';
import '../../ai/integration/adaptive_game_service.dart';
import '../../ai/models/adaptation_decision.dart';
import '../models/game_config.dart';
import '../models/game_recommendation.dart';

class RecommendationService {
  final AdaptiveGameService _adaptiveGameService;
  final CognitiveProfileBuilder _profileBuilder;
  final SessionHistory _history;

  RecommendationService({
    AdaptiveGameService? adaptiveGameService,
    CognitiveProfileBuilder? profileBuilder,
    SessionHistory? history,
  })  : _adaptiveGameService =
      adaptiveGameService ?? AdaptiveGameService(),
        _profileBuilder =
            profileBuilder ?? CognitiveProfileBuilder(),
        _history =
            history ?? SessionHistory();

  GameRecommendation getRecommendation() {
    final profile = _profileBuilder.build(_history);

    final decision = _adaptiveGameService.getNextGame(
      profile: profile,
      history: _history,
    );

    return _convertDecisionToRecommendation(decision);
  }

  GameRecommendation _convertDecisionToRecommendation(
      AdaptationDecision decision,
      ) {
    if (decision.memoryConfig != null) {
      final config = decision.memoryConfig!;

      return GameRecommendation(
        gameId: config.gameId,
        title: 'Remember the Objects',
        description:
        'Look carefully and remember the objects you see.',
        config: GameConfig(
          gameId: config.gameId,
          difficultyLevel: config.difficultyLevel,
          objectCount: config.objectCount,
          distractorCount: config.distractorCount,
          exposureTime: config.exposureTime,
        ),
      );
    }

    if (decision.attentionConfig != null) {
      final config = decision.attentionConfig!;

      return GameRecommendation(
        gameId: config.gameId,
        title: 'Find the Target',
        description:
        'Find the correct target among the objects.',
        config: GameConfig(
          gameId: config.gameId,
          difficultyLevel: config.difficultyLevel,
          choiceCount: config.choiceCount,
          trialCount: config.trialCount,
          timeLimit: config.timeLimit,
        ),
      );
    }

    throw StateError(
      'No game configuration was provided by the adaptive engine.',
    );
  }
}