import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/route_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../favorites/providers/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteCard extends ConsumerWidget {
  final RouteModel route;
  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(route.slug);

    return GestureDetector(
      onTap: () => context.push('/routes/${route.slug}'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: route.coverImage != null
                      ? CachedNetworkImage(
                          imageUrl: route.coverImage!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: Colors.grey.shade200),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                          ),
                        )
                      : Container(color: Colors.grey.shade200),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: _DifficultyBadge(difficulty: route.difficulty),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => ref.read(favoritesProvider.notifier).toggle(route.slug),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_outline,
                        size: 18,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    '${route.zone.name} · ${route.category.name}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.schedule, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${route.durationMinutes ~/ 60}h ${route.durationMinutes % 60}min',
                        style: const TextStyle(fontSize: 12)),
                    if (route.distanceKm != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.straighten, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${route.distanceKm!.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.difficultyColor(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        difficulty,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
