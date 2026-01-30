import 'package:demo_valorant/features/create/presentation/bloc/form/form_bloc.dart';
import 'package:demo_valorant/features/home/injectors/home_injector.dart';
import 'package:demo_valorant/features/topics/injectors/topics_injector.dart';
import 'package:get_it/get_it.dart';
import '../router/router_injector.dart';

final GetIt getIt = GetIt.instance;

void initDependencies() {
  homeInjector(getIt);
  topicsInjector(getIt);
  routerInjector(getIt);
}
