import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Kelas konfigurasi aplikasi untuk membaca environment variables dari file .env.
class AppConfig {
  /// Mengambil base URL API publik dari environment.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';

  /// Mengambil API key dummy dari environment.
  static String get apiKey => dotenv.env['API_KEY'] ?? 'default_key';
}
