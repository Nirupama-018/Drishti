# Find the Target

## Overview

**Find the Target** is a visual attention game designed to assess and train selective attention and processing speed.

The player is shown a target object and must identify and tap the matching object from a set of choices. Each trial has a configurable time limit.

The game records performance for every trial and returns a structured result that can be consumed by the AI/adaptive personalization system.

---

## Cognitive Domain

* **Primary:** Selective Attention
* **Secondary:** Processing Speed
* **Interaction:** Visual recognition and target selection

The game requires the player to focus on a specific target while ignoring visually similar or competing choices.

---

## Game Flow

```text
Instruction
     ↓
Start Game
     ↓
Target Object Appears
     ↓
Multiple Choices Appear
     ↓
Player Selects a Choice
     ↓
Correct / Incorrect
     ↓
Next Trial
     ↓
Repeat Until Trial Count Is Reached
     ↓
Game Result
```

If the player does not respond before the configured time limit, the trial is recorded as **missed**.

The player can also exit the game before completion. Such a result is marked as `completed = false`.

---

## Difficulty & Configuration

The game is configuration-driven. The gameplay does not depend on hardcoded difficulty-specific mechanics.

### Configuration

```dart
AttentionGameConfig(
  gameId: 'visual_attention',
  difficultyLevel: 1,
  choiceCount: 4,
  trialCount: 5,
  timeLimit: 10.0,
)
```

### Configuration Parameters

| Parameter         | Description                                 |
| ----------------- | ------------------------------------------- |
| `gameId`          | Fixed identifier: `visual_attention`        |
| `difficultyLevel` | Current difficulty level                    |
| `choiceCount`     | Number of choices shown in each trial       |
| `trialCount`      | Number of trials in the game                |
| `timeLimit`       | Maximum response time per trial, in seconds |

The AI can modify these parameters through the configuration generator.

For example:

```text
Easier:
choiceCount = 4
timeLimit = 10 seconds

Harder:
choiceCount = 8
timeLimit = 6 seconds
```

The game itself simply executes the supplied configuration.

The UI grid is dynamically sized based on the number of choices, so changing `choiceCount` does not require separate UI implementations for each difficulty.

### Default Presets

**Level 1**

* 4 choices
* 5 trials
* 10 seconds per trial

**Level 2**

* 6 choices
* 7 trials
* 8 seconds per trial

**Level 3**

* 8 choices
* 10 trials
* 6 seconds per trial

These are default presets only. The game can accept other valid parameter values through `AttentionGameConfig`.

---

## Trial Mechanics

Each trial follows this process:

1. A target object is selected.
2. A set of choices is generated.
3. The target is included among the choices.
4. The choices are shuffled.
5. The player selects one choice.
6. The response is classified as:

    * **Correct** — target selected.
    * **Incorrect** — distractor selected.
    * **Missed** — no response before the time limit.
7. The next trial begins.

Each trial allows only one response.

---

## Content

Game content is maintained separately in:

```text
lib/games/attention_game/attention_content.dart
```

Each object contains:

* Stable object ID
* Object name
* Visual representation

Current content includes:

* Apple
* Banana
* Flower
* Cup
* Key
* Book
* Spoon
* Bottle
* Umbrella
* Candle

The content is separated from the game mechanics so that culturally familiar or localized stimuli can be introduced later without changing the core game logic.

---

## Performance Measurement

The game records:

### Correct

Number of trials where the player selected the target.

### Incorrect

Number of trials where the player selected a distractor.

### Missed

Number of trials where the player did not respond before the time limit.

### Accuracy

```text
accuracy = correct / totalTrials
```

Returned as a value between `0.0` and `1.0`.

### Average Response Time

The average response time is calculated using **responded trials only**.

Missed trials are excluded from the average response time.

```text
averageResponseTime =
    sum(response times of responded trials)
    / number of responded trials
```

This prevents missed trials from artificially increasing the response-time measurement.

---

## Result Contract

After a game is completed, the game produces an `AttentionGameResult`.

