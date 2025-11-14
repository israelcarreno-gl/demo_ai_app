import 'package:demoai/features/auth/presentation/screens/login_screen.dart';
import 'package:demoai/features/auth/presentation/screens/welcome_screen.dart';
import 'package:demoai/features/demo/presentation/screens/demo_screen.dart';
import 'package:demoai/features/demo/presentation/screens/detail_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.welcome,
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
