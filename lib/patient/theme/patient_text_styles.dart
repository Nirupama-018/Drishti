import 'package:flutter/material.dart';
import 'patient_colors.dart';

class PatientTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: PatientColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: PatientColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: PatientColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 18,
    height: 1.5,
    color: PatientColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 17,
    height: 1.5,
    color: PatientColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}
