class PatientProfile {
  final String patientId;
  final String name;
  final int? age;
  final String? preferredLanguage;

  const PatientProfile({
    required this.patientId,
    required this.name,
    this.age,
    this.preferredLanguage,
  });
}
