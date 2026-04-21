class AppConstants {
  // API
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000/api',
  );
  // Example for shared testing:
  // flutter run --dart-define=API_BASE_URL=https://your-public-backend/api
  // flutter run --dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:5000/api

  // Business Info
  static const String businessName = "Veera's Beauty & Tattoo Studio";
  static const String businessTagline = 'Where Beauty Meets Artistry';
  static const String whatsappNumber = '918344549199';
  static const String phoneNumber = '+918344549199';
  static const String address =
      '9, Gopal Street, Mariyamman Kovil back side, Thattarar Street, '
      'behind Kodanagar Mariamman Temple, Alathur, Cheyyar, Tamil Nadu 604407';

  // VIP
  static const int vipPrice = 999;
  static const int vipDurationDays = 365;
  static const int vipFreeBookingEvery = 11;
  static const int vipServiceDiscountPct = 10;
  static const int vipBridalExtraDiscountPct = 5;

  // Time Slots
  static const List<String> timeSlots = [
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];

  // Service Categories
  static const Map<String, String> categoryLabels = {
    'hair': 'Hair',
    'skin': 'Skin',
    'grooming': 'Grooming',
    'makeup': 'Makeup',
    'mehendi': 'Mehendi',
    'tattoo': 'Tattoo',
    'saree_draping': 'Saree Draping',
    'bridal': 'Bridal',
    'other': 'Other',
  };

  static const Map<String, String> categoryIcons = {
    'hair': 'H',
    'skin': 'S',
    'grooming': 'G',
    'makeup': 'M',
    'mehendi': 'Me',
    'tattoo': 'T',
    'saree_draping': 'SD',
    'bridal': 'B',
    'other': '*',
  };

  // Course Categories
  static const Map<String, String> courseCategoryLabels = {
    'makeup': 'Makeup',
    'hair': 'Hair Styling',
    'skin': 'Skin Care',
    'nail': 'Nail Art',
    'mehendi': 'Mehendi',
    'bridal': 'Bridal',
    'tattoo': 'Tattoo',
    'grooming': 'Grooming',
    'business': 'Business',
  };

  // Shared Prefs Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyOnboarded = 'onboarded';
}
