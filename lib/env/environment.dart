import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final String googleApiKey = dotenv.env['GOOGLE_API_KEY']!;
  static final String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
  static final String pocketbaseUri = dotenv.env['POCKETBASE_URI']!;
}
