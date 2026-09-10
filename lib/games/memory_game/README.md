# Remember the Objects — Memory Game

## Overview

`Remember the Objects` is the visual memory component of the Cognitive Care platform.

The game is designed as a simple, elderly-friendly cognitive exercise that measures visual memory through recognition of previously shown objects.

The game is implemented using standard Flutter widgets and is designed to work independently of the AI, caregiver, voice, and backend components.

### Cognitive domain

* Visual memory
* Visual recognition
* Memory encoding and recall

The game is intended for **cognitive engagement, training, and performance monitoring**. It is not a diagnostic tool and does not independently determine whether a patient has dementia or another medical condition.

---

# Folder Structure

```text
memory_game/
├── memory_config.dart
├── memory_content.dart
├── memory_game.dart
└── memory_result.dart
```

## File Responsibilities

### `memory_game.dart`

Contains the complete game UI and game logic.

Responsible for:

* Game state management
* Round/session management
* Object selection
* Study/exposure phase
* Recall/selection phase
* Scoring
* Response-time measurement
* Result generation
* Handling incomplete/abandoned rounds
* Accepting AI-generated game configuration

This is the main widget:

```dart
MemoryGame
```

---

### `memory_config.dart`

Defines the configuration that controls game difficulty.

Main class:

```dart
MemoryGameConfig
```

Parameters:

```text
gameId
difficultyLevel
objectCount
distractorCount
exposureTime
```

The game is **configuration-driven** rather than hardcoded to a particular difficulty.

This allows the AI/adaptive engine to generate a configuration and pass it directly to the game.

---

### `memory_content.dart`

Contains the available cognitive-game objects.

Main class:

```dart
MemoryObject
```

Each object has:

```text
id
name
visual
```

Example:

```text
id: apple
name: Apple
visual: 🍎
```

The object library is deliberately separated from the game logic so that the content can later be replaced with:

* locally stored images
* culturally familiar objects
* localized names
* region-specific stimulus sets
* voice/localization content

---

### `memory_result.dart`

Defines the performance result produced by each round.

Main class:

```dart
MemoryGameResult
```

The result contains:

```text
gameId
difficultyLevel
totalTargets
correct
incorrect
missed
accuracy
responseTime
completed
```

This is the main interface between the game and the adaptive/analytics layer.

---

# Game Flow

A session contains **3 rounds**.

```text
Session Start
      ↓
Round 1
      ↓
Round 1 Result
      ↓
Round 2
      ↓
Round 2 Result
      ↓
Round 3
      ↓
Round 3 Result
      ↓
Session Complete
```

Each round independently produces a `MemoryGameResult`.

The callback:

```dart
onGameComplete
```

is called after every completed or abandoned round.

Therefore, the AI layer can receive:

```text
Round 1 → MemoryGameResult
Round 2 → MemoryGameResult
Round 3 → MemoryGameResult
```

---

# Game States

The game uses four states:

```dart
enum MemoryGamePhase {
  instruction,
  studying,
  selecting,
  result,
}
```

## 1. Instruction

The patient sees:

* Current round number
* Game name
* Instructions
* Number of objects
* Exposure duration
* Start button

Example:

```text
Round 1 of 3

Remember the Objects

Remember these objects.

You will see 3 objects for 8 seconds.

[Start Round]
```

---

## 2. Studying

The configured target objects are displayed.

The patient has the configured amount of time to remember them.

Example:

```text
Remember these objects                  8
```

The timer counts down according to:

```text
exposureTime
```

When the timer reaches zero, the game automatically moves to the selection phase.

---

## 3. Selecting

The target objects disappear.

The patient receives:

```text
target objects + distractor objects
```

The choices are shuffled randomly.

The patient can:

* Tap an object to select it
* Tap it again to deselect it
* Press `Done` to submit

The selection phase measures the patient's active response time.

---

## 4. Result

The result screen displays:

* Accuracy
* Correct selections
* Missed targets
* Incorrect selections
* Response time

After Round 1 or Round 2:

```text
[Next Round]
```

After Round 3:

```text
[Play Again]
```

---

# Difficulty Configuration

The game currently has three default difficulty presets.

## Level 1

```text
objectCount: 3
distractorCount: 3
exposureTime: 8 seconds
```

Total choices:

```text
3 targets + 3 distractors = 6
```

---

## Level 2

```text
objectCount: 5
distractorCount: 3
exposureTime: 7 seconds
```

Total choices:

```text
5 targets + 3 distractors = 8
```

---

## Level 3

```text
objectCount: 7
distractorCount: 3
exposureTime: 6 seconds
```

Total choices:

```text
7 targets + 3 distractors = 10
```

The default configurations are available as:

```dart
MemoryGameConfig.level1
MemoryGameConfig.level2
MemoryGameConfig.level3
```

---

# AI Configuration Interface

The game does **not** require the AI to use only the predefined Level 1/2/3 presets.

The actual game parameters can be supplied dynamically.

Example:

```dart
MemoryGameConfig(
  difficultyLevel: 2,
  objectCount: 5,
  distractorCount: 5,
  exposureTime: 5,
)
```

This configuration produces:

