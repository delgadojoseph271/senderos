import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/data/routes_repository.dart';
import '../../../home/presentation/widgets/route_card.dart';
import '../../../../core/models/route_model.dart';

final _searchQueryProvider = StateProvider((_) => '');

final _searchResultsProvider = FutureProvider.autoDispose<List<RouteModel>>((ref) {
  final q = ref.watch(_searchQueryProvider);
  if (q.isEmpty) return RoutesRepository().getRoutes();
  return RoutesRepository().getRoutes(search: q);
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar rutas...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          onChanged: (v) {
            Future.delayed(const Duration(milliseconds: 300), () {
              ref.read(_searchQueryProvider.notifier).state = v;
            });
          },
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (routes) => routes.isEmpty
            ? const Center(child: Text('Sin resultados para esa búsqueda.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: routes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => RouteCard(route: routes[i]),
              ),
      ),
    );
  }
}
