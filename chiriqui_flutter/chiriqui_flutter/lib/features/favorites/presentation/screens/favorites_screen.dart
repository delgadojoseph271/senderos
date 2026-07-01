import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../home/data/routes_repository.dart';
import '../../../home/presentation/widgets/route_card.dart';
import '../../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slugs = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: slugs.isEmpty
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.favorite_outline, size: 52, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Todavía no guardaste ninguna ruta.',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Explorar rutas'),
                ),
              ]),
            )
          : _FavoritesList(slugs: slugs.toList()),
    );
  }
}

class _FavoritesList extends ConsumerWidget {
  final List<String> slugs;
  const _FavoritesList({required this.slugs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = RoutesRepository();
    return FutureBuilder(
      future: Future.wait(slugs.map((s) => repo.getRoute(s))),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final routes = snap.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: routes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => RouteCard(route: routes[i]),
        );
      },
    );
  }
}
