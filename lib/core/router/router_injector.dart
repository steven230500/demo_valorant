import 'dart:async';

import 'package:demo_valorant/firebase_login_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

void routerInjector(GetIt getIt){
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  getIt.registerLazySingleton<GoRouter>(
        () => GoRouter(
          routes: getIt<AppRouter>().routes, 
          initialLocation: '/',
          redirect: (context, state) {
            final user = FirebaseAuth.instance.currentUser;
            final isLoggingIn = state.matchedLocation == AppRouter.login.path;
            final isSplash = state.matchedLocation == AppRouter.splash.path;
            
            // Si no hay usuario y no está en login ni splash, redirigir a login
            if (user == null && !isLoggingIn && !isSplash) {
              return AppRouter.login.path;
            }
            
            // Si hay usuario y está en login, redirigir a topics
            if (user != null && isLoggingIn) {
              return AppRouter.topics.path;
            }
            
            return null; // No redirigir
          },
          refreshListenable: GoRouterRefreshStream(AuthService().userStream),
        ),
  );
}

// Clase helper para escuchar cambios en el stream de autenticación
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
