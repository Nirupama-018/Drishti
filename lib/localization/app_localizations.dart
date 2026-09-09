import 'localization_manager.dart';

class AppLocalizations {
  final LocalizationManager manager;

  const AppLocalizations(this.manager);

  String get currentLanguage => manager.currentLanguage;

  String translate(String key) {
    return manager.translate(key);
  }

  // Common
  String get start => manager.translate('common.start');

  String get continueText =>
      manager.translate('common.continue');

  String get done => manager.translate('common.done');

  String get next => manager.translate('common.next');

  String get exit => manager.translate('common.exit');

  String get tryAgain =>
      manager.translate('common.try_again');

  // Language selection
  String get languageTitle =>
      manager.translate('language.title');

  String get english =>
      manager.translate('language.english');

  String get assamese =>
      manager.translate('language.assamese');

  String get malayalam =>
      manager.translate('language.malayalam');

  // Remember the Objects
  String get memoryTitle =>
      manager.translate('memory.title');

  String get memoryInstruction =>
      manager.translate('memory.instruction');

  String get memoryStudy =>
      manager.translate('memory.study');

  String get memorySelectInstruction =>
      manager.translate('memory.select_instruction');

  String get memoryResult =>
      manager.translate('memory.result');

  String get memoryCorrect =>
      manager.translate('memory.correct');

  String get memoryIncorrect =>
      manager.translate('memory.incorrect');

  String get memoryMissed =>
      manager.translate('memory.missed');

  // Find the Target
  String get attentionTitle =>
      manager.translate('attention.title');

  String get attentionInstruction =>
      manager.translate('attention.instruction');

  String get attentionResult =>
      manager.translate('attention.result');

  String get attentionCorrect =>
      manager.translate('attention.correct');

  String get attentionIncorrect =>
      manager.translate('attention.incorrect');

  String get attentionMissed =>
      manager.translate('attention.missed');

  // General game messages
  String get wellDone =>
      manager.translate('game.well_done');

  String get roundComplete =>
      manager.translate('game.round_complete');

  String get sessionComplete =>
      manager.translate('game.session_complete');

  String get timeUp =>
      manager.translate('game.time_up');

  String get memoryRound => manager.translate('memory.round');

  String memoryObjectsSeconds(int objects, int seconds) {
    return manager
        .translate('memory.objects_seconds')
        .replaceAll('{objects}', objects.toString())
        .replaceAll('{seconds}', seconds.toString());
  }

  String memoryResponseTime(double seconds) {
    return manager
        .translate('memory.response_time')
        .replaceAll('{seconds}', seconds.toStringAsFixed(1));
  }
}