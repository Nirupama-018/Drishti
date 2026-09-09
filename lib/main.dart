import 'package:flutter/material.dart';

import 'caregiver/caregiver_service.dart';
import 'patient/navigation/patient_routes.dart';
import 'patient/theme/patient_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load previously saved caregiver/game sessions.
  await CaregiverService.instance.loadSessions();

  runApp(const DrishtiApp());
}

class DrishtiApp extends StatelessWidget {
  const DrishtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cognitive Care',
      theme: PatientTheme.theme,
      initialRoute: PatientRoutes.home,
      onGenerateRoute: PatientRoutes.generateRoute,
    );
  }
}