# M3 – Patient Interface and Interaction Layer

## 1. Overview

Member 3 is responsible for the **patient-facing interface and interaction layer** of the Cognitive Care platform.

The objective of this module is to provide elderly users, including users with cognitive impairment, with a simple, accessible, low-complexity interface through which they can:

* Start their recommended cognitive activity
* Choose a cognitive activity manually
* Read or listen to activity instructions
* Play cognitive games
* View activity results
* View their progress
* Access reminders
* Navigate between patient-side features

The M3 layer acts as the **presentation and interaction layer** between the patient and the underlying game, adaptive AI, and session-management components.

---

## 2. M3 Responsibilities

The primary responsibilities of M3 are:

### Patient Interface

M3 provides the screens required for the patient workflow:

* Patient Home
* Activity Selection
* Game Instructions
* Game Host
* Game Result
* Progress
* Reminders

### Navigation

M3 defines patient-specific routes and controls navigation between the different patient screens.

### Patient-Friendly Design

The interface is designed around the requirements of elderly users:

* Large text
* Large buttons
* Simple language
* Minimal navigation complexity
* High visual clarity
* Large touch targets
* Consistent layouts
* Reduced cognitive load

### Game Integration

M3 provides the host layer that launches the cognitive games implemented by Member 2.

The host converts patient-side configuration into the configuration format expected by the games.

### Result Handling

M3 converts game-specific result objects into a common patient-side `GameResult` model.

This allows different games to use the same patient result screen and session-management mechanism.

### AI Integration Point

M3 provides the integration point through which game results can be passed to the adaptive AI developed by Member 1.

---

# 3. High-Level Architecture

The patient-side architecture can be represented as:

```text
                         PATIENT
                            │
                            ▼
                  ┌───────────────────┐
                  │  Patient Home     │
                  └─────────┬─────────┘
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
       Today's Activity  Activities     Progress
             │              │
             │              ▼
             │        Activity Selection
             │              │
             └──────┬───────┘
                    ▼
             Game Recommendation
                    │
                    ▼
             Instruction Screen
                    │
                    ▼
              Game Host Screen
                    │
             ┌──────┴───────┐
             ▼              ▼
       Memory Game     Attention Game
             │              │
             └──────┬───────┘
                    ▼
                Game Result
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
 Patient Session Service   Adaptive AI
          │                   │
          └─────────┬─────────┘
                    ▼
              Result Screen
```

---

# 4. Folder Structure

```text
lib/
└── patient/
    │
    ├── models/
    │   ├── game_config.dart
    │   ├── game_recommendation.dart
    │   └── game_result.dart
    │
    ├── navigation/
    │   └── patient_routes.dart
    │
    ├── screens/
    │   ├── patient_home_screen.dart
    │   ├── activity_selection_screen.dart
    │   ├── game_instruction_screen.dart
    │   ├── game_host_screen.dart
    │   ├── game_result_screen.dart
    │   ├── progress_screen.dart
    │   └── reminder_screen.dart
    │
    ├── services/
    │   ├── patient_session_service.dart
    │   └── recommendation_service.dart
    │
    ├── theme/
    │   ├── patient_colors.dart
    │   ├── patient_dimensions.dart
    │   ├── patient_text_styles.dart
    │   └── patient_theme.dart
    │
    └── widgets/
        ├── activity_card.dart
        ├── instruction_card.dart
        ├── patient_app_bar.dart
        ├── primary_action_button.dart
        ├── secondary_action_button.dart
        ├── result_card.dart
        └── voice_button.dart
```

---

# 5. Patient Navigation

Patient navigation is centralized in:

```text
lib/patient/navigation/patient_routes.dart
```

The defined routes are:

| Route                   | Purpose            |
| ----------------------- | ------------------ |
| `/patient`              | Patient Home       |
| `/patient/activities`   | Activity Selection |
| `/patient/instructions` | Game Instructions  |
| `/patient/game`         | Game Host          |
| `/patient/result`       | Result Screen      |
| `/patient/progress`     | Progress           |
| `/patient/reminders`    | Reminders          |

The application uses:

```dart
onGenerateRoute: PatientRoutes.generateRoute
```

This keeps patient navigation centralized rather than scattering route definitions throughout the application.

---

# 6. Patient Home

File:

```text
lib/patient/screens/patient_home_screen.dart
```

The Patient Home screen is the primary entry point for the elderly user.

Its main purpose is to immediately communicate:

* What activity should be done today
* How to start the activity
* How to manually choose another activity
* How to access progress
* How to access reminders

