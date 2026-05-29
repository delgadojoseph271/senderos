import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/route_model.dart';
import '../../home/data/routes_repository.dart';

final routeDetailProvider = FutureProvider.autoDispose.family<RouteModel, String>(
  (ref, slug) => RoutesRepository().getRoute(slug),
);
