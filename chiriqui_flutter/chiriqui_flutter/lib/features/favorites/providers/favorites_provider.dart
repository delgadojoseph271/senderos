import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorites') ?? [];
    state = saved.toSet();
  }

  Future<void> toggle(String slug) async {
    final next = Set<String>.from(state);
    next.contains(slug) ? next.remove(slug) : next.add(slug);
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', next.toList());
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (_) => FavoritesNotifier(),
);
