import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

void routerInjector(GetIt getIt){
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  getIt.registerLazySingleton<GoRouter>(
        () => GoRouter(routes: getIt<AppRouter>().routes, initialLocation: '/'),
  );
}
