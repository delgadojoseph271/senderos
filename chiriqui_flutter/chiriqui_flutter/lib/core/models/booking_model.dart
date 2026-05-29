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
    status: j['status'] ?? '',
    paymentStatus: j['payment_status'] ?? '',
    date: j['date'] ?? '',
    pax: (j['pax'] as num?)?.toInt() ?? 0,
    totalUsd: double.tryParse((j['total_usd'] ?? '0').toString()) ?? 0,
    route: RouteBookingRef.fromJson(j['route'] ?? {}),
    guide: GuideBookingRef.fromJson(j['guide'] ?? {}),
  );
}

class RouteBookingRef {
  final int id;
  final String name;
  final String slug;
  const RouteBookingRef({required this.id, required this.name, required this.slug});
  factory RouteBookingRef.fromJson(Map<String, dynamic> j) =>
      RouteBookingRef(id: (j['id'] as num?)?.toInt() ?? 0, name: j['name'] ?? '', slug: j['slug'] ?? '');
}

class GuideBookingRef {
  final int id;
  final String name;
  const GuideBookingRef({required this.id, required this.name});
  factory GuideBookingRef.fromJson(Map<String, dynamic> j) =>
      GuideBookingRef(id: (j['id'] as num?)?.toInt() ?? 0, name: j['name'] ?? '');
}
