import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/home_providers.dart';
import '../widgets/route_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(routesProvider);
    final filters = ref.watch(routeFiltersProvider);
    final zonesAsync = ref.watch(zonesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas de Chiriquí assda',
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Zone chips
          zonesAsync.when(
            data: (zones) => SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                      label: 'Todas',
                      selected: filters.zone == null,
                      onTap: () => ref
                          .read(routeFiltersProvider.notifier)
                          .update((s) => s.copyWith())),
                  ...zones.map((z) => _FilterChip(
                        label: z['name'],
                        selected: filters.zone == z['slug'],
                        onTap: () => ref
                            .read(routeFiltersProvider.notifier)
                            .update((s) => s.copyWith(zone: z['slug'])),
                      )),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 44),
            error: (_, __) => const SizedBox(height: 44),
          ),

          // Difficulty chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Todas', 'fácil', 'moderado', 'difícil', 'experto']
                  .map(
                    (d) => _FilterChip(
                      label: d,
                      selected: (d == 'Todas' && filters.difficulty == null) ||
                          filters.difficulty == d,
                      onTap: () => ref
                          .read(routeFiltersProvider.notifier)
                          .update((s) =>
                              s.copyWith(difficulty: d == 'Todas' ? null : d)),
                    ),
                  )
                  .toList(),
            ),
          ),

          const Divider(height: 1),

          // Route list
          Expanded(
            child: routesAsync.when(
              data: (routes) => routes.isEmpty
                  ? const Center(
                      child: Text('No encontramos rutas con esos filtros.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: routes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => RouteCard(route: routes[i]),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1B5E20) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected ? Colors.white : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
