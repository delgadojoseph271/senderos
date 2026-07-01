import '../../../core/api/api_client.dart';
import '../../../core/models/booking_model.dart';

class BookingRepository {
  final _api = ApiClient.instance;

  Future<List<BookingModel>> getBookings() async {
    final res = await _api.get('/bookings');
    return _parseBookingList(res.data);
  }

  List<BookingModel> _parseBookingList(dynamic raw) {
    final items = _extractList(raw);
    return items
        .where((e) => e is Map)
        .map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  List<dynamic> _extractList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return raw;
    if (raw is! Map) return [];

    final map = Map<String, dynamic>.from(raw);
    final data = map['data'];
    if (data is List) return data;
    if (data is Map) return [data];
    if (map.containsKey('id')) return [map];
    return [];
  }

  Future<BookingModel> createBooking({
    required int routeId,
    required int guideId,
    required String date,
    required int pax,
    String? notes,
  }) async {
    final res = await _api.post('/bookings', data: {
      'route_id': routeId,
      'guide_id': guideId,
      'date': date,
      'pax': pax,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    return BookingModel.fromJson(_extractSingle(res.data));
  }

  Map<String, dynamic> _extractSingle(dynamic raw) {
    if (raw is! Map) return {};
    final map = Map<String, dynamic>.from(raw);
    if (map['data'] is Map) {
      return Map<String, dynamic>.from(map['data'] as Map);
    }
    return map;
  }

  Future<void> cancelBooking(int id) => _api.delete('/bookings/$id');
}
