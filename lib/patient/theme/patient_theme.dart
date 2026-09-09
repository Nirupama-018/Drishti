import 'package:flutter/material.dart';
import 'patient_colors.dart';
import 'patient_text_styles.dart';
import 'patient_dimensions.dart';

class PatientTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(seedColor: PatientColors.primary),

      scaffoldBackgroundColor: PatientColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: PatientColors.background,
        foregroundColor: PatientColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      textTheme: const TextTheme(
        headlineMedium: PatientTextStyles.heading,
        titleLarge: PatientTextStyles.title,
        titleMedium: PatientTextStyles.subtitle,
        bodyLarge: PatientTextStyles.body,
        bodyMedium: PatientTextStyles.bodySecondary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            PatientDimensions.buttonHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PatientDimensions.cardRadius),
          ),
          textStyle: PatientTextStyles.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            PatientDimensions.buttonHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PatientDimensions.cardRadius),
          ),
          textStyle: PatientTextStyles.button,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        color: PatientColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PatientDimensions.cardRadius),
        ),
      ),
    );
  }
}
