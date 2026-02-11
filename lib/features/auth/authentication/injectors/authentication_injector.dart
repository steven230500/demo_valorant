import 'package:get_it/get_it.dart';
import '../../../../firebase_login_functions.dart';
import '../data/cache/session_cache.dart';
import '../data/repositories/authentication_repository_impl.dart';
import '../domain/repositories/authentication_repository.dart';
import '../domain/usecases/get_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../presentation/bloc/authentication_bloc.dart';

void authenticationInjector(GetIt getIt) {
  getIt.registerLazySingleton(() => AuthService());

  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

  getIt.registerLazySingleton<SessionCache>(() => SessionCache());

  getIt.registerFactory(
    () => AuthenticationBloc(
      loginUseCase: getIt(),
      getUserUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );
}
