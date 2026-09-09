class AppLocalizations {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'welcome': 'Welcome',
      'remember_objects': 'Remember these objects.',
      'well_done': 'Well done!',
      'try_again': 'Try again.',
    },

    'hi': {
      'welcome': 'स्वागत है',
      'remember_objects': 'इन वस्तुओं को याद रखें।',
      'well_done': 'बहुत अच्छा!',
      'try_again': 'फिर से प्रयास करें।',
    },
  };

  static String get(String key, {String language = 'en'}) {
    return _translations[language]?[key] ??
        _translations['en']?[key] ??
        key;
  }
}