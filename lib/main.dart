import 'package:flutter/material.dart';

import 'patient/navigation/patient_routes.dart';
import 'patient/theme/patient_theme.dart';

void main() {
  runApp(const DrishtiApp());
}

class DrishtiApp extends StatelessWidget {
  const DrishtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drishti',
      theme: PatientTheme.theme,
      initialRoute: PatientRoutes.home,
      onGenerateRoute: PatientRoutes.generateRoute,
    );
  }
}
