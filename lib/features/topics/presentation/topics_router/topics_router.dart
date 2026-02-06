import 'package:commons/router/router.dart';
import 'package:go_router/go_router.dart';

import '../pages/topics_page.dart';
import '../pages/subtopic_detail_page.dart';

class TopicsRouter extends BaseRoutes {
  static RouteName topics = RouteName(name: 'topics', path: '/topics');
  static RouteName subtopicDetail = RouteName(
    name: 'subtopicDetail',
    path: 'subtopics/:topicId/detail/:subtopicId',
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
            final topicId = state.pathParameters['topicId']!;
            final subtopicId = state.pathParameters['subtopicId']!;
            return SubtopicDetailPage(topicId: topicId, subtopicId: subtopicId);
          },
        ),
      ],
    ),
  ];
}
