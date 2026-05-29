class RouteModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String difficulty;
  final int durationMinutes;
  final double? distanceKm;
  final int? elevationGainM;
  final double startLat;
  final double startLng;
  final String? coverImage;
  final List<String> tips;
  final bool isActive;
  final ZoneRef zone;
  final CategoryRef category;
  final List<RouteImage> images;
  final List<GuideRef> guides;

  const RouteModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.difficulty,
    required this.durationMinutes,
    this.distanceKm,
    this.elevationGainM,
    required this.startLat,
    required this.startLng,
    this.coverImage,
    required this.tips,
    required this.isActive,
    required this.zone,
    required this.category,
    required this.images,
    required this.guides,
  });

  factory RouteModel.fromJson(Map<String, dynamic> j) => RouteModel(
    id: (j['id'] as num?)?.toInt() ?? 0,
    name: j['name'] ?? '',
    slug: j['slug'] ?? '',
    description: j['description'] ?? '',
    difficulty: j['difficulty'] ?? '',
    durationMinutes: (j['duration_minutes'] as num?)?.toInt() ?? 0,
    distanceKm: (j['distance_km'] as num?)?.toDouble(),
    elevationGainM: (j['elevation_gain_m'] as num?)?.toInt(),
    startLat: double.parse((j['start_lat'] ?? '0').toString()),
    startLng: double.parse((j['start_lng'] ?? '0').toString()),
    coverImage: j['cover_image'],
    tips: (j['tips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    isActive: j['is_active'] ?? true,
    zone: ZoneRef.fromJson(j['zone'] ?? {}),
    category: CategoryRef.fromJson(j['category'] ?? {}),
    images: (j['images'] as List<dynamic>?)
        ?.map((e) => RouteImage.fromJson(e))
        .toList() ?? [],
    guides: (j['guides'] as List<dynamic>?)
        ?.map((e) => GuideRef.fromJson(e))
        .toList() ?? [],
  );
}

class ZoneRef {
  final int id;
  final String name;
  final String slug;
  const ZoneRef({required this.id, required this.name, required this.slug});
  factory ZoneRef.fromJson(Map<String, dynamic> j) =>
      ZoneRef(id: (j['id'] as num?)?.toInt() ?? 0, name: j['name'] ?? '', slug: j['slug'] ?? '');
}

class CategoryRef {
  final int id;
  final String name;
  final String slug;
  const CategoryRef({required this.id, required this.name, required this.slug});
  factory CategoryRef.fromJson(Map<String, dynamic> j) =>
      CategoryRef(id: (j['id'] as num?)?.toInt() ?? 0, name: j['name'] ?? '', slug: j['slug'] ?? '');
}

class RouteImage {
  final String url;
  final String? caption;
  final int order;
  const RouteImage({required this.url, this.caption, required this.order});
  factory RouteImage.fromJson(Map<String, dynamic> j) =>
      RouteImage(url: j['image_url'] ?? '', caption: j['caption'], order: (j['sort_order'] as num?)?.toInt() ?? 0);
}

class GuideRef {
  final int id;
  final String name;
  final String phoneWhatsapp;
  final String? photo;
  final String languages;
  const GuideRef({
    required this.id,
    required this.name,
    required this.phoneWhatsapp,
    this.photo,
    required this.languages,
  });
  factory GuideRef.fromJson(Map<String, dynamic> j) => GuideRef(
    id: (j['id'] as num?)?.toInt() ?? 0,
    name: j['name'] ?? '',
    phoneWhatsapp: j['whatsapp'] ?? '',
    photo: j['photo'],
    languages: (j['languages'] as String?) ?? 'Español',
  );
}
