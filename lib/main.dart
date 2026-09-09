import 'package:flutter/material.dart';

import 'caregiver/caregiver_dashboard.dart';
import 'caregiver/caregiver_service.dart';
import 'role_selection_screen.dart';
import 'patient/navigation/patient_routes.dart';
import 'patient/theme/patient_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CaregiverService.instance.loadSessions();

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

      initialRoute: '/',

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const RoleSelectionScreen(),
            );

          case '/caregiver':
            return MaterialPageRoute(
              builder: (_) => const CaregiverDashboard(),
            );

          default:
            return PatientRoutes.generateRoute(settings);
        }
      },
    );
  }
}