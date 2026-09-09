import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/adaptation/difficulty_adjuster.dart';
import 'package:cognitive_care/ai/models/cognitive_profile.dart';

CognitiveDomainProfile createProfile({
  required double performance,
  required double trend,
  required double confidence,
}) {
  return CognitiveDomainProfile(
    performance: performance,
    trend: trend,
    confidence: confidence,
  );
}

void main() {
  final adjuster = DifficultyAdjuster();

  test('Keeps difficulty at 1 when there is insufficient data', () {
    final profile = createProfile(
      performance: 0.90,
      trend: 1.0,
      confidence: 0.25,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 2,
    );

    expect(difficulty, 1);
  });

  test('Increases difficulty for strong improving performance', () {
    final profile = createProfile(
      performance: 0.85,
      trend: 1.0,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 2,
    );

    expect(difficulty, 3);
  });

  test('Increases difficulty for strong stable performance', () {
    final profile = createProfile(
      performance: 0.85,
      trend: 0.5,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 1,
    );

    expect(difficulty, 2);
  });

  test('Does not increase difficulty when performance is declining', () {
    final profile = createProfile(
      performance: 0.85,
      trend: 0.0,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 2,
    );

    expect(difficulty, 2);
  });

  test('Decreases difficulty for low performance', () {
    final profile = createProfile(
      performance: 0.40,
      trend: 0.5,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 2,
    );

    expect(difficulty, 1);
  });

  test('Keeps difficulty for moderate performance', () {
    final profile = createProfile(
      performance: 0.65,
      trend: 0.5,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 2,
    );

    expect(difficulty, 2);
  });

  test('Does not increase above maximum difficulty', () {
    final profile = createProfile(
      performance: 0.90,
      trend: 1.0,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 3,
    );

    expect(difficulty, 3);
  });

  test('Does not decrease below minimum difficulty', () {
    final profile = createProfile(
      performance: 0.30,
      trend: 0.0,
      confidence: 1.0,
    );

    final difficulty = adjuster.adjustDifficulty(
      profile: profile,
      currentDifficulty: 1,
    );

    expect(difficulty, 1);
  });
}
