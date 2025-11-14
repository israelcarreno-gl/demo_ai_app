import 'package:demoai/app.dart';
import 'package:demoai/core/config/environment_manager.dart';
import 'package:demoai/core/di/injection_container.dart';
import 'package:demoai/core/observers/app_bloc_observer.dart';
import 'package:demoai/core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies(initialEnvironment: Environment.prod);

  final supabaseService = getIt<SupabaseService>();
  try {
    await supabaseService.initialize();
  } catch (e) {
    debugPrint('Supabase initialization skipped: $e');
  }

  Bloc.observer = getIt<AppBlocObserver>();

  runApp(const MyApp());
}
