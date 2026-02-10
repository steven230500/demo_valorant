import 'package:commons/router/router.dart';
import 'package:demo_valorant/features/topics/domain/entities/subtopic_entity.dart';
import 'package:go_router/go_router.dart';

import '../pages/topics_page.dart';
import '../pages/subtopic_detail_page.dart';

class TopicsRouter extends BaseRoutes {
  static RouteName topics = RouteName(name: 'topics', path: '/topics');
  static RouteName subtopicDetail = RouteName(
    name: 'subtopicDetail',
    path: 'subtopicDetail',
  );

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: topics.path,
      name: topics.name,
      builder: (context, state) => const TopicsPage(),
      routes: [
        GoRoute(
          path: subtopicDetail.path,
          name: subtopicDetail.name,
          builder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>;
            final SubtopicEntity subtopic = extraData['subtopic'] as SubtopicEntity;

            return SubtopicDetailPage(subtopic: subtopic);
          },
        ),
      ],
    ),
  ];
}