```text
5 target objects
5 distractor objects
5 seconds exposure time
```

The configuration is then passed into:

```dart
MemoryGame(
  config: config,
)
```

Therefore the intended integration is:

```text
AI Adaptive Engine
        ↓
MemoryGameConfig
        ↓
MemoryGame
        ↓
MemoryGameResult
        ↓
AI Adaptive Engine
```

The AI controls the next configuration.

The game itself only executes the supplied configuration and reports the resulting performance.

---

# Configuration Parameters

## `gameId`

Current value:

```text
visual_memory
```

Used to identify the game when results are passed to the AI/analytics layer.

---

## `difficultyLevel`

Accepted conceptual levels:

```text
1
2
3
```

This is primarily a difficulty label/metadata field.

The actual difficulty is determined by the other configuration parameters.

---

## `objectCount`

Number of target objects shown during the study phase.

Example:

```text
objectCount = 5
```

means the patient must remember 5 objects.

The current content library contains 10 objects.

Therefore:

```text
objectCount <= 10
```

in the current implementation.

---

## `distractorCount`

Number of objects that were not shown during the study phase and are added as false choices.

Example:

```text
objectCount = 5
distractorCount = 5
```

produces:

```text
5 remembered objects
+
5 distractors
=
10 choices
```

The current implementation cannot create more distractors than the number of unused objects in the content library.

---

## `exposureTime`

Amount of time, in seconds, for which the target objects are displayed.

Example:

```text
exposureTime = 5
```

means the patient has 5 seconds to study the objects.

---

# Object Selection

At the beginning of every round, the available object library is shuffled.

Target objects are selected randomly according to:

```text
objectCount
```

Distractors are selected from the remaining objects according to:

```text
distractorCount
```

The final choices are shuffled again.

Therefore, the order of:

* target objects
* distractors
* answer choices

is randomized for each round.

---

# Scoring

The game calculates three basic error categories.

## Correct

A selected object that was actually shown during the study phase.

```text
correct =
selected target objects
```

---

## Incorrect

A selected object that was not shown during the study phase.

```text
incorrect =
selected distractor objects
```

---

## Missed

A target object that was shown but was not selected.

```text
missed =
targets not selected
```

---

# Accuracy

Accuracy is calculated as:

```text
accuracy = correct / totalTargets
```

Example:

```text
totalTargets = 5
correct = 4

accuracy = 4 / 5
         = 0.8
         = 80%
```

Accuracy is returned as a value between:

```text
0.0 → 1.0
```

The UI converts it to a percentage for display.

---

# Response Time

`responseTime` measures the patient's **active selection time**.

It does NOT include the study/exposure period.

Measurement starts when the selection phase begins:

```text
objects disappear
        ↓
selection starts
        ↓
timer starts
```

and ends when the patient presses:

```text
Done
```

The value is returned in:

```text
seconds
```

as a `double`.

Example:

```text
responseTime = 7.4
```

means the patient spent approximately 7.4 seconds making their selections.

---

# Game Result

Each round generates:

```dart
MemoryGameResult
```

with:

```text
gameId
difficultyLevel
totalTargets
correct
incorrect
missed
accuracy
responseTime
completed
```

Example conceptual result:

```json
{
  "gameId": "visual_memory",
  "difficultyLevel": 2,
  "totalTargets": 5,
  "correct": 4,
  "incorrect": 1,
  "missed": 1,
  "accuracy": 0.8,
  "responseTime": 7.4,
  "completed": true
}
```

The result can also be converted to a map using:

```dart
result.toJson()
```

---

# Completed vs Incomplete Rounds

The `completed` field distinguishes genuine completed performance from an abandoned attempt.

## Completed round

```text
completed = true
```

The patient reached the end of the round and submitted their answers.

This result can be used as a normal performance measurement.

---

## Abandoned round

```text
completed = false
```

The patient exited before completing the round.

For an incomplete round:

```text
correct = 0
incorrect = 0
missed = 0
accuracy = 0.0
```

The result should **not** be interpreted as a normal 0% cognitive-performance score.

The AI/analytics layer should first check:

```text
completed
```

before using a result for normal performance analysis.

---

# Callback / Integration

`MemoryGame` exposes:

```dart
final ValueChanged<MemoryGameResult>? onGameComplete;
```

A parent component can listen to results using:

```dart
MemoryGame(
  config: config,
  onGameComplete: (result) {
    // Send result to AI / analytics layer
  },
)
```

The callback fires once per round.

For a normal 3-round session:

```text
callback → Round 1
callback → Round 2
callback → Round 3
```

For an abandoned round:

```text
callback → completed = false
```

---

# Integration With M1 — AI/Adaptive Engine

M1 should treat the game as a configurable component.

### Input to game

```text
MemoryGameConfig
```

### Output from game

```text
MemoryGameResult
```

Recommended flow:

```text
Previous performance
        ↓
AI analysis
        ↓
New MemoryGameConfig
        ↓
Remember the Objects
        ↓
MemoryGameResult
        ↓
AI analysis
```

Potential performance signals available to the AI include:

