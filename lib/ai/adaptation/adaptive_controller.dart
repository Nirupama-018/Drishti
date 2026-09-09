import '../history/session_history.dart';
import '../models/adaptation_decision.dart';
import '../models/cognitive_profile.dart';
import '../models/game_result.dart';
import '../analysis/cognitive_profile_builder.dart';
import 'adaptive_engine.dart';

class AdaptiveController {
  final SessionHistory history;
  final CognitiveProfileBuilder profileBuilder;
  final AdaptiveEngine adaptiveEngine;

  AdaptiveController({
    SessionHistory? history,
    CognitiveProfileBuilder? profileBuilder,
    AdaptiveEngine? adaptiveEngine,
  })  : history = history ?? SessionHistory(),
        profileBuilder =
            profileBuilder ?? CognitiveProfileBuilder(),
        adaptiveEngine =
            adaptiveEngine ?? AdaptiveEngine();

  AdaptationDecision processResult(GameResult result) {
    history.addSession(result);

    final CognitiveProfile profile =
    profileBuilder.build(history);

    return adaptiveEngine.generateNextDecision(
      profile: profile,
      history: history,
    );
  }

  CognitiveProfile get currentProfile {
    return profileBuilder.build(history);
  }
}