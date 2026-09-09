class MemoryObject {
  final String id;
  final String name;
  final String visual;

  const MemoryObject({
    required this.id,
    required this.name,
    required this.visual,
  });
}

class MemoryContent {
  static const objects = [
    MemoryObject(
      id: 'apple',
      name: 'Apple',
      visual: '🍎',
    ),
    MemoryObject(
      id: 'cup',
      name: 'Cup',
      visual: '☕',
    ),
    MemoryObject(
      id: 'key',
      name: 'Key',
      visual: '🔑',
    ),
    MemoryObject(
      id: 'book',
      name: 'Book',
      visual: '📖',
    ),
    MemoryObject(
      id: 'flower',
      name: 'Flower',
      visual: '🌸',
    ),
    MemoryObject(
      id: 'bottle',
      name: 'Bottle',
      visual: '🍼',
    ),
    MemoryObject(
      id: 'spoon',
      name: 'Spoon',
      visual: '🥄',
    ),
    MemoryObject(
      id: 'banana',
      name: 'Banana',
      visual: '🍌',
    ),
    MemoryObject(
      id: 'umbrella',
      name: 'Umbrella',
      visual: '☂️',
    ),
    MemoryObject(
      id: 'candle',
      name: 'Candle',
      visual: '🕯️',
    ),
  ];
}