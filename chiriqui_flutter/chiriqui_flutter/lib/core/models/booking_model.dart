class BookingModel {
  final int id;
  final String status;
  final String paymentStatus;
  final String date;
  final int pax;
  final double totalUsd;
  final RouteBookingRef route;
  final GuideBookingRef guide;

  const BookingModel({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.date,
    required this.pax,
    required this.totalUsd,
    required this.route,
    required this.guide,
  });

  factory BookingModel.fromJson(Map<String, dynamic> j) => BookingModel(
    id: (j['id'] as num?)?.toInt() ?? 0,
    status: j['status']?.toString() ?? '',
    paymentStatus: j['payment_status']?.toString() ?? '',
    date: j['date']?.toString() ?? '',
    pax: (j['pax'] as num?)?.toInt() ?? 0,
    totalUsd: double.tryParse((j['total_usd'] ?? '0').toString()) ?? 0,
    route: RouteBookingRef.fromJson(_asMap(j['route'])),
    guide: GuideBookingRef.fromJson(_asMap(j['guide'])),
  );

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }
}

class RouteBookingRef {
  final int id;
  final String name;
  final String slug;
  const RouteBookingRef({required this.id, required this.name, required this.slug});
  factory RouteBookingRef.fromJson(Map<String, dynamic> j) =>
      RouteBookingRef(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: j['name']?.toString() ?? '',
        slug: j['slug']?.toString() ?? '',
      );
}

class GuideBookingRef {
  final int id;
  final String name;
  const GuideBookingRef({required this.id, required this.name});
  factory GuideBookingRef.fromJson(Map<String, dynamic> j) =>
      GuideBookingRef(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: j['name']?.toString() ?? '',
      );
}