```dart
AttentionGameResult(
  gameId: 'visual_attention',
  difficultyLevel: ...,
  totalTrials: ...,
  correct: ...,
  incorrect: ...,
  missed: ...,
  accuracy: ...,
  averageResponseTime: ...,
  completed: true,
)
```

### Result Fields

| Field                 | Description                                  |
| --------------------- | -------------------------------------------- |
| `gameId`              | Fixed identifier: `visual_attention`         |
| `difficultyLevel`     | Difficulty associated with the configuration |
| `totalTrials`         | Total number of configured trials            |
| `correct`             | Number of correct responses                  |
| `incorrect`           | Number of incorrect responses                |
| `missed`              | Number of missed trials                      |
| `accuracy`            | Correct responses / total trials             |
| `averageResponseTime` | Average response time for responded trials   |
| `completed`           | Whether the game was completed normally      |

The result can be serialized using:

```dart
result.toJson()
```

---

## Incomplete / Abandoned Games

If the player exits before completing all trials:

```text
completed = false
```

This allows the AI system to distinguish an abandoned/incomplete game from a genuine poor-performance observation.

Incomplete results should **not** automatically be interpreted as evidence of low cognitive performance.

---

## AI Integration

The game exposes its result through:

```dart
final ValueChanged<AttentionGameResult>? onGameComplete;
```

Example:

```dart
AttentionGame(
  config: config,
  onGameComplete: (result) {
    // Send result to AI / analytics
  },
)
```

Integration flow:

```text
AttentionGameConfig
        ↓
   AttentionGame
        ↓
AttentionGameResult
        ↓
 AttentionResultAdapter
        ↓
 Generic GameResult
        ↓
 Performance Analyzer
        ↓
 Cognitive Profile
        ↓
 Adaptive Engine
```

The game does not contain AI decision-making logic.

The AI determines the next configuration; the game executes that configuration and reports the resulting performance.

---

## AI/Game Boundary

### Game 2 owns

* Game UI
* Trial mechanics
* Target selection
* Choice generation
* Timer
* Scoring
* Performance measurement
* Game-specific configuration
* Game-specific result
* Content library

### AI owns

* Performance analysis
* History
* Cognitive profile
* Trend analysis
* Difficulty decisions
* Game selection
* Configuration generation

The AI should not depend on internal game implementation details such as the content library or UI.

---

## Integration Contract

The following identifiers and structures should remain stable unless coordinated with the AI team.

### Game ID

```text
visual_attention
```

### Configuration

```text
gameId
difficultyLevel
choiceCount
trialCount
timeLimit
```

### Result

```text
gameId
difficultyLevel
totalTrials
correct
incorrect
missed
accuracy
averageResponseTime
completed
```

The AI team can adapt the game-specific result into the generic `GameResult` format through an adapter.

---

## File Structure

```text
lib/
└── games/
    └── attention_game/
        ├── README.md
        ├── attention_config.dart
        ├── attention_content.dart
        ├── attention_result.dart
        └── attention_game.dart

assets/
└── games/
    └── attention_game/
        └── README.md
```

---

## Design Principles

* **Configuration-driven:** Game behavior is controlled through configuration parameters.
* **Literacy-independent:** Core interaction relies on visual recognition and tapping.
* **Elderly-friendly:** Large visual targets, simple instructions, and minimal interaction steps.
* **Culturally adaptable:** Content can be replaced or localized without changing game mechanics.
* **AI-compatible:** Structured results provide measurable signals for adaptive personalization.
* **Offline-capable:** Core gameplay does not require an internet connection.
* **Game-agnostic AI boundary:** AI interacts through configuration and result contracts rather than game internals.

---

## Current Status

**Game 2 — Find the Target**

* [x] Instruction screen
* [x] Configurable choice count
* [x] Configurable trial count
* [x] Configurable time limit
* [x] Correct response tracking
* [x] Incorrect response tracking
* [x] Miss tracking
* [x] Accuracy calculation
* [x] Average response-time calculation
* [x] Abandonment handling
* [x] Result callback
* [x] JSON serialization
* [x] Dynamic choice grid
* [x] Level 1 testing
* [x] Level 2 testing
* [x] Level 3 testing
* [x] Flutter analysis with no issues
