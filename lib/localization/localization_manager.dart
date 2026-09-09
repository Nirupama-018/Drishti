import 'localization_data.dart';

class LocalizationManager {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setLanguage(String languageCode) {
    if (LocalizationData.translations.containsKey(languageCode)) {
      _currentLanguage = languageCode;
    }
  }

  String translate(String key) {
    return LocalizationData.translations[_currentLanguage]?[key] ??
        LocalizationData.translations['en']?[key] ??
        key;
  }

  bool get isAssamese => _currentLanguage == 'as';

  bool get isEnglish => _currentLanguage == 'en';
}