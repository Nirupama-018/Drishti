import 'package:flutter_test/flutter_test.dart';

import 'package:cognitive_care/ai/adaptation/configuration_generator.dart';

void main() {
  late ConfigurationGenerator generator;

  setUp(() {
    generator = ConfigurationGenerator();
  });

  group('Memory configuration', () {
    test('generates level 1 configuration', () {
      final config = generator.generateMemoryConfig(1);

      expect(config.gameId, 'visual_memory');
      expect(config.difficultyLevel, 1);
      expect(config.objectCount, 3);
      expect(config.distractorCount, 3);
      expect(config.exposureTime, 8);
    });

    test('generates level 2 configuration', () {
      final config = generator.generateMemoryConfig(2);

      expect(config.gameId, 'visual_memory');
      expect(config.difficultyLevel, 2);
      expect(config.objectCount, 5);
      expect(config.distractorCount, 3);
      expect(config.exposureTime, 7);
    });

    test('generates level 3 configuration', () {
      final config = generator.generateMemoryConfig(3);

      expect(config.gameId, 'visual_memory');
      expect(config.difficultyLevel, 3);
      expect(config.objectCount, 7);
      expect(config.distractorCount, 3);
      expect(config.exposureTime, 6);
    });
  });

  group('Attention configuration', () {
    test('generates level 1 configuration', () {
      final config = generator.generateAttentionConfig(1);

      expect(config.gameId, 'visual_attention');
      expect(config.difficultyLevel, 1);
      expect(config.choiceCount, 4);
      expect(config.trialCount, 5);
      expect(config.timeLimit, 10.0);
    });

    test('generates level 2 configuration', () {
      final config = generator.generateAttentionConfig(2);

      expect(config.gameId, 'visual_attention');
      expect(config.difficultyLevel, 2);
      expect(config.choiceCount, 6);
      expect(config.trialCount, 7);
      expect(config.timeLimit, 8.0);
    });

    test('generates level 3 configuration', () {
      final config = generator.generateAttentionConfig(3);

      expect(config.gameId, 'visual_attention');
      expect(config.difficultyLevel, 3);
      expect(config.choiceCount, 8);
      expect(config.trialCount, 10);
      expect(config.timeLimit, 6.0);
    });
  });

  group('Invalid difficulty', () {
    test('defaults memory configuration to level 1', () {
      final config = generator.generateMemoryConfig(99);

      expect(config.difficultyLevel, 1);
      expect(config.objectCount, 3);
      expect(config.distractorCount, 3);
      expect(config.exposureTime, 8);
    });

    test('defaults attention configuration to level 1', () {
      final config = generator.generateAttentionConfig(99);

      expect(config.difficultyLevel, 1);
      expect(config.choiceCount, 4);
      expect(config.trialCount, 5);
      expect(config.timeLimit, 10.0);
    });
  });
}
