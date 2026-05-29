import '../../../core/api/api_client.dart';
import '../../../core/models/booking_model.dart';

class BookingRepository {
  final _api = ApiClient.instance;

  Future<List<BookingModel>> getBookings() async {
    final res = await _api.get('/bookings');
    return (res.data as List).map((e) => BookingModel.fromJson(e)).toList();
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
    return BookingModel.fromJson(res.data);
  }

  Future<void> cancelBooking(int id) => _api.delete('/bookings/$id');
}
