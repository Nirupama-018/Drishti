class CognitiveDomainProfile {
  final double performance;
  final double trend;
  final double confidence;

  const CognitiveDomainProfile({
    required this.performance,
    required this.trend,
    required this.confidence,
  });
}

class CognitiveProfile {
  final CognitiveDomainProfile visualMemory;
  final CognitiveDomainProfile selectiveAttention;
  final CognitiveDomainProfile processingSpeed;

  const CognitiveProfile({
    required this.visualMemory,
    required this.selectiveAttention,
    required this.processingSpeed,
  });
}