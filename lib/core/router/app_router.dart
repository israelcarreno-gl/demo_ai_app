import 'dart:async';

import 'package:demoai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demoai/features/auth/presentation/screens/login_screen.dart';
import 'package:demoai/features/auth/presentation/screens/welcome_screen.dart';
import 'package:demoai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:demoai/features/demo/presentation/screens/demo_screen.dart';
import 'package:demoai/features/demo/presentation/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String demo = '/demo';
  static const String detail = '/detail';
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: AppRoutes.welcome,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuthenticated = authState is Authenticated;
      final isAuthLoading = authState is AuthLoading;

      final isGoingToAuth =
          state.matchedLocation == AppRoutes.welcome ||
          state.matchedLocation == AppRoutes.login;

      // Si está autenticado y va a pantallas de auth, redirigir a home
      if (isAuthenticated && isGoingToAuth) {
        return AppRoutes.home;
      }

      // Si no está autenticado y no va a pantallas de auth, redirigir a welcome
      if (!isAuthenticated && !isAuthLoading && !isGoingToAuth) {
        return AppRoutes.welcome;
      }

      return null; // No redirigir
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.demo,
        name: 'demo',
        builder: (context, state) => const DemoScreen(),
      ),
      GoRoute(
        path: AppRoutes.detail,
        name: 'detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DetailScreen(joke: extra?['joke'] as String?);
        },
      ),
    ],
  );
}
