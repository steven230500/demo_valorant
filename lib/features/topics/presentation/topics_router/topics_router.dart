import 'package:commons/router/router.dart';
import 'package:go_router/go_router.dart';

import '../pages/topics_page.dart';

class TopicsRouter extends BaseRoutes {
  static RouteName topics = RouteName(name: 'topics', path: '/topics');

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: topics.path,
      name: topics.name,
      builder: (context, state) => const TopicsPage(),
    ),
  ];
}
