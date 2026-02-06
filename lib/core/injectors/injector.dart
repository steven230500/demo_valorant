import 'package:demo_valorant/features/home/data/datasources/home_datasource.dart';
import 'package:demo_valorant/features/home/data/repositories/home_repository_impl.dart';
import 'package:demo_valorant/features/home/domain/repositories/home_repository.dart';
import 'package:demo_valorant/features/home/domain/use_cases/home_use_case.dart';
import 'package:demo_valorant/features/home/injectors/home_injector.dart';
import 'package:demo_valorant/features/topics/data/datasources/topics_datasource.dart';
import 'package:demo_valorant/features/topics/data/repositories/topics_repository_impl.dart';
import 'package:demo_valorant/features/topics/domain/repositories/topics_repository.dart';
import 'package:demo_valorant/features/topics/domain/use_cases/get_topics_use_case.dart';
import 'package:demo_valorant/core/router/app_router.dart';
import 'package:demo_valorant/features/topics/injectors/topics_injector.dart';
import 'package:demo_valorant/features/topics/presentation/bloc/topics_bloc/topics_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:commons/commons.dart';
import 'package:go_router/go_router.dart';

import '../router/router_injector.dart';

final GetIt getIt = GetIt.instance;

void initDependencies() {
  homeInjector(getIt);

  topicsInjector(getIt);

  routerInjector(getIt);
}
