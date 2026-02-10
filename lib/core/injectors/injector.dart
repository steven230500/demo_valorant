import 'package:demo_valorant/features/home/injectors/home_injector.dart';
import 'package:demo_valorant/features/topics/injectors/topics_injector.dart';
import 'package:get_it/get_it.dart';

import '../router/router_injector.dart';

import 'package:demo_valorant/features/auth/authentication/injectors/authentication_injector.dart';

final GetIt getIt = GetIt.instance;

void initDependencies() async{
  homeInjector(getIt);
  topicsInjector(getIt);
  authenticationInjector(getIt);
  routerInjector(getIt);
}
