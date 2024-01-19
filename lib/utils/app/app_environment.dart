import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {

  static String get fileName {
    if(kReleaseMode) {
      return '.env.production';
    }

    return '.env.development';
  }

  static String get passwordKey => dotenv.get("PASSWORD_KEY");
  static String get tmdbApiKey => dotenv.get("TMDB_API_KEY");
  static String get tmdbApiReadAccessToken => dotenv.get("TMDB_API_READ_ACCESS_TOKEN");
  static String storageUrl = "gs://ecinema-watch-together.appspot.com/";
  static String databaseUrl = "https://ecinema-watch-together-default-rtdb.firebaseio.com/";
}