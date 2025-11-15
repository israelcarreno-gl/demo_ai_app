import 'dart:async';
import 'dart:io';

import 'package:demoai/core/di/injection_container.dart';
import 'package:demoai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demoai/features/auth/presentation/screens/login_screen.dart';
import 'package:demoai/features/auth/presentation/screens/welcome_screen.dart';
import 'package:demoai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:demoai/features/demo/presentation/screens/demo_screen.dart';
import 'package:demoai/features/demo/presentation/screens/detail_screen.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_bloc.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_bloc.dart';
import 'package:demoai/features/questionnaire/presentation/screens/document_upload_screen.dart';
import 'package:demoai/features/questionnaire/presentation/screens/questionnaire_detail_screen.dart';
import 'package:demoai/features/questionnaire/presentation/screens/questionnaire_options_screen.dart';
import 'package:demoai/features/questionnaire/presentation/screens/questionnaire_response_screen.dart';
import 'package:demoai/features/questionnaire/presentation/screens/questionnaire_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String demo = '/demo';
  static const String detail = '/detail';
  static const String documentUpload = '/document-upload';
  static const String questionnaireOptions = '/questionnaire-options';
  static const String questionnaireDetail = '/questionnaire-detail';
  static const String questionnaireResponse = '/questionnaire-response';
  static const String questionnaireResult = '/questionnaire-result';
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

      // If authenticated and going to auth screens, redirect to home
      if (isAuthenticated && isGoingToAuth) {
        return AppRoutes.home;
      }

      // If not authenticated and not going to auth screens, redirect to welcome
      if (!isAuthenticated && !isAuthLoading && !isGoingToAuth) {
        return AppRoutes.welcome;
      }

      return null;
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
      GoRoute(
        path: AppRoutes.documentUpload,
        name: 'documentUpload',
        builder: (context, state) => const DocumentUploadScreen(),
      ),
      GoRoute(
        path: AppRoutes.questionnaireOptions,
        name: 'questionnaireOptions',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BlocProvider(
            create: (context) => getIt<QuestionnaireBloc>(),
            child: QuestionnaireOptionsScreen(
              documentFile: extra?['file'] as File,
              fileName: extra?['fileName'] as String,
              fileSize: extra?['fileSize'] as int,
              fileType: extra?['fileType'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.questionnaireDetail,
        name: 'questionnaireDetail',
        builder: (context, state) {
          final questionnaire = state.extra! as QuestionnaireModel;
          return QuestionnaireDetailScreen(questionnaire: questionnaire);
        },
      ),

      GoRoute(
        path: AppRoutes.questionnaireResponse,
        name: 'questionnaireResponse',
        builder: (context, state) {
          final questionnaire = state.extra! as QuestionnaireModel;
          return BlocProvider(
            create: (context) => getIt<QuestionnaireResponseBloc>(),
            child: QuestionnaireResponseScreen(questionnaire: questionnaire),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.questionnaireResult,
        name: 'questionnaireResult',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final questionnaire = extra?['questionnaire'] as QuestionnaireModel?;
          return QuestionnaireResultScreen(
            questionnaire: questionnaire,
            correctCount: extra?['correctCount'] as int? ?? 0,
            totalLocal: extra?['totalLocal'] as int? ?? 0,
            perQuestionCorrect:
                extra?['perQuestionCorrect'] as Map<String, bool>? ?? {},
          );
        },
      ),
    ],
  );
}
