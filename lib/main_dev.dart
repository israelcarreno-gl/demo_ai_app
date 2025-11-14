import 'package:demoai/app.dart';
import 'package:demoai/core/config/environment_manager.dart';
import 'package:demoai/core/di/injection_container.dart';
import 'package:demoai/core/observers/app_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Development entry point
/// Initializes app with DEV environment
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies with DEV environment
  await initializeDependencies(initialEnvironment: Environment.dev);

  // Set BLoC observer
  Bloc.observer = getIt<AppBlocObserver>();

  runApp(const MyApp());
}
