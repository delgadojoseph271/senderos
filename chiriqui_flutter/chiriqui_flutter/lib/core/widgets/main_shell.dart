import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc == '/') return 0;
    if (loc.startsWith('/search')) return 1;
    if (loc.startsWith('/bookings')) return 2;
    if (loc.startsWith('/favorites')) return 3;
    if (loc.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/');
            case 1: context.go('/search');
            case 2: context.go('/bookings');
            case 3: context.go('/favorites');
            case 4: context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined),      selectedIcon: Icon(Icons.map),       label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.search_outlined),   selectedIcon: Icon(Icons.search),    label: 'Buscar'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Reservas'),
          NavigationDestination(icon: Icon(Icons.favorite_outline),  selectedIcon: Icon(Icons.favorite),  label: 'Favoritos'),
          NavigationDestination(icon: Icon(Icons.person_outline),    selectedIcon: Icon(Icons.person),    label: 'Perfil'),
        ],
      ),
    );
  }
}