The home screen is intentionally kept simple.

The recommended activity is expected to originate from the adaptive recommendation system.

---

# 7. Activity Selection

File:

```text
lib/patient/screens/activity_selection_screen.dart
```

This screen allows the patient to manually choose a cognitive activity.

Currently supported activities:

### Remember the Objects

Game ID:

```text
visual_memory
```

Configuration:

```text
difficulty level: 1
object count: 3
distractor count: 3
exposure time: 8 seconds
```

### Find the Target

Game ID:

```text
visual_attention
```

Configuration:

```text
difficulty level: 1
choice count: 4
trial count: 5
time limit: 10 seconds
```

Manual activity selection creates a `GameRecommendation` and sends it to the instruction screen.

This maintains the same data flow used by AI-generated recommendations.

---

# 8. Game Configuration

File:

```text
lib/patient/models/game_config.dart
```

`GameConfig` is the patient-side representation of a playable activity configuration.

It contains:

```text
gameId
difficultyLevel
```

Memory-specific parameters:

```text
objectCount
distractorCount
exposureTime
```

Attention-specific parameters:

```text
choiceCount
trialCount
timeLimit
```

The class also provides:

```dart
isMemoryGame
isAttentionGame
```

which are used to determine which game should be launched.

---

# 9. Game Recommendation

File:

```text
lib/patient/models/game_recommendation.dart
```

A `GameRecommendation` represents a complete recommendation presented to the patient.

It contains:

```text
gameId
title
description
config
```

The separation between `GameRecommendation` and `GameConfig` allows the system to distinguish between:

* What the patient sees
* How the game should be configured

For example:

```text
Recommendation
    ↓
"Remember the Objects"
    ↓
GameConfig
    ↓
visual_memory
difficulty = 2
objects = 5
exposure = 7 seconds
```

---

# 10. Game Instructions

File:

```text
lib/patient/screens/game_instruction_screen.dart
```

The instruction screen is displayed before the cognitive activity begins.

The content changes according to the selected game.

For Memory:

```text
Look carefully
Remember the objects shown
Choose the objects you remember
```

For Attention:

```text
Look at the target
Find the matching object
Tap the correct object
```

The screen also contains a voice-instruction button.

The current implementation provides the UI integration point for the voice/localization work:

```dart
VoiceButton(
    text: 'Hear Instructions',
    ...
)
```

The actual text-to-speech implementation can be connected by the corresponding module.

---

# 11. Game Host

File:

```text
lib/patient/screens/game_host_screen.dart
```

`GameHostScreen` is the integration layer between the M3 patient interface and M2's cognitive games.

It receives:

```text
GameConfig
```

and converts it into the appropriate M2 configuration.

For Memory:

```text
Patient GameConfig
        ↓
MemoryGameConfig
        ↓
MemoryGame
```

For Attention:

```text
Patient GameConfig
        ↓
AttentionGameConfig
        ↓
AttentionGame
```

This design keeps the patient UI independent of the internal implementation of the games.

---

# 12. Memory Game Integration

M2's Memory Game is located at:

```text
lib/games/memory_game/memory_game.dart
```

The current Memory Game contains a three-round session:

```text
Round 1
   ↓
Round 1 Result
   ↓
Next Round
   ↓
Round 2
   ↓
Round 2 Result
   ↓
Next Round
   ↓
Round 3
   ↓
Session Complete
```

The game internally maintains:

```text
_totalRounds = 3
_currentRound
_roundResults
```

Each round produces a `MemoryGameResult`.

The patient host receives these results through the callback:

```dart
onGameComplete
```

---

# 13. Attention Game Integration

M2's Attention Game is located at:

```text
lib/games/attention_game/attention_game.dart
```

The Attention Game uses multiple trials within one activity.

The number of trials depends on difficulty.

For example:

```text
Level 1 → 5 trials
Level 2 → 7 trials
Level 3 → 10 trials
```

Each trial tracks:

* Correct selections
* Incorrect selections
* Missed trials
* Response time

At the end of the activity, an `AttentionGameResult` is generated.

---

# 14. Common Game Result Model

File:

```text
lib/patient/models/game_result.dart
```

Different games produce different result classes.

M3 converts these into a common:

```text
GameResult
```

This provides a consistent representation containing:

```text
gameId
difficultyLevel
totalTrials
correct
incorrect
missed
accuracy
responseTime
completed
```

The conversion functions are:

```dart
GameResult.fromMemoryResult(...)
```

and:

```dart
GameResult.fromAttentionResult(...)
```

