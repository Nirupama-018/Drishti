class LocalizedGameContent {
  static const Map<String, Map<String, String>> objectNames = {
    'apple': {
      'en': 'Apple',
      'as': 'আপেল',
      'ml': 'ആപ്പിൾ',
    },
    'cup': {
      'en': 'Cup',
      'as': 'കাপ',
      'ml': 'കപ്പ്',
    },
    'key': {
      'en': 'Key',
      'as': 'চাবি',
      'ml': 'താക്കോൽ',
    },
    'book': {
      'en': 'Book',
      'as': 'কিতাপ',
      'ml': 'പുസ്തകം',
    },
    'flower': {
      'en': 'Flower',
      'as': 'ফুল',
      'ml': 'പൂവ്',
    },
    'bottle': {
      'en': 'Bottle',
      'as': 'বটল',
      'ml': 'കുപ്പി',
    },
    'spoon': {
      'en': 'Spoon',
      'as': 'চামুচ',
      'ml': 'സ്പൂൺ',
    },
    'banana': {
      'en': 'Banana',
      'as': 'কল',
      'ml': 'വാഴപ്പഴം',
    },
    'umbrella': {
      'en': 'Umbrella',
      'as': 'ছাতি',
      'ml': 'കുട',
    },
    'candle': {
      'en': 'Candle',
      'as': 'মমবাতি',
      'ml': 'മെഴുകുതിരി',
    },
  };

  static String getObjectName(
      String objectId,
      String languageCode,
      ) {
    return objectNames[objectId]?[languageCode] ??
        objectNames[objectId]?['en'] ??
        objectId;
  }
}