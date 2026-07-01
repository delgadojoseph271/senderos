import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/weather_repository.dart';
import '../../../core/models/weather_model.dart';

final weatherProvider = FutureProvider.autoDispose.family<WeatherModel, String>(
  (ref, zoneSlug) => WeatherRepository().getWeather(zoneSlug),
);