This abstraction allows the rest of the patient system to work with games without needing to know their internal result structures.

---

# 15. Patient Session Service

File:

```text
lib/patient/services/patient_session_service.dart
```

The `PatientSessionService` maintains patient-side game results during the current application session.

It uses a singleton:

```dart
PatientSessionService()
```

Internally it stores:

```text
List<GameResult>
```

It provides:

```dart
saveGameResult()
getResults()
completedActivities
averageAccuracy
```

This creates a central location for patient activity data.

---

# 16. Result Screen

File:

```text
lib/patient/screens/game_result_screen.dart
```

The Result Screen provides a simple summary after an activity.

For completed activities, it displays:

* Accuracy
* Correct answers
* Activity name

The screen also provides:

```text
Back to Home
Choose Another Activity
```

The goal is to provide positive feedback without overwhelming the patient with unnecessary statistics.

---

# 17. Progress Screen

File:

```text
lib/patient/screens/progress_screen.dart
```

The Progress screen is intended to provide a patient-friendly view of previous activity performance.

The underlying session data comes from:

```text
PatientSessionService
```

Future versions can connect this screen to the longitudinal cognitive profile generated by M1.

---

# 18. Reminder Screen

File:

```text
lib/patient/screens/reminder_screen.dart
```

The Reminder screen provides the patient-side interface for reminders.

It is intentionally separated from the cognitive-game workflow so reminder functionality can later be expanded without changing the game architecture.

---

# 19. Reusable UI Components

M3 uses reusable widgets instead of implementing buttons and cards separately on every screen.

Examples:

```text
ActivityCard
InstructionCard
PrimaryActionButton
SecondaryActionButton
ResultCard
PatientAppBar
VoiceButton
```

This provides:

* Consistent appearance
* Consistent spacing
* Easier maintenance
* Easier accessibility improvements

---

# 20. Patient Design System

The patient interface uses a centralized design system.

Files:

```text
lib/patient/theme/
```

Components include:

```text
PatientColors
PatientDimensions
PatientTextStyles
PatientTheme
```

## Colors

The current palette uses a soft green-based primary color and light background.

The purpose is to avoid an overly aggressive visual design and maintain comfortable readability.

## Typography

The patient text styles intentionally use larger font sizes.

Examples include:

```text
Heading → 28 px
Title → 22 px
Subtitle → 19 px
Body → 18 px
Secondary body → 17 px
```

## Buttons

Primary and secondary buttons use large minimum heights to make them easier to tap.

---

# 21. Accessibility Considerations

M3 is designed specifically for elderly users.

Important principles include:

### Large Text

Text should remain readable without requiring the patient to move closer to the screen.

### Large Touch Targets

Buttons and activity cards should provide sufficient touch area.

### Simple Language

Instructions avoid technical or abstract terminology.

### Limited Choices

The interface avoids unnecessary menus and complicated navigation.

### Consistency

The same visual patterns are reused throughout the application.

### Feedback

The user receives clear confirmation after completing an activity.

---

# 22. Interaction With M1

M1 provides the adaptive AI system.

The relevant AI architecture is:

```text
GameResult
    ↓
Performance Analyzer
    ↓
Cognitive Profile Builder
    ↓
Cognitive Profile
    ↓
Adaptive Engine
    ↓
Adaptation Decision
```

M3 provides the interface through which this decision becomes a playable patient activity.

The intended integration is:

```text
M1 Adaptive Engine
        ↓
AdaptationDecision
        ↓
GameRecommendation
        ↓
Patient Home
        ↓
Game Instructions
        ↓
Game
```

---

# 23. Interaction With M2

M2 provides the actual cognitive games.

The relationship is:

```text
M3
Patient UI
   │
   ▼
GameHostScreen
   │
   ├───────────────┐
   ▼               ▼
MemoryGame     AttentionGame
   │               │
   └───────┬───────┘
           ▼
       Game Result
```

M3 does not need to know how the internal game mechanics work.

This separation allows M2 to modify game mechanics without requiring major changes to the patient UI.

---

# 24. Complete Patient Activity Flow

The complete intended flow is:

```text
Patient Home
     │
     ▼
Today's Activity
     │
     ▼
Game Recommendation
     │
     ▼
Instructions
     │
     ▼
Game Host
     │
     ├──────────────┐
     ▼              ▼
Memory Game     Attention Game
     │              │
     ▼              ▼
Game Result     Game Result
     │              │
     └───────┬──────┘
             ▼
   Patient Session Service
             │
             ▼
      Adaptive Controller
             │
             ▼
     Cognitive Profile
             │
             ▼
      Adaptive Decision
             │
             ▼
       Next Activity
```

