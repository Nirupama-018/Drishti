# Localization

## Overview

The localization module provides multi-language support for the Cognitive Care application.

The current prototype supports:

* 🇬🇧 English (`en`)
* 🇮🇳 Assamese (`as`)
* 🇮🇳 Malayalam (`ml`)

English is used as the default/fallback language.

The localization system is designed so that game content, instructions, interface text, and object names can be displayed according to the language selected by the user.

---

## Folder Structure

```text
lib/localization/
├── localization_data.dart
├── localization_manager.dart
├── app_localizations.dart
└── localized_game_content.dart
```

### `localization_data.dart`

Contains the application's translated interface strings for each supported language.

Examples include:

* Common buttons
* Game titles
* Instructions
* Round/trial information
* Results
* Response-time information
* Session messages

Translations are organized using keys such as:

```text
common.start
common.done
memory.title
memory.round
attention.title
attention.trial
game.session_complete
```

---

### `localization_manager.dart`

Manages the currently selected language.

Main responsibilities:

* Store the active language
* Change the language
* Retrieve translated strings
* Fall back to English when a translation is unavailable

Example:

```dart
final localization = LocalizationManager();

localization.setLanguage('ml');

final title = localization.translate('memory.title');
```

---

### `localized_game_content.dart`

Contains translations for game-specific content such as object names.

Example:

```text
Apple
→ English: Apple
→ Assamese: আপেল
→ Malayalam: ആപ്പിൾ
```

The game object itself remains language-independent. Only its displayed name changes.

---

### `app_localizations.dart`

Provides the application-level localization interface/helpers used by the rest of the application.

---

## Language Selection Flow

The current prototype follows this flow:

```text
Language Selection
        ↓
LocalizationManager
        ↓
Integration Test
        ↓
Cognitive Games
        ↓
Localized Game UI
```

The selected `LocalizationManager` is passed to the games so that the same language remains active throughout the patient session.

---

## Localized Games

### Remember the Objects

The following are localized:

* Game title
* Instructions
* Study-phase text
* Selection instructions
* Round number
* Number of objects
* Exposure time
* Correct / Incorrect / Missed
* Response time
* Result screen
* App bar
* Object names

### Find the Target

The following are localized:

* Game title
* Instructions
* Trial number
* Trial/time information
* Target instruction
* Target object name
* Matching-object instruction
* Choice object names
* Correct / Incorrect / Missed
* Average response time
* Result screen
* App bar

---

## Current Localization Coverage

| Component            | English | Assamese | Malayalam |
| -------------------- | ------: | -------: | --------: |
| Language Selection   |       ✅ |        ✅ |         ✅ |
| Remember the Objects |       ✅ |        ✅ |         ✅ |
| Find the Target      |       ✅ |        ✅ |         ✅ |
| Game object names    |       ✅ |        ✅ |         ✅ |
| Patient Dashboard    |       ❌ |        ❌ |         ❌ |
| Caregiver Dashboard  |       ❌ |        ❌ |         ❌ |
| Integration Test UI  |      ⚠️ |        ❌ |         ❌ |
| Other app-wide UI    |      ⚠️ |        ❌ |         ❌ |

The dashboards and remaining application UI are **not yet connected to the localization system** and should be localized when their respective screens are finalized.

---

## Adding a New Translation

To add a new UI string:

### 1. Add the key to English

```dart
'new.key': 'English text',
```

### 2. Add the same key to Assamese

```dart
'new.key': 'Assamese translation',
```

### 3. Add the same key to Malayalam

```dart
'new.key': 'Malayalam translation',
```

### 4. Use the localization manager

```dart
Text(
  localization.translate('new.key'),
)
```

Avoid hardcoding user-facing text directly inside widgets.

---

## Placeholder Strings

Dynamic values can be inserted using placeholders.

Example:

```dart
'memory.round': 'Round {current} of {total}',
```

Replace the placeholders when displaying the string:

```dart
localization
    .translate('memory.round')
    .replaceAll('{current}', current.toString())
    .replaceAll('{total}', total.toString());
```

This allows the same UI structure to work across languages.

---

## Regional Language Strategy

The prototype demonstrates localization using English, Assamese, and Malayalam.

Assamese provides a representative language for the North-Eastern India requirement, while Malayalam supports testing and demonstration in Kerala.

The architecture is designed to allow additional Indian languages to be added later without changing the game logic.

Future languages can be added by introducing another language code and its corresponding translations.

---

## Design Principles

1. **English is the fallback language.**
2. **Game logic must remain independent of language.**
3. **User-facing strings should not be hardcoded in game screens.**
4. **Object IDs remain language-independent.**
5. **Translations are managed centrally.**
6. **Adding a language should not require rewriting game logic.**
7. **Localization must not interfere with gameplay or adaptive AI.**

---

## Integration with Games

Games receive the shared `LocalizationManager`:

```dart
MemoryGame(
  config: MemoryGameConfig.level1,
  localization: localization,
  onGameComplete: onGameComplete,
)
```

and:

```dart
AttentionGame(
  config: AttentionGameConfig.level1,
  localization: localization,
  onGameComplete: onGameComplete,
)
```

This ensures that the selected language is preserved while moving between games.

---

## Future Work

* Localize patient dashboard
* Localize caregiver dashboard
* Localize remaining navigation and application UI
* Integrate localized voice/TTS
* Add additional North-Eastern Indian languages
* Validate translations with native speakers
* Test text length and readability on elderly-friendly UI
