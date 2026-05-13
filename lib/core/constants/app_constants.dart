class AppConstants {
  AppConstants._();

  /// Static OTP for simulation (as per assignment requirements)
  static const String staticOtp = '123456';

  /// Firestore collection names
  static const String usersCollection = 'users';
  static const String sosEventsCollection = 'sos_events';
  static const String incidentsCollection = 'incidents';
  static const String incidentReportsCollection = 'incident_reports';
  static const String incidentImagesPath = 'incident_images';

  /// Incident types
  static const List<String> incidentTypes = [
    'Theft',
    'Assault',
    'Accident',
    'Fire',
    'Natural Disaster',
    'Harassment',
    'Suspicious Activity',
    'Medical Emergency',
    'Other',
  ];

  /// Validation
  static const int minPasswordLength = 6;
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
}
