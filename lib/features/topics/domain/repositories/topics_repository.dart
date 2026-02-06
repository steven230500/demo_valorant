import 'package:commons/commons.dart';
import '../entities/subtopic_entity.dart';
import '../entities/subtopic_detail_entity.dart';
import '../entities/topic_entity.dart';

abstract class TopicsRepository {
  Future<Result<List<TopicEntity>>> getTopics();
  Future<Result<List<SubtopicEntity>>> getSubtopics(String id);
  Future<Result<List<SubtopicDetailEntity>>> getSubtopicDetail(
    String topicId,
    String subtopicId,
  );
}
