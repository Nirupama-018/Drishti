import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'attention_config.dart';
import 'attention_content.dart';
import 'attention_result.dart';

import '../../localization/localization_manager.dart';
import '../../localization/localized_game_content.dart';

class AttentionGame extends StatefulWidget {
  final AttentionGameConfig config;
  final ValueChanged<AttentionGameResult>? onGameComplete;
  final LocalizationManager localization;

  const AttentionGame({
    super.key,
    this.config = AttentionGameConfig.level1,
    this.onGameComplete,
    required this.localization,
  });

  @override
  State<AttentionGame> createState() => _AttentionGameState();
}

enum AttentionGamePhase {
  instruction,
  playing,
  result,
}

class _AttentionGameState extends State<AttentionGame> {
  final Random _random = Random();

  late AttentionGameConfig _config;

  AttentionGamePhase _phase = AttentionGamePhase.instruction;

  int _currentTrial = 1;

  AttentionObject? _target;
  List<AttentionObject> _choices = [];

  Timer? _timer;
  double _remainingTime = 0.0;
  DateTime? _trialStartTime;

  int _correct = 0;
  int _incorrect = 0;
  int _missed = 0;

  final List<double> _responseTimes = [];

  AttentionGameResult? _result;

  String _getObjectName(AttentionObject object) {
    return LocalizedGameContent.getObjectName(
      object.id,
      widget.localization.currentLanguage,
    );
  }

  String _getTrialText() {
    return widget.localization
        .translate('attention.trial')
        .replaceAll('{current}', _currentTrial.toString())
        .replaceAll('{total}', _config.trialCount.toString());
  }

  String _getTrialInstructionText() {
    return widget.localization
        .translate('attention.trials_time')
        .replaceAll('{trials}', _config.trialCount.toString())
        .replaceAll(
      '{seconds}',
      _config.timeLimit.toStringAsFixed(0),
    );
  }

  String _getAverageResponseTimeText(double seconds) {
    return widget.localization
        .translate('attention.average_response_time')
        .replaceAll('{seconds}', seconds.toStringAsFixed(1));
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(covariant AttentionGame oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.config != widget.config) {
      _config = widget.config;
      _resetGame();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetGame() {
    _timer?.cancel();

    setState(() {
      _phase = AttentionGamePhase.instruction;
      _currentTrial = 1;

      _target = null;
      _choices = [];

      _remainingTime = 0.0;
      _trialStartTime = null;

      _correct = 0;
      _incorrect = 0;
      _missed = 0;

      _responseTimes.clear();

      _result = null;
    });
  }

  void _startGame() {
    setState(() {
      _phase = AttentionGamePhase.playing;
      _currentTrial = 1;

      _correct = 0;
      _incorrect = 0;
      _missed = 0;
      _responseTimes.clear();
    });

    _startTrial();
  }

  void _startTrial() {
    _timer?.cancel();

    final availableObjects = List<AttentionObject>.from(
      AttentionContent.objects,
    )..shuffle(_random);

    final target = availableObjects.first;

    final distractors = availableObjects
        .where((object) => object.id != target.id)
        .take(_config.choiceCount - 1)
        .toList();

    final choices = [
      target,
      ...distractors,
    ]..shuffle(_random);

    setState(() {
      _target = target;
      _choices = choices;

      _remainingTime = _config.timeLimit;
      _trialStartTime = DateTime.now();

      _phase = AttentionGamePhase.playing;
    });

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        final elapsed = DateTime.now()
            .difference(_trialStartTime!)
            .inMilliseconds /
            1000.0;

        final remaining = _config.timeLimit - elapsed;

        if (remaining <= 0) {
          timer.cancel();
          _handleMissedTrial();
        } else {
          setState(() {
            _remainingTime = remaining;
          });
        }
      },
    );
  }

  void _handleChoiceTap(AttentionObject object) {
    if (_phase != AttentionGamePhase.playing) return;

    final responseTime = _trialStartTime == null
        ? 0.0
        : DateTime.now()
        .difference(_trialStartTime!)
        .inMilliseconds /
        1000.0;

    _timer?.cancel();

    if (object.id == _target?.id) {
      _correct++;
    } else {
      _incorrect++;
    }

    _responseTimes.add(responseTime);

    _moveToNextTrial();
  }

  void _handleMissedTrial() {
    if (_phase != AttentionGamePhase.playing) return;

    _missed++;

    _moveToNextTrial();
  }

