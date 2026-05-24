/// Smart Umbrella App - Navigation Router (v3 – ShellRoute + Splash)
///
/// Uses StatefulShellRoute to provide a persistent nav bar across all
/// main screens (Dashboard, Lighting, Sound, Battery).
/// Settings/Profile/Debug are pushed as separate full-screen routes.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../widgets/app_shell.dart';
import '../../page/splash.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/lighting/presentation/lighting_screen.dart';
import '../../features/sound/presentation/sound_screen.dart';
import '../../features/battery/presentation/battery_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/debug/presentation/debug_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

/// Provider for the router instance
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      // ── Splash ────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      // ── Onboarding ────────────────────────────────────────
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      // ── Main Shell (persistent nav bar) ───────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Branch 0 – Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboard,
                name: RouteNames.dashboard,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const DashboardScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
            ],
          ),

          // Branch 1 – Lighting
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.lighting,
                name: RouteNames.lighting,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const LightingScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
            ],
          ),

          // Branch 2 – Sound
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.sound,
                name: RouteNames.sound,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const SoundScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
            ],
          ),

          // Branch 3 – Battery
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.battery,
                name: RouteNames.battery,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const BatteryScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
            ],
          ),
        ],
      ),

      // ── Settings (full-screen push, outside shell) ────────
      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOutCubic));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),

      // ── Debug (full-screen push) ──────────────────────────
      GoRoute(
        path: RoutePaths.debug,
        name: RouteNames.debug,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DebugScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOutCubic));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),

      // ── Profile (full-screen push) ────────────────────────
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic));
            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      ),
    ],

    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(RoutePaths.dashboard),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});
