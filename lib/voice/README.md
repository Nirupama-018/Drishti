# lib/voice — Voice Module

**Owner:** Member 5

This module handles all text-to-speech (TTS) and speech-to-text (STT)
functionality for Cognitive Care. Games and patient-facing screens
should use `VoiceService` rather than calling `flutter_tts` or
`speech_to_text` directly.

## Files

| File | Purpose |
|---|---|
| `voice_service.dart` | Core service — English (and Malayalam) TTS/STT via on-device engines |
| `voice_test_screen.dart` | Temporary dev screen for manually testing TTS/STT buttons. Not part of the real app flow — safe to remove before final submission. |
| `assamese_voice_service.dart` *(planned)* | Assamese TTS/STT via the Bhashini API, since on-device engines don't support Assamese |

## Current status

- ✅ English TTS — working
- ✅ English STT — working (requires mic permission, see below)
- ✅ Malayalam TTS — working *if* the device has the Malayalam voice
  pack installed (check via the "Check Available Languages" button
  in `voice_test_screen.dart`)
- ❌ Assamese TTS/STT — **not supported** by on-device engines
  (`flutter_tts` / `speech_to_text`). Requires Bhashini API
  integration (pending — see TODO below).

## Setup requirements

**Android permissions** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

**Dependencies** (`pubspec.yaml`):
```yaml
dependencies:
  flutter_tts: ^4.2.3
  speech_to_text: ^7.0.0
```

## How to test

1. Run the app on a **real Android device or emulator** — not Chrome/web.
   Web uses a different TTS/STT engine (the browser's) and does not
   reflect real app behavior.
2. Temporarily set `home: const VoiceTestScreen()` in `main.dart` to
   reach the test screen (revert this before committing).
3. Tap through each button and check the status text at the bottom.
4. If testing on an emulator, enable **Extended Controls → Microphone
   → "Virtual microphone uses host audio input"**, or listening will
   never pick up real speech.

## Known gotchas

- `flutter_tts` silently no-ops (no error, no sound) when the
  requested language has no matching voice installed on-device. This
  is expected for Assamese — it is not a bug.
- Web (`flutter run -d chrome`) uses browser speech APIs, which behave
  differently from Android's. Always verify on Android before treating
  a result as final.
- `speech_to_text` needs the `RECORD_AUDIO` permission granted at
  runtime (the OS permission popup) — if denied once, it will keep
  failing silently until re-enabled in device Settings > Apps >
  Cognitive Care > Permissions.

## TODO

- [ ] Register for Bhashini API access (`userID` + `ulcaApiKey`)
- [ ] Build `AssameseVoiceService` (TTS via Bhashini pipeline)
- [ ] Add Assamese ASR (speech-to-text) via Bhashini
- [ ] Offline fallback: pre-recorded Assamese audio for fixed phrases
      (game instructions, reminders) when Bhashini is unreachable
- [ ] Wire `VoiceService` into actual game/patient screens (currently
      only used by the isolated test screen)
- [ ] Language selector UI (English / Malayalam / Assamese) — likely
      lives in `lib/localization/`
- [ ] Remove or repurpose `voice_test_screen.dart` before final submission