* Accuracy
* Correct selections
* Incorrect selections
* Missed targets
* Response time
* Difficulty level
* Completion status

The game does not decide whether performance is "good" or "bad".

That interpretation belongs to the adaptive engine.

---

# Integration With M3 — Patient UI

The game is implemented as a standalone Flutter widget:

```dart
MemoryGame(...)
```

M3 can embed it inside the patient-facing navigation/UI.

M3 does not need to modify the game logic to launch a different difficulty.

Example:

```dart
MemoryGame(
  config: MemoryGameConfig.level1,
)
```

or:

```dart
MemoryGame(
  config: aiGeneratedConfig,
)
```

The game itself manages:

```text
Instruction
→ Study
→ Selection
→ Result
```

M3 can therefore treat the game as a self-contained activity.

---

# Integration With M5 — Voice & Localization

The current game UI contains English strings, but the content structure has been separated so that localization/cultural adaptation can be added later.

The important content concepts are:

```text
Game instructions
Object names
Object IDs
Object visuals
```

Object IDs should remain stable even when their displayed names or visuals change.

For example:

```text
id: apple
```

can have different:

```text
name
visual
audio
```

depending on the selected language/content set.

The object library can eventually be replaced with culturally adapted stimulus sets without changing the core scoring logic.

The game should not depend on an online service merely to run the core cognitive activity.

---

# Elderly-Friendly Design Principles

The current implementation follows several accessibility principles:

* Large text
* Large buttons
* Large object visuals
* Large tap targets
* Simple instructions
* Minimal interaction complexity
* No typing required
* Tap-to-select interaction
* Tap again to deselect
* Clear completion feedback
* Simple round progression

The game should remain usable on both:

* Android phones
* Android tablets

Tablet use is particularly important for elderly users because of the larger display and easier interaction.

---

# Current Content Library

The current prototype contains:

```text
Apple
Cup
Key
Book
Flower
Bottle
Spoon
Banana
Umbrella
Candle
```

These are prototype stimuli.

The content system is intentionally separated from the game logic so they can later be replaced or expanded with:

* culturally familiar household objects
* locally recognizable objects
* region-specific content
* language-specific names
* image assets instead of emoji
* additional stimulus sets

---

# Important Implementation Notes

### 1. No AI dependency inside the game

The game does not contain the adaptive algorithm.

It only accepts configuration and returns performance.

This keeps the game independent from M1's implementation.

---

### 2. No database dependency

The game currently does not require:

* Firebase
* SQLite
* Hive
* backend APIs

Results are exposed through the callback and can be consumed by the rest of the application.

---

### 3. Randomization

Every round randomly selects and shuffles objects.

Therefore, repeated rounds do not necessarily use the same objects or ordering.

---

### 4. Three rounds are part of one session

The game itself handles the 3-round session.

Each round still produces an independent result so the AI can analyze performance at the round level.

---

### 5. Configuration is not hardcoded

The Level 1/2/3 presets are defaults.

The game can accept custom configurations.

For example:

```dart
MemoryGameConfig(
  difficultyLevel: 2,
  objectCount: 5,
  distractorCount: 5,
  exposureTime: 5,
)
```

This has already been tested successfully.

---

# Current Status

## M2 Implementation Status

* [x] Visual memory game
* [x] Three-round session
* [x] Three default difficulty levels
* [x] Config-driven difficulty
* [x] Randomized target selection
* [x] Randomized distractors
* [x] Correct/incorrect/missed scoring
* [x] Accuracy calculation
* [x] Response-time measurement
* [x] Completed/incomplete distinction
* [x] Abandoned-round handling
* [x] Per-round result callback
* [x] AI configuration injection tested
* [x] Elderly-friendly basic interaction
* [x] Selection/deselection
* [x] Responsive grid-based layout

## Remaining Future Enhancements

These are not required for the current core implementation but can be added during integration:

* Replace emoji with local image assets
* Expand/culturally adapt object library
* Localization of displayed strings
* TTS/voice instructions
* More sophisticated visual stimulus sets
* Additional difficulty parameters if required by the adaptive engine
* Session-level analytics if needed by the caregiver dashboard

---

# Quick Integration Reference

### Launch default game

```dart
MemoryGame(
  config: MemoryGameConfig.level1,
)
```

### Launch with custom AI configuration

```dart
MemoryGame(
  config: MemoryGameConfig(
    difficultyLevel: 2,
    objectCount: 5,
    distractorCount: 5,
    exposureTime: 5,
  ),
)
```

### Receive result

```dart
MemoryGame(
  config: config,
  onGameComplete: (result) {
    print(result.toJson());
  },
)
```

### Result contract

```text
gameId
difficultyLevel
totalTargets
correct
incorrect
missed
accuracy
responseTime
completed
```

### Game ID

```text
visual_memory
```

---

# Ownership

**Component:** Remember the Objects

**Game ID:** `visual_memory`

**Primary owner:** M2 — Cognitive Games + Medical Research

**Consumes:** `MemoryGameConfig`

**Produces:** `MemoryGameResult`

**AI integration:** M1

**Patient UI integration:** M3

**Voice/localization integration:** M5

**Caregiver/analytics consumption:** M4
