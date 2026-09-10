import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Central service for all text-to-speech and speech-to-text
/// functionality for languages supported by the device's installed
/// TTS/STT engines (English, Malayalam, etc.).
///
/// Games and patient UI should use this service instead of
/// interacting directly with the FlutterTts / SpeechToText plugins.
///
/// NOTE: Assamese is not reliably supported by device TTS/STT engines
/// and goes through a separate AssameseVoiceService (Bhashini API)
/// instead.
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();

  bool _sttInitialized = false;

  // ---------------------------------------------------------------------
  // Text-to-Speech
  // ---------------------------------------------------------------------

  /// Speaks the supplied text using the requested language.
  Future<void> speak(
    String text, {
    String languageCode = 'en-US',
  }) async {
    if (text.trim().isEmpty) {
      return;
    }

    await setLanguage(languageCode);
    await _tts.speak(text);
  }

  /// Stops the current speech.
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Pauses the current speech if supported by the platform.
  Future<void> pause() async {
    await _tts.pause();
  }

  /// Sets the TTS language/locale.
  Future<void> setLanguage(String languageCode) async {
    await _tts.setLanguage(languageCode);
  }

  /// Sets the speech rate.
  ///
  /// Lower values are generally easier for elderly users
  /// to understand.
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Sets the speech volume.
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }

  /// Sets the speech pitch.
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  /// Returns the list of language codes actually installed/available
  /// on this device's TTS engine (e.g. ['en-US', 'ml-IN', ...]).
  ///
  /// Useful for debugging "nothing happens" issues: if a language
  /// code isn't in this list, the device has no voice for it, and
  /// speak() will silently fail for that language.
  Future<List<String>> getAvailableLanguages() async {
    final languages = await _tts.getLanguages;
    return List<String>.from(languages ?? []);
  }

  /// Checks whether a specific language code is available on-device.
  Future<bool> isLanguageAvailable(String languageCode) async {
    final available = await getAvailableLanguages();
    return available.any(
      (lang) => lang.toLowerCase() == languageCode.toLowerCase(),
    );
  }

  // ---------------------------------------------------------------------
  // Speech-to-Text
  // ---------------------------------------------------------------------

  /// Initializes the speech recognizer. Must succeed before [listen]
  /// is called. Safe to call multiple times.
  Future<bool> initSpeech() async {
    if (_sttInitialized) return true;

    _sttInitialized = await _stt.initialize(
      onError: (error) {
        // ignore: avoid_print
        print('Speech recognition error: $error');
      },
      onStatus: (status) {
        // ignore: avoid_print
        print('Speech recognition status: $status');
      },
    );

    return _sttInitialized;
  }

  /// Listens for speech and returns the recognized text.
  ///
  /// Returns an empty string if initialization fails or nothing
  /// was recognized within [listenFor].
  Future<String> listen({
    String localeId = 'en_IN',
    Duration listenFor = const Duration(seconds: 5),
  }) async {
    final ready = await initSpeech();
    if (!ready) {
      return '';
    }

    String recognizedText = '';

    await _stt.listen(
      localeId: localeId,
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
    );

    await Future.delayed(listenFor);
    await _stt.stop();

    return recognizedText;
  }

  /// Returns the list of locale IDs available for speech recognition
  /// on this device (e.g. ['en_IN', 'en_US', ...]).
  Future<List<String>> getAvailableSttLocales() async {
    final ready = await initSpeech();
    if (!ready) return [];

    final locales = await _stt.locales();
    return locales.map((l) => l.localeId).toList();
  }

  /// Stops listening early, if currently listening.
  Future<void> stopListening() async {
    if (_stt.isListening) {
      await _stt.stop();
    }
  }

  /// Whether the recognizer is currently listening.
  bool get isListening => _stt.isListening;

  // ---------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------

  /// Releases the TTS/STT engines when the service is no longer needed.
  Future<void> dispose() async {
    await _tts.stop();
    await _stt.stop();
  }
}