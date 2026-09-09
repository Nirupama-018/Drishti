import 'package:flutter/material.dart';

import 'patient/navigation/patient_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _continue() {
    if (_selectedLanguage == null) return;

    Navigator.pushReplacementNamed(
      context,
      PatientRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Language'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.language,
                size: 80,
              ),

              const SizedBox(height: 24),

              const Text(
                'Choose your language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Select a language to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                ),
              ),

              const SizedBox(height: 35),

              _languageButton(
                language: 'English',
                nativeName: 'English',
              ),

              const SizedBox(height: 16),

              _languageButton(
                language: 'Malayalam',
                nativeName: 'മലയാളം',
              ),

              const SizedBox(height: 16),

              _languageButton(
                language: 'Assamese',
                nativeName: 'অসমীয়া',
              ),

              const Spacer(),

              SizedBox(
                height: 65,
                child: FilledButton(
                  onPressed:
                  _selectedLanguage == null ? null : _continue,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageButton({
    required String language,
    required String nativeName,
  }) {
    final isSelected = _selectedLanguage == language;

    return SizedBox(
      height: 75,
      child: OutlinedButton(
        onPressed: () => _selectLanguage(language),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 2,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 28,
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                nativeName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              language,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}