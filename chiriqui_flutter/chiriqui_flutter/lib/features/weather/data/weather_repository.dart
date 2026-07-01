import '../../../core/api/api_client.dart';
import '../../../core/models/weather_model.dart';

class WeatherRepository {
  final _api = ApiClient.instance;

  Future<WeatherModel> getWeather(String zoneSlug) async {
    final res = await _api.get('/zones/$zoneSlug/weather');
    return WeatherModel.fromJson(res.data);
  }
}
