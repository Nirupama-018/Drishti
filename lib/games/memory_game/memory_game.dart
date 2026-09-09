import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'memory_config.dart';
import 'memory_content.dart';
import 'memory_result.dart';

import '../../localization/localization_manager.dart';
import '../../localization/localized_game_content.dart';

class MemoryGame extends StatefulWidget {
final MemoryGameConfig config;
final ValueChanged<MemoryGameResult>? onGameComplete;
final LocalizationManager localization;

const MemoryGame({
super.key,
this.config = MemoryGameConfig.level1,
this.onGameComplete,
required this.localization,
});

@override
State<MemoryGame> createState() => _MemoryGameState();
}

enum MemoryGamePhase {
instruction,
studying,
selecting,
result,
}

class _MemoryGameState extends State<MemoryGame> {
final Random _random = Random();

MemoryGamePhase _phase = MemoryGamePhase.instruction;

late MemoryGameConfig _config;

List<MemoryObject> _targets = [];
List<MemoryObject> _choices = [];

final Set<String> _selectedIds = {};

Timer? _studyTimer;
int _remainingStudySeconds = 0;

DateTime? _selectionStartTime;

MemoryGameResult? _result;

// Session tracking
static const int _totalRounds = 3;
int _currentRound = 1;
final List<MemoryGameResult> _roundResults = [];

String _getObjectName(MemoryObject object) {
return LocalizedGameContent.getObjectName(
object.id,
widget.localization.currentLanguage,
);
}

String _getRoundText() {
return widget.localization
    .translate('memory.round')
    .replaceAll('{current}', _currentRound.toString())
    .replaceAll('{total}', _totalRounds.toString());
}

String _getObjectsSecondsText() {
return widget.localization
    .translate('memory.objects_seconds')
    .replaceAll('{objects}', _config.objectCount.toString())
    .replaceAll('{seconds}', _config.exposureTime.toString());
}

String _getResponseTimeText(double seconds) {
return widget.localization
    .translate('memory.response_time')
    .replaceAll('{seconds}', seconds.toStringAsFixed(1));
}

@override
void initState() {
super.initState();
_config = widget.config;
}

@override
void didUpdateWidget(covariant MemoryGame oldWidget) {
super.didUpdateWidget(oldWidget);

if (oldWidget.config != widget.config) {
_config = widget.config;
_resetGame();
}
}

@override
void dispose() {
_studyTimer?.cancel();
super.dispose();
}

void _resetGame() {
_studyTimer?.cancel();

setState(() {
_phase = MemoryGamePhase.instruction;
_targets = [];
_choices = [];
_selectedIds.clear();
_remainingStudySeconds = 0;
_selectionStartTime = null;
_result = null;

_currentRound = 1;
_roundResults.clear();
});
}

void _startGame() {
final availableObjects = List<MemoryObject>.from(
MemoryContent.objects,
)..shuffle(_random);

final objectCount = _config.objectCount.clamp(
1,
availableObjects.length,
);

final targets = availableObjects.take(objectCount).toList();

final remainingObjects = availableObjects
    .where(
(object) =>
!targets.any((target) => target.id == object.id),
)
    .toList();

final maxDistractors = remainingObjects.length;

final distractorCount = _config.distractorCount.clamp(
0,
maxDistractors,
);

final distractors =
remainingObjects.take(distractorCount).toList();

final choices = [
...targets,
...distractors,
]..shuffle(_random);

_studyTimer?.cancel();

setState(() {
_targets = targets;
_choices = choices;
_selectedIds.clear();

_remainingStudySeconds = _config.exposureTime;

_phase = MemoryGamePhase.studying;
});

_studyTimer = Timer.periodic(
const Duration(seconds: 1),
(timer) {
if (!mounted) {
timer.cancel();
return;
}

if (_remainingStudySeconds <= 1) {
timer.cancel();
_beginSelection();
} else {
setState(() {
_remainingStudySeconds--;
});
}
},
);
}

void _beginSelection() {
if (!mounted) return;

setState(() {
_phase = MemoryGamePhase.selecting;
_selectionStartTime = DateTime.now();
});
}

void _toggleSelection(MemoryObject object) {
if (_phase != MemoryGamePhase.selecting) return;

setState(() {
if (_selectedIds.contains(object.id)) {
_selectedIds.remove(object.id);
} else {
_selectedIds.add(object.id);
}
});
}

void _submitAnswers() {
if (_phase != MemoryGamePhase.selecting) return;

final targetIds =
_targets.map((object) => object.id).toSet();

final correct =
_selectedIds.intersection(targetIds).length;

final incorrect = _selectedIds
    .where((id) => !targetIds.contains(id))
    .length;

final missed = targetIds
    .where((id) => !_selectedIds.contains(id))
    .length;

final accuracy = _targets.isEmpty
? 0.0
    : correct / _targets.length;

final responseTime = _selectionStartTime == null
? 0.0
    : DateTime.now()
    .difference(_selectionStartTime!)
    .inMilliseconds /
1000.0;

final result = MemoryGameResult(
gameId: _config.gameId,
difficultyLevel: _config.difficultyLevel,
totalTargets: _targets.length,
correct: correct,
incorrect: incorrect,
missed: missed,
accuracy: accuracy,
responseTime: responseTime,
completed: true,
);

// Store this round's result.
_roundResults.add(result);

// Send this individual round result to M1.
widget.onGameComplete?.call(result);

setState(() {
_result = result;
_phase = MemoryGamePhase.result;
});
}

void _exitGame() {
_studyTimer?.cancel();

final targetCount = _targets.length;

final result = MemoryGameResult(
gameId: _config.gameId,
difficultyLevel: _config.difficultyLevel,
totalTargets: targetCount,
correct: 0,
incorrect: 0,
missed: targetCount,
accuracy: 0.0,
responseTime: _selectionStartTime == null
? 0.0
    : DateTime.now()
    .difference(_selectionStartTime!)
    .inMilliseconds /
1000.0,
completed: false,
);

widget.onGameComplete?.call(result);

_resetGame();
}

void _startNextRound() {
if (_currentRound >= _totalRounds) return;

setState(() {
_currentRound++;

_targets = [];
_choices = [];
_selectedIds.clear();

_remainingStudySeconds = 0;
_selectionStartTime = null;
_result = null;

  DateTime? _selectionStartTime;

  MemoryGameResult? _result;

  // Session tracking
  static const int _totalRounds = 3;
  int _currentRound = 1;
  final List<MemoryGameResult> _roundResults = [];

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(covariant MemoryGame oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.config != widget.config) {
      _config = widget.config;
      _resetGame();
    }
  }

  @override
  void dispose() {
    _studyTimer?.cancel();
    super.dispose();
  }

  void _resetGame() {
    _studyTimer?.cancel();

    setState(() {
      _phase = MemoryGamePhase.instruction;
      _targets = [];
      _choices = [];
      _selectedIds.clear();
      _remainingStudySeconds = 0;
      _selectionStartTime = null;
      _result = null;

      _currentRound = 1;
      _roundResults.clear();
    });
  }

  void _startGame() {
    final availableObjects = List<MemoryObject>.from(
      MemoryContent.objects,
    )..shuffle(_random);

    final objectCount = _config.objectCount.clamp(
      1,
      availableObjects.length,
    );

    final targets = availableObjects.take(objectCount).toList();

    final remainingObjects = availableObjects
        .where((object) => !targets.any((target) => target.id == object.id))
        .toList();

    final maxDistractors = remainingObjects.length;
    final distractorCount = _config.distractorCount.clamp(
      0,
      maxDistractors,
    );

    final distractors = remainingObjects.take(distractorCount).toList();

    final choices = [
      ...targets,
      ...distractors,
    ]..shuffle(_random);

    _studyTimer?.cancel();

    setState(() {
      _targets = targets;
      _choices = choices;
      _selectedIds.clear();

      _remainingStudySeconds = _config.exposureTime;

      _phase = MemoryGamePhase.studying;
    });

    _studyTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_remainingStudySeconds <= 1) {
          timer.cancel();
          _beginSelection();
        } else {
          setState(() {
            _remainingStudySeconds--;
          });
        }
      },
    );
  }

  void _beginSelection() {
    if (!mounted) return;

    setState(() {
      _phase = MemoryGamePhase.selecting;
      _selectionStartTime = DateTime.now();
    });
  }

  void _toggleSelection(MemoryObject object) {
    if (_phase != MemoryGamePhase.selecting) return;

    setState(() {
      if (_selectedIds.contains(object.id)) {
        _selectedIds.remove(object.id);
      } else {
        _selectedIds.add(object.id);
      }
    });
  }

  void _submitAnswers() {
    if (_phase != MemoryGamePhase.selecting) return;

    final targetIds = _targets.map((object) => object.id).toSet();

    final correct = _selectedIds.intersection(targetIds).length;

    final incorrect = _selectedIds
        .where((id) => !targetIds.contains(id))
        .length;

    final missed = targetIds
        .where((id) => !_selectedIds.contains(id))
        .length;

    final accuracy = _targets.isEmpty
        ? 0.0
        : correct / _targets.length;

    final responseTime = _selectionStartTime == null
        ? 0.0
        : DateTime.now()
        .difference(_selectionStartTime!)
        .inMilliseconds /
        1000.0;

    final result = MemoryGameResult(
      gameId: _config.gameId,
      difficultyLevel: _config.difficultyLevel,
      totalTargets: _targets.length,
      correct: correct,
      incorrect: incorrect,
      missed: missed,
      accuracy: accuracy,
      responseTime: responseTime,
      completed: true,
    );

    // Store this round's result.
    _roundResults.add(result);

    final isFinalRound = _currentRound == _totalRounds;

    setState(() {
      _result = result;
      _phase = MemoryGamePhase.result;
    });

    // Notify the host ONLY when the entire 3-round session is complete.
    if (isFinalRound) {
      widget.onGameComplete?.call(result);
    }
  }

  void _exitGame() {
    _studyTimer?.cancel();

    final targetCount = _targets.length;

    final result = MemoryGameResult(
      gameId: _config.gameId,
      difficultyLevel: _config.difficultyLevel,
      totalTargets: targetCount,
      correct: 0,
      incorrect: 0,
      missed: targetCount,
      accuracy: 0.0,
      responseTime: _selectionStartTime == null
          ? 0.0
          : DateTime.now()
          .difference(_selectionStartTime!)
          .inMilliseconds /
          1000.0,
      completed: false,
    );

    widget.onGameComplete?.call(result);

    _resetGame();
  }

  void _startNextRound() {
    if (_currentRound >= _totalRounds) return;

    setState(() {
      _currentRound++;
      _targets = [];
      _choices = [];
      _selectedIds.clear();
      _remainingStudySeconds = 0;
      _selectionStartTime = null;
      _result = null;
      _phase = MemoryGamePhase.instruction;
    });
  }

  Widget _buildInstructionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Round $_currentRound of $_totalRounds',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.psychology_outlined,
              size: 90,
            ),
            const SizedBox(height: 24),
            const Text(
              'Remember the Objects',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Remember these objects.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 12),
            Text(
              'You will see ${_config.objectCount} objects for '
                  '${_config.exposureTime} seconds.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: 220,
              height: 64,
              child: FilledButton(
                onPressed: _startGame,
                child: const Text(
                  'Start Round',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Round $_currentRound of $_totalRounds',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$_remainingStudySeconds',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Text(
          'Remember these objects',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1,
            ),
            itemCount: _targets.length,
            itemBuilder: (context, index) {
              final object = _targets[index];

              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      object.visual,
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      object.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionScreen() {
    return Column(
      children: [Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Round $_currentRound of $_totalRounds',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  '$_remainingStudySeconds',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _exitGame,
                  icon: const Icon(Icons.close),
                  iconSize: 30,
                  tooltip: 'Exit',
                ),
              ],
            ),
          ],
        ),
      ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1,
            ),
            itemCount: _choices.length,
            itemBuilder: (context, index) {
              final object = _choices[index];
              final selected = _selectedIds.contains(object.id);

              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _toggleSelection(object),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: selected ? 4 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          object.visual,
                          style: const TextStyle(fontSize: 52),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          object.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (selected)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.check_circle,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 56,
                child: OutlinedButton(
                  onPressed: _exitGame,
                  child: const Text(
                    'Exit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 160,
                height: 56,
                child: FilledButton(
                  onPressed: _submitAnswers,
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final result = _result!;
    final isFinalRound = _currentRound == _totalRounds;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 90,
            ),
            const SizedBox(height: 20),
            Text(
              isFinalRound
                  ? 'Session Complete!'
                  : 'Round $_currentRound Complete!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${(result.accuracy * 100).round()}%',
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Correct: ${result.correct}',
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              'Missed: ${result.missed}',
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              'Incorrect: ${result.incorrect}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              'Response time: '
                  '${result.responseTime.toStringAsFixed(1)} seconds',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 36),
            if (isFinalRound)
              SizedBox(
                width: 220,
                height: 64,
                child: FilledButton(
                  onPressed: _resetGame,
                  child: const Text(
                    'Play Again',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              )
            else
              SizedBox(
                width: 220,
                height: 64,
                child: FilledButton(
                  onPressed: _startNextRound,
                  child: const Text(
                    'Next Round',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_phase) {
      case MemoryGamePhase.instruction:
        content = _buildInstructionScreen();
        break;
      case MemoryGamePhase.studying:
        content = _buildStudyScreen();
        break;
      case MemoryGamePhase.selecting:
        content = _buildSelectionScreen();
        break;
      case MemoryGamePhase.result:
        content = _buildResultScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cognitive Care'),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
