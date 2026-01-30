import 'package:commons/commons.dart';
import 'package:demo_valorant/features/home/presentation/pages/home_page.dart';
import 'package:demo_valorant/features/selection/presentation/pages/selection_page.dart';
import 'package:demo_valorant/features/splash/presentation/pages/splash_page.dart';
import 'package:demo_valorant/features/topics/domain/entities/topic_entity.dart';
import 'package:demo_valorant/features/topics/presentation/pages/topic_detail_page.dart';
import 'package:demo_valorant/features/topics/presentation/topics_router/topics_router.dart';
import 'package:go_router/go_router.dart';

import '../../features/create/presentation/pages/create_page.dart';
import '../../features/topics/domain/entities/subtopic_entity.dart';

class AppRouter implements BaseRoutes {
  static RouteName splash = RouteName(name: 'splash', path: '/');
  static RouteName selection = RouteName(name: 'selection', path: '/selection');
  static RouteName home = RouteName(name: 'home', path: '/home');
  static RouteName topics = TopicsRouter.topics;
  static RouteName create = RouteName(name: 'create', path: '/create');
  static RouteName topicDetail = RouteName(
    name: 'topicDetail',
    path: '/topics/:id',
  );

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
    GoRoute(
      path: create.path,
      name: create.name,
      builder: (context, state) {
        final data = state.extra! as Map<String, dynamic>;

        return CreatePage(
          topic: data['topic'] as TopicEntity,
          subtopic: data['subtopic'] as SubtopicEntity,
        );
      },
    ),
    GoRoute(
      path: topicDetail.path,
      name: topicDetail.name,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TopicDetailPage(id: id);
      },
    ),

    ...TopicsRouter().routes,
  ];
}
