import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/models/badge_model.dart';

final _meProvider = FutureProvider.autoDispose((_) => AuthService().me());
final _allBadgesProvider = FutureProvider.autoDispose((_) async {
  final res = await ApiClient.instance.get('/badges');
  return (res.data as List).map((e) => BadgeModel.fromJson(e)).toList();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meAsync    = ref.watch(_meProvider);
    final badgesAsync = ref.watch(_allBadgesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Avatar + info
          meAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
            data: (user) => user == null ? const SizedBox.shrink() : Row(children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF1B5E20),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(user.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ]),
            ]),
          ),

          const SizedBox(height: 28),

          // Acceso rápido a reservas
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Mis reservas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/bookings'),
          ),
          const Divider(),

          const SizedBox(height: 16),

          // Badges
          const Text('Badges', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          badgesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('No se pudieron cargar los badges.'),
            data: (badges) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: badges.length,
              itemBuilder: (_, i) => _BadgeTile(badge: badges[i]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final BadgeModel badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.earned ? 1.0 : 0.35,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: badge.earned ? const Color(0xFF1B5E20).withOpacity(0.07) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: badge.earned ? const Color(0xFF1B5E20).withOpacity(0.3) : Colors.grey.shade200,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(badge.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!badge.earned)
            const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
        ]),
      ),
    );
  }
}
