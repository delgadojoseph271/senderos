import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/routes_repository.dart';
import '../../../core/models/route_model.dart';

final routesRepoProvider = Provider((_) => RoutesRepository());

class RouteFilters {
  final String? zone;
  final String? category;
  final String? difficulty;

  const RouteFilters({this.zone, this.category, this.difficulty});

  RouteFilters copyWith({String? zone, String? category, String? difficulty}) =>
      RouteFilters(
        zone: zone ?? this.zone,
        category: category ?? this.category,
        difficulty: difficulty ?? this.difficulty,
      );
}

final routeFiltersProvider = StateProvider((_) => const RouteFilters());

final routesProvider = FutureProvider.autoDispose<List<RouteModel>>((ref) {
  final filters = ref.watch(routeFiltersProvider);
  final repo = ref.read(routesRepoProvider);
  return repo.getRoutes(
    zone: filters.zone,
    category: filters.category,
    difficulty: filters.difficulty,
  );
});

final zonesProvider = FutureProvider((_) => RoutesRepository().getZones());
final categoriesProvider = FutureProvider((_) => RoutesRepository().getCategories());
