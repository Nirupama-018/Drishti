import '../models/cognitive_profile.dart';

class DifficultyAdjuster {
  int adjustDifficulty({
    required CognitiveDomainProfile profile,
    required int currentDifficulty,
  }) {
    // Not enough data yet.
    if (profile.confidence < 0.5) {
      return 1;
    }

    // Strong performance + positive/stable trend.
    if (profile.performance >= 0.80 &&
        profile.trend >= 0.5) {
      return _increaseDifficulty(currentDifficulty);
    }

    // Low performance.
    if (profile.performance < 0.50) {
      return _decreaseDifficulty(currentDifficulty);
    }

    // Otherwise, keep the current difficulty.
    return _clampDifficulty(currentDifficulty);
  }

  int _increaseDifficulty(int difficulty) {
    return _clampDifficulty(difficulty + 1);
  }

  int _decreaseDifficulty(int difficulty) {
    return _clampDifficulty(difficulty - 1);
  }

  int _clampDifficulty(int difficulty) {
    if (difficulty < 1) {
      return 1;
    }

    if (difficulty > 3) {
      return 3;
    }

    return difficulty;
  }
}