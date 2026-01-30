import 'package:commons/services/network/base_client.dart';
import 'package:demo_valorant/features/topics/domain/use_cases/get_subtopics_use_case.dart';
import 'package:demo_valorant/features/topics/presentation/bloc/subtopics_bloc/subtopics_bloc.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/topics_datasource.dart';
import '../data/repositories/topics_repository_impl.dart';
import '../domain/repositories/topics_repository.dart';
import '../domain/use_cases/get_topics_use_case.dart';
import '../presentation/bloc/topics_bloc/topics_bloc.dart';

void topicsInjector(GetIt getIt){
  getIt.registerLazySingleton<BaseClient>(
        () => BaseClient(),
    instanceName: 'commonsClient',
  );

  getIt.registerLazySingleton<TopicsRemoteDataSource>(
        () => TopicsRemoteDataSourceImpl(
      getIt<BaseClient>(instanceName: 'commonsClient'),
    ),
  );

  getIt.registerLazySingleton<TopicsRepository>(
        () => TopicsRepositoryImpl(getIt<TopicsRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetTopicsUseCase>(
        () => GetTopicsUseCase(getIt<TopicsRepository>()),
  );

  getIt.registerLazySingleton<GetSubtopicsUseCase>(
        () => GetSubtopicsUseCase(getIt<TopicsRepository>()),
  );


  getIt.registerFactory<TopicsBloc>(
        () => TopicsBloc(getIt<GetTopicsUseCase>()),
  );

  getIt.registerFactory<SubtopicsBloc>(
        () => SubtopicsBloc(getIt<GetSubtopicsUseCase>()),
  );
}