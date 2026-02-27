class ApiConfig {
  // Loaded at compile time via --dart-define-from-file=.env.json
  // Android emulator: 10.0.2.2 maps to host machine's localhost
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  // Auth endpoints (mobile — returns JWT, not session cookies)
  static const String mobileLoginEndpoint =
      '/api/mobile/auth/login';
  static const String refreshTokenEndpoint =
      '/api/mobile/auth/refresh';
  static const String mobileLogoutEndpoint =
      '/api/mobile/auth/logout';
  static const String switchRoleEndpoint =
      '/api/mobile/auth/switch-role';
  static const String profileEndpoint = '/api/profile';

  // Clinic endpoints
  static const String clinicEndpoint = '/api/clinic';
  static const String settingsEndpoint = '/api/settings';
  static const String brandingEndpoint = '/api/branding';
  static const String publicClinicsEndpoint =
      '/api/clinics/public';

  // User/Staff management endpoints
  static const String usersEndpoint = '/api/users';
  static String userByIdEndpoint(String id) =>
      '/api/users/$id';
  static const String usersBulkEndpoint = '/api/users/bulk';

  // Appointment endpoints
  static const String appointmentsEndpoint =
      '/api/appointments';
  static String appointmentByIdEndpoint(String id) =>
      '/api/appointments/$id';
  static String appointmentStatusEndpoint(String id) =>
      '/api/appointments/$id/status';
  static String appointmentApproveEndpoint(String id) =>
      '/api/appointments/$id/approve';
  static const String pendingAppointmentsEndpoint =
      '/api/appointments/pending';
  static const String availabilityEndpoint =
      '/api/appointments/availability';
  static String appointmentHistoryEndpoint(String id) =>
      '/api/appointments/$id/history';

  // Pet endpoints
  static const String petsEndpoint = '/api/pets';
  static String petByIdEndpoint(String id) =>
      '/api/pets/$id';
  static String petMedicalRecordsEndpoint(String petId) =>
      '/api/pets/$petId/medical-records';
  static String petMedicalSummaryEndpoint(String petId) =>
      '/api/pets/$petId/medical-summary';
  static String petPrescriptionsEndpoint(String petId) =>
      '/api/pets/$petId/prescriptions';
  static String petVaccinationsEndpoint(String petId) =>
      '/api/pets/$petId/vaccinations';

  // Pet Owner endpoints
  static const String petOwnersEndpoint = '/api/pet-owners';
  static String petOwnerByIdEndpoint(String id) =>
      '/api/pet-owners/$id';
  static const String petOwnerLookupByPhoneEndpoint =
      '/api/pet-owners/lookup-by-phone';
  static const String petOwnerQuickCreateEndpoint =
      '/api/pet-owners/quick-create';

  // Medical Record endpoints
  static const String medicalRecordsEndpoint =
      '/api/medical-records';
  static String medicalRecordByIdEndpoint(String id) =>
      '/api/medical-records/$id';

  // Prescription endpoints
  static const String prescriptionsEndpoint =
      '/api/prescriptions';
  static String prescriptionByIdEndpoint(String id) =>
      '/api/prescriptions/$id';
  static String prescriptionPdfEndpoint(String id) =>
      '/api/prescriptions/$id/pdf';

  // Vaccination endpoints
  static const String vaccinationsEndpoint =
      '/api/vaccinations';
  static String vaccinationByIdEndpoint(String id) =>
      '/api/vaccinations/$id';

  // Document endpoints
  static const String documentsEndpoint = '/api/documents';
  static String documentByIdEndpoint(String id) =>
      '/api/documents/$id';
  static const String documentsUploadEndpoint =
      '/api/documents/upload';
  static String documentDownloadEndpoint(String id) =>
      '/api/documents/$id/download';

  // Reminder endpoints
  static const String remindersEndpoint = '/api/reminders';
  static String reminderByIdEndpoint(String id) =>
      '/api/reminders/$id';
  static const String remindersSendEndpoint =
      '/api/reminders/send';

  // Timeout configurations
  static const Duration connectionTimeout =
      Duration(seconds: 30);
  static const Duration receiveTimeout =
      Duration(seconds: 30);
}
