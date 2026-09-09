import 'package:flutter/material.dart';

class VoiceButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const VoiceButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.volume_up),
      label: Text(text, style: const TextStyle(fontSize: 17)),
    );
  }
}
