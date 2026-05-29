import '../../../core/api/api_client.dart';
import '../../../core/models/route_model.dart';

class RoutesRepository {
  final _api = ApiClient.instance;

  Future<List<RouteModel>> getRoutes({
    String? zone,
    String? category,
    String? difficulty,
    String? search,
    int page = 1,
  }) async {
    final res = await _api.get('/routes', params: {
      if (zone != null) 'zone': zone,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (search != null) 'search': search,
      'page': page,
    });
    final data = res.data['data'] as List;
    return data.map((e) => RouteModel.fromJson(e)).toList();
  }

  Future<RouteModel> getRoute(String slug) async {
    final res = await _api.get('/routes/$slug');
    final json = res.data['data'] ?? res.data;
    return RouteModel.fromJson(json);
  }

  Future<List<Map<String, dynamic>>> getZones() async {
    final res = await _api.get('/zones');
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final res = await _api.get('/categories');
    return List<Map<String, dynamic>>.from(res.data);
  }
}
