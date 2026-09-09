AttentionGame(
  config: attentionConfig,
  onGameComplete: (result) async {
    final gameResult =
        GameResult.fromAttentionResult(result);

    await PatientSessionService()
        .saveGameResult(gameResult);

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(
      context,
      PatientRoutes.result,
      arguments: gameResult,
    );
  },
)