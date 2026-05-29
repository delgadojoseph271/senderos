class BadgeModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String icon;
  final bool earned;
  final String? earnedAt;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.earned,
    this.earnedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> j) => BadgeModel(
    id: (j['id'] as num?)?.toInt() ?? 0,
    name: j['name'] ?? '',
    slug: j['slug'] ?? '',
    description: j['description'] ?? '',
    icon: j['icon'] ?? '',
    earned: j['earned'] ?? false,
    earnedAt: j['earned_at'],
  );
}
