import '../adaptation/adaptive_engine.dart';
import '../history/session_history.dart';
import '../models/adaptation_decision.dart';
import '../models/cognitive_profile.dart';

class AdaptiveGameService {
  final AdaptiveEngine adaptiveEngine;

  AdaptiveGameService({
    AdaptiveEngine? adaptiveEngine,
  }) : adaptiveEngine = adaptiveEngine ?? AdaptiveEngine();

  AdaptationDecision getNextGame({
    required CognitiveProfile profile,
    required SessionHistory history,
  }) {
    return adaptiveEngine.generateNextDecision(
      profile: profile,
      history: history,
    );
  }
}