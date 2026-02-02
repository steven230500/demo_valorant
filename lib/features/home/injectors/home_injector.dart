import 'package:commons/services/network/base_client.dart';
import 'package:commons/services/utils/constants.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/home_datasource.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/use_cases/home_use_case.dart';

void homeInjector (GetIt getIt){
  getIt.registerLazySingleton<BaseClient>(
        () => BaseClient(baseUrl: Constants.valorantBaseUrl),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(getIt<BaseClient>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );

  getIt.registerLazySingleton<HomeUseCase>(
        () => HomeUseCase(homeRepository: getIt<HomeRepository>()),
  );
}