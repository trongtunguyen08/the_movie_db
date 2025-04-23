import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppContants {
  static String apiKey = dotenv.env["API_KEY"] ?? '';
  static String apiLanguage = dotenv.env["LANGUAGE"] ?? '';
}
