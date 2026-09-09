import 'package:flutter/material.dart';

import 'voice_service.dart';

/// Temporary development screen for testing VoiceService.
///
/// This screen is only for validating English, Malayalam, and Assamese
/// text-to-speech, plus English speech-to-text.
/// It can later be removed or replaced by the actual patient UI.
class VoiceTestScreen extends StatefulWidget {
  const VoiceTestScreen({super.key});

  @override
  State<VoiceTestScreen> createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> {
  final VoiceService _voiceService = VoiceService();

  bool _isSpeaking = false;
  bool _isListening = false;
  bool _isChecking = false;
  String _status = 'Ready to test voice';
  String _recognizedText = '';

  Future<void> _speakEnglish() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Speaking English...';
    });

    try {
      await _voiceService.setSpeechRate(0.4);

      await _voiceService.speak(
        'Hello. Welcome to Cognitive Care.',
        languageCode: 'en-US',
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = 'English voice error: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  Future<void> _speakMalayalam() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Speaking Malayalam...';
    });

    try {
      await _voiceService.setSpeechRate(0.4);

      final available = await _voiceService.isLanguageAvailable('ml-IN');
      if (!available) {
        if (mounted) {
          setState(() {
            _status =
                'ml-IN not installed on this device. Tap "Check Available Languages" to see what is installed, or install the Malayalam voice pack in device Settings > Language > Text-to-speech.';
          });
        }
        return;
      }

      await _voiceService.speak(
        'നമസ്കാരം. കോഗ്നിറ്റീവ് കെയറിലേക്ക് സ്വാഗതം.',
        languageCode: 'ml-IN',
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = 'Malayalam voice error: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  Future<void> _speakAssamese() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Speaking Assamese...';
    });

    try {
      await _voiceService.setSpeechRate(0.4);

      await _voiceService.speak(
        'নমস্কাৰ। কগনিটিভ কেয়াৰলৈ আপোনাক স্বাগতম।',
        languageCode: 'as-IN',
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = 'Assamese voice error: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  Future<void> _listenEnglish() async {
    setState(() {
      _isListening = true;
      _status = 'Listening... say something';
      _recognizedText = '';
    });

    try {
      final result = await _voiceService.listen(localeId: 'en_IN');
      if (mounted) {
        setState(() {
          _recognizedText = result.isEmpty ? '(nothing recognized)' : result;
          _status = 'Done listening';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = 'Listening error: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  Future<void> _checkAvailableLanguages() async {
    setState(() {
      _isChecking = true;
      _status = 'Checking installed languages...';
    });

    try {
      final ttsLanguages = await _voiceService.getAvailableLanguages();
      final sttLocales = await _voiceService.getAvailableSttLocales();

      if (mounted) {
        setState(() {
          _status =
              'TTS languages:\n${ttsLanguages.join(", ")}\n\nSTT locales:\n${sttLocales.join(", ")}';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = 'Language check error: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _stopSpeaking() async {
    await _voiceService.stop();
    await _voiceService.stopListening();

    if (mounted) {
      setState(() {
        _isSpeaking = false;
        _isListening = false;
        _status = 'Stopped';
      });
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool busy = _isSpeaking || _isListening || _isChecking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Test'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.record_voice_over,
                size: 80,
              ),

              const SizedBox(height: 24),

              const Text(
                'Cognitive Care Voice Test',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Test English, Malayalam, and Assamese text-to-speech, and English speech-to-text.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: busy ? null : _speakEnglish,
                  icon: const Icon(Icons.language),
                  label: const Text('Test English Voice'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: busy ? null : _speakMalayalam,
                  icon: const Icon(Icons.language),
                  label: const Text('Test Malayalam Voice'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: busy ? null : _speakAssamese,
                  icon: const Icon(Icons.record_voice_over),
                  label: const Text('Test Assamese Voice'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: busy ? null : _listenEnglish,
                  icon: const Icon(Icons.mic),
                  label: const Text('Test English Listening'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: busy ? null : _checkAvailableLanguages,
                  icon: const Icon(Icons.list),
                  label: const Text('Check Available Languages'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _stopSpeaking,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              if (_recognizedText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Recognized: $_recognizedText',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}