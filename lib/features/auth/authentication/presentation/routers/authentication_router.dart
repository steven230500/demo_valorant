import 'package:commons/router/router.dart';
import 'package:demo_valorant/features/auth/authentication/presentation/pages/authentication_page.dart';
import 'package:go_router/go_router.dart';



class AuthenticationRouter extends BaseRoutes {
  static RouteName login = RouteName(name: 'login', path: '/login');

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: login.path,
      name: login.name,
      builder: (context, state) => const AuthenticationPage(),
    ),
  ];
}