  void _moveToNextTrial() {
    if (_currentTrial >= _config.trialCount) {
      _finishGame();
      return;
    }

    setState(() {
      _currentTrial++;
      _target = null;
      _choices = [];
    });

    Future.delayed(
      const Duration(milliseconds: 500),
          () {
        if (!mounted) return;
        if (_phase != AttentionGamePhase.playing) return;

        _startTrial();
      },
    );
  }

  void _finishGame() {
    _timer?.cancel();

    final totalTrials = _config.trialCount;

    final accuracy = totalTrials == 0
        ? 0.0
        : _correct / totalTrials;

    final averageResponseTime = _responseTimes.isEmpty
        ? 0.0
        : _responseTimes.reduce((a, b) => a + b) /
        _responseTimes.length;

    final result = AttentionGameResult(
      gameId: _config.gameId,
      difficultyLevel: _config.difficultyLevel,
      totalTrials: totalTrials,
      correct: _correct,
      incorrect: _incorrect,
      missed: _missed,
      accuracy: accuracy,
      averageResponseTime: averageResponseTime,
      completed: true,
    );

    widget.onGameComplete?.call(result);

    setState(() {
      _result = result;
      _phase = AttentionGamePhase.result;
    });
  }

  void _exitGame() {
    _timer?.cancel();

    final result = AttentionGameResult(
      gameId: _config.gameId,
      difficultyLevel: _config.difficultyLevel,
      totalTrials: _config.trialCount,
      correct: _correct,
      incorrect: _incorrect,
      missed: _missed,
      accuracy: _config.trialCount == 0
          ? 0.0
          : _correct / _config.trialCount,
      averageResponseTime: _responseTimes.isEmpty
          ? 0.0
          : _responseTimes.reduce((a, b) => a + b) /
          _responseTimes.length,
      completed: false,
    );

    widget.onGameComplete?.call(result);

    _resetGame();
  }

  Widget _buildInstructionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.visibility_outlined,
              size: 90,
            ),

            const SizedBox(height: 24),

            Text(
              widget.localization.translate('attention.title'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              widget.localization.translate(
                'attention.instruction',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              _getTrialInstructionText(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 36),

            SizedBox(
              width: 220,
              height: 64,
              child: FilledButton(
                onPressed: _startGame,
                child: Text(
                  widget.localization.translate(
                    'common.start',
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayingScreen() {
    final target = _target;

    if (target == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getTrialText(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Row(
                children: [
                  Text(
                    '${_remainingTime.ceil()}',
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
                    tooltip: widget.localization.translate(
                      'common.exit',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          widget.localization.translate(
            'attention.find_this',
          ),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  target.visual,
                  style: const TextStyle(
                    fontSize: 64,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _getObjectName(target),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          widget.localization.translate(
            'attention.tap_matching',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = _config.choiceCount <= 4
                  ? 2
                  : _config.choiceCount <= 6
                  ? 3
                  : 4;

              final rows =
              (_choices.length / columns).ceil();

              const horizontalPadding = 24.0;
              const verticalPadding = 24.0;
              const spacing = 16.0;

              final gridWidth =
                  constraints.maxWidth -
                      (horizontalPadding * 2) -
                      (spacing * (columns - 1));

              final gridHeight =
                  constraints.maxHeight -
                      (verticalPadding * 2) -
                      (spacing * (rows - 1));

              final cardWidth =
                  gridWidth / columns;

              final cardHeight =
                  gridHeight / rows;

              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio:
                  cardWidth / cardHeight,
                ),
                itemCount: _choices.length,
                itemBuilder: (context, index) {
                  final object = _choices[index];

                  return Card(
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(12),
                      onTap: () =>
                          _handleChoiceTap(object),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Text(
                                object.visual,
                                style: const TextStyle(
                                  fontSize: 52,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                _getObjectName(object),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final result = _result!;

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
              widget.localization.translate(
                'game.session_complete',
              ),
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
              '${widget.localization.translate('attention.correct')}: '
                  '${result.correct}',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            Text(
              '${widget.localization.translate('attention.incorrect')}: '
                  '${result.incorrect}',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            Text(
              '${widget.localization.translate('attention.missed')}: '
                  '${result.missed}',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              _getAverageResponseTimeText(
                result.averageResponseTime,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 36),

            SizedBox(
              width: 220,
              height: 64,
              child: FilledButton(
                onPressed: _resetGame,
                child: Text(
                  widget.localization.translate(
                    'common.try_again',
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                  ),
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
      case AttentionGamePhase.instruction:
        content = _buildInstructionScreen();
        break;

      case AttentionGamePhase.playing:
        content = _buildPlayingScreen();
        break;

      case AttentionGamePhase.result:
        content = _buildResultScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.localization.translate('app.title'),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }
}