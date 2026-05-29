import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get mapboxToken =>
      dotenv.env['MAPBOX_PUBLIC_TOKEN'] ?? '';

  static String get apiBaseUrl {
    final fromEnv = dotenv.env['API_BASE_URL'];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    if (kIsWeb) return 'http://localhost/api/v1';
    if (Platform.isAndroid) return 'http://10.0.2.2/api/v1';
    return 'http://localhost/api/v1';
  }

  static const String mapboxStyleOutdoors =
      'mapbox://styles/mapbox/outdoors-v12';

  static const double defaultMapZoom = 13.0;
  static const double pricePerPerson = 30.0;
}