---

# 25. Current AI Integration Status

The M3 interface currently provides the required integration points, but the adaptive loop is not yet fully connected.

Current:

```text
Game
 ↓
GameResult
 ↓
PatientSessionService
```

Required:

```text
Game
 ↓
GameResult
 ↓
PatientSessionService
 ↓
AdaptiveController.processResult()
 ↓
Updated Cognitive Profile
 ↓
Adaptive Recommendation
```

Another issue currently being addressed is that `RecommendationService` creates its own `SessionHistory`.

For adaptive behavior to persist, the history used by:

```text
RecommendationService
```

must be the same history updated by:

```text
AdaptiveController
```

---

# 26. Current Memory Round Integration Status

The M2 Memory Game already contains three-round logic.

However, the current host-level callback treats every round result as if it were the end of the entire activity.

The correct integration should distinguish:

```text
Round Complete
```

from:

```text
Session Complete
```

The intended architecture is:

```text
Round 1
   ↓
AI/session observation
   ↓
Round 2
   ↓
AI/session observation
   ↓
Round 3
   ↓
Session Complete
   ↓
Patient Result Screen
```

This separation allows M2's round logic and M1's adaptive analysis to coexist without the host prematurely leaving the game.

---

# 27. Separation of Responsibilities

| Module                    | Responsibility                      |
| ------------------------- | ----------------------------------- |
| M1                        | AI, cognitive profile, adaptation   |
| M2                        | Cognitive game mechanics            |
| M3                        | Patient UI, navigation, interaction |
| Caregiver module          | Caregiver dashboard and monitoring  |
| Voice/localization module | Speech and language support         |

M3 should not duplicate M1's AI logic or M2's game mechanics.

Instead, M3 acts as the interface connecting them.

---

# 28. Design Principle

The central architectural principle is:

```text
UI should consume configuration and results,
not implement cognitive decision-making.
```

Therefore:

### M3 decides:

* What screen the patient sees
* How the patient navigates
* How instructions are displayed
* How results are presented

### M1 decides:

* Which game should be recommended
* What difficulty should be used
* How performance affects future recommendations

### M2 decides:

* How a game works
* How rounds/trials operate
* How game-specific performance is calculated

---

# 29. Future Improvements

Potential future M3 improvements include:

* Voice-guided navigation
* Full multilingual support
* Larger accessibility controls
* Adjustable text size
* Improved progress visualization
* Persistent patient sessions
* Offline support
* Better loading/error states
* Integration with caregiver feedback
* AI-generated daily activity cards
* Personalized reminders

---

# 30. Testing Checklist

Before considering the M3 module integrated:

### Navigation

* [ ] Patient Home opens
* [ ] Today's Activity opens
* [ ] Activity Selection opens
* [ ] Memory activity opens
* [ ] Attention activity opens
* [ ] Instructions screen opens
* [ ] Game screen opens
* [ ] Result screen opens
* [ ] Progress opens
* [ ] Reminders opens

### Memory

* [ ] Memory instructions display
* [ ] Round 1 starts
* [ ] Study phase works
* [ ] Selection phase works
* [ ] Round 1 result appears
* [ ] Round 2 starts
* [ ] Round 3 starts
* [ ] Final session completes correctly

### Attention

* [ ] Attention instructions display
* [ ] Target appears
* [ ] Choices appear
* [ ] Timer works
* [ ] Correct selection works
* [ ] Incorrect selection works
* [ ] Missed trial works
* [ ] Final result appears

### Results

* [ ] Accuracy is displayed correctly
* [ ] Correct count is displayed
* [ ] Game name is displayed
* [ ] Back to Home works
* [ ] Choose Another Activity works

### AI

* [ ] Game results reach session storage
* [ ] Results reach AdaptiveController
* [ ] Cognitive profile updates
* [ ] Next game is selected
* [ ] Difficulty changes according to performance
* [ ] History persists between recommendations

---

# 31. Summary

M3 provides the patient-facing interaction layer of Cognitive Care.

Its architecture is intentionally separated from the AI and game implementations:

```text
             M3
      Patient Interface
             │
             ▼
       GameHostScreen
        ↙          ↘
      M2            M2
   Memory        Attention
        ↘          ↙
          GameResult
               │
               ▼
              M1
       Adaptive System
               │
               ▼
       Next Recommendation
               │
               ▼
              M3
```

This separation allows each team member to work independently while maintaining a clear integration boundary.
