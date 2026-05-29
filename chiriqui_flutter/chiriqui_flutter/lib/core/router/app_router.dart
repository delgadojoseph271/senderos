import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/route_detail/presentation/screens/route_detail_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/guides/presentation/screens/guide_profile_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/booking/presentation/screens/bookings_list_screen.dart';
import '../auth/auth_service.dart';
import '../widgets/main_shell.dart';

final _authService = AuthService();

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final protectedPaths = ['/booking', '/bookings', '/profile'];
    final isProtected = protectedPaths.any((p) => state.fullPath?.startsWith(p) ?? false);
    if (isProtected && !await _authService.isLoggedIn) {
      return '/auth/login?redirect=${state.fullPath}';
    }
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/',          builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/search',    builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/bookings',  builder: (_, __) => const BookingsListScreen()),
        GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
        GoRoute(path: '/profile',   builder: (_, __) => const ProfileScreen()),
      ],
    ),
    GoRoute(
      path: '/routes/:slug',
      builder: (_, state) => RouteDetailScreen(slug: state.pathParameters['slug']!),
      routes: [
        GoRoute(
          path: 'book',
          builder: (_, state) => BookingScreen(slug: state.pathParameters['slug']!),
          routes: [
            GoRoute(
              path: 'confirm',
              builder: (_, state) => BookingConfirmationScreen(
                bookingId: int.parse(state.uri.queryParameters['id'] ?? '0'),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/guides/:id',
      builder: (_, state) => GuideProfileScreen(guideId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(path: '/auth/login',    builder: (_, state) => LoginScreen(redirect: state.uri.queryParameters['redirect'])),
    GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
  ],
);
