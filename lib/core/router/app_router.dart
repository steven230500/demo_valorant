import 'package:commons/commons.dart';
import 'package:demo_valorant/features/home/presentation/pages/home_page.dart';
import 'package:demo_valorant/features/selection/presentation/pages/selection_page.dart';
import 'package:demo_valorant/features/splash/presentation/pages/splash_page.dart';
import 'package:demo_valorant/features/topics/presentation/topics_router/topics_router.dart';
import 'package:go_router/go_router.dart';

class AppRouter implements BaseRoutes {
  static RouteName splash = RouteName(name: 'splash', path: '/');
  static RouteName selection = RouteName(name: 'selection', path: '/selection');
  static RouteName home = RouteName(name: 'home', path: '/home');
  static RouteName topics = TopicsRouter.topics;

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: splash.path,
      name: splash.name,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: selection.path,
      name: selection.name,
      builder: (context, state) => const SelectionPage(),
    ),
    GoRoute(
      path: home.path,
      name: home.name,
      builder: (context, state) => const HomePage(),
    ),

    ...TopicsRouter().routes,
  ];
}
