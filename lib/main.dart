import 'package:demo_valorant/core/injectors/injector.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:demo_valorant/core/config/env_config.dart';
import 'package:verse_ds/theme/verse_theme.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initDependencies();
  debugPrint('Running in ${EnvConfig.debugMode ? 'DEBUG' : 'RELEASE'} mode');
  debugPrint('App Title: ${EnvConfig.appTitle}');
  debugPrint('API URL: ${EnvConfig.apiUrl}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Demo Valorant',
      theme: VerseTheme.demoTheme,
      routerConfig: getIt<GoRouter>(),
    );
  }
}
