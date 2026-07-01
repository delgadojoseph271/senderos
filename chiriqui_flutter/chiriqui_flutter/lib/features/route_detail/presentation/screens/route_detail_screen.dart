import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../weather/presentation/widgets/weather_widget.dart';
import '../../providers/route_detail_provider.dart';
import '../../../../core/models/route_model.dart';

class RouteDetailScreen extends ConsumerWidget {
  final String slug;
  const RouteDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(routeDetailProvider(slug));

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (route) => _RouteDetailView(route: route),
    );
  }
}

class _RouteDetailView extends StatelessWidget {
  final RouteModel route;
  const _RouteDetailView({required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        // Galería en SliverAppBar
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: route.images.isNotEmpty
                ? PageView.builder(
                    itemCount: route.images.length,
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: route.images[i].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : route.coverImage != null
                    ? CachedNetworkImage(imageUrl: route.coverImage!, fit: BoxFit.cover)
                    : Container(color: Colors.grey.shade300),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Nombre y categoría
              Text(route.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${route.zone.name}  ·  ${route.category.name}',
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 16),

              // Métricas
              Wrap(spacing: 8, runSpacing: 8, children: [
                _MetricChip(icon: Icons.schedule,    label: '${route.durationMinutes ~/ 60}h ${route.durationMinutes % 60}min'),
                if (route.distanceKm != null)
                  _MetricChip(icon: Icons.straighten, label: '${route.distanceKm!.toStringAsFixed(1)} km'),
                if (route.elevationGainM != null)
                  _MetricChip(icon: Icons.trending_up, label: '${route.elevationGainM} m'),
                _DiffChip(difficulty: route.difficulty),
              ]),
              const SizedBox(height: 16),

              // Clima
              WeatherWidget(zoneSlug: route.zone.slug),
              const SizedBox(height: 20),

              // Descripción
              const Text('Descripción', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(route.description, style: const TextStyle(height: 1.6)),
              const SizedBox(height: 20),

              // Tips
              if (route.tips.isNotEmpty) ...[
                const Text('Consejos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...route.tips.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('• ', style: TextStyle(fontSize: 16, color: Color(0xFF1B5E20))),
                    Expanded(child: Text(t, style: const TextStyle(height: 1.5))),
                  ]),
                )),
                const SizedBox(height: 20),
              ],

              // Mapa Mapbox
              const Text('Punto de inicio', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 200,
                  child: MapWidget(
                    key: ValueKey('map_${route.slug}'),
                    styleUri: AppConstants.mapboxStyleOutdoors,
                    cameraOptions: CameraOptions(
                      center: Point(coordinates: Position(route.startLng, route.startLat)),
                      zoom: AppConstants.defaultMapZoom,
                    ),
                    onMapCreated: (controller) async {
                      await controller.annotations.createPointAnnotationManager().then((mgr) {
                        mgr.create(PointAnnotationOptions(
                          geometry: Point(coordinates: Position(route.startLng, route.startLat)),
                        ));
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Guías
              if (route.guides.isNotEmpty) ...[
                const Text('Guías disponibles', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...route.guides.map((g) => _GuideCard(guide: g)),
                const SizedBox(height: 20),
              ],

              // Botón reservar
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push('/routes/${route.slug}/book'),
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: const Text('Reservar ruta'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetricChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: Colors.grey.shade700),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 13)),
    ]),
  );
}

class _DiffChip extends StatelessWidget {
  final String difficulty;
  const _DiffChip({required this.difficulty});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppTheme.difficultyColor(difficulty),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(difficulty, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
  );
}

class _GuideCard extends StatelessWidget {
  final dynamic guide;
  const _GuideCard({required this.guide});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        backgroundImage: guide.photo != null ? CachedNetworkImageProvider(guide.photo!) : null,
        backgroundColor: Colors.grey.shade200,
        child: guide.photo == null ? const Icon(Icons.person_outline) : null,
      ),
      title: Text(guide.name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(guide.languages, style: const TextStyle(fontSize: 12)),
      trailing: FilledButton.tonal(
        onPressed: () => launchUrl(Uri.parse('https://wa.me/${guide.phoneWhatsapp.replaceAll('+', '')}')),
        child: const Text('WhatsApp'),
      ),
    ),
  );
}
