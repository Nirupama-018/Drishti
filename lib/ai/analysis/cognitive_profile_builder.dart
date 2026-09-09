import '../history/session_history.dart';
import '../models/cognitive_profile.dart';
import '../models/game_result.dart';
import 'baseline_calculator.dart';
import 'trend_analyzer.dart';

class CognitiveProfileBuilder {
  final BaselineCalculator baselineCalculator;
  final TrendAnalyzer trendAnalyzer;

  CognitiveProfileBuilder({
    BaselineCalculator? baselineCalculator,
    TrendAnalyzer? trendAnalyzer,
  })  : baselineCalculator =
      baselineCalculator ?? BaselineCalculator(),
        trendAnalyzer =
            trendAnalyzer ?? TrendAnalyzer();

  CognitiveProfile build(SessionHistory history) {
    final memorySessions =
    history.getSessionsForGame('visual_memory');

    final attentionSessions =
    history.getSessionsForGame('visual_attention');

    final visualMemory =
    _buildDomainProfile(memorySessions);

    final selectiveAttention =
    _buildDomainProfile(attentionSessions);

    const processingSpeed = CognitiveDomainProfile(
      performance: 0.0,
      trend: 0.0,
      confidence: 0.0,
    );

    return CognitiveProfile(
      visualMemory: visualMemory,
      selectiveAttention: selectiveAttention,
      processingSpeed: processingSpeed,
    );
  }

  CognitiveDomainProfile _buildDomainProfile(
      List<GameResult> sessions,
      ) {
    if (sessions.isEmpty) {
      return const CognitiveDomainProfile(
        performance: 0.0,
        trend: 0.0,
        confidence: 0.0,
      );
    }

    final performance =
    baselineCalculator.calculateAccuracyBaseline(sessions);

    final trend =
    trendAnalyzer.analyze(sessions);

    return CognitiveDomainProfile(
      performance: performance,
      trend: _trendToValue(trend),
      confidence: _calculateConfidence(sessions.length),
    );
  }

  double _trendToValue(PerformanceTrend trend) {
    switch (trend) {
      case PerformanceTrend.improving:
        return 1.0;

      case PerformanceTrend.stable:
        return 0.5;

      case PerformanceTrend.declining:
        return 0.0;

      case PerformanceTrend.insufficientData:
        return 0.5;
    }
  }

  double _calculateConfidence(int sessionCount) {
    if (sessionCount >= 4) {
      return 1.0;
    }

    return sessionCount / 4;
  }
}