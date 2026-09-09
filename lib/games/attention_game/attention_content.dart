class AttentionObject {
  final String id;
  final String name;
  final String visual;

  const AttentionObject({
    required this.id,
    required this.name,
    required this.visual,
  });
}

class AttentionContent {
  static const objects = [
    AttentionObject(
      id: 'apple',
      name: 'Apple',
      visual: '🍎',
    ),
    AttentionObject(
      id: 'banana',
      name: 'Banana',
      visual: '🍌',
    ),
    AttentionObject(
      id: 'flower',
      name: 'Flower',
      visual: '🌸',
    ),
    AttentionObject(
      id: 'cup',
      name: 'Cup',
      visual: '☕',
    ),
    AttentionObject(
      id: 'key',
      name: 'Key',
      visual: '🔑',
    ),
    AttentionObject(
      id: 'book',
      name: 'Book',
      visual: '📖',
    ),
    AttentionObject(
      id: 'spoon',
      name: 'Spoon',
      visual: '🥄',
    ),
    AttentionObject(
      id: 'bottle',
      name: 'Bottle',
      visual: '🍼',
    ),
    AttentionObject(
      id: 'umbrella',
      name: 'Umbrella',
      visual: '☂️',
    ),
    AttentionObject(
      id: 'candle',
      name: 'Candle',
      visual: '🕯️',
    ),
  ];
}