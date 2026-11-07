import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global router provider. Routes are registered here and consumed
/// by [MyApp]. Business feature routes are added per-feature in
/// later phases — see `mobile/lib/features/README.md`.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
});

/// Placeholder route constants. Concrete feature routes live under
/// `mobile/lib/features/<feature>/` in later phases.
abstract class AppRoutes {
  static const String splash = '/';
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'myFarm',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
