import 'package:commons/commons.dart';
import '../../data/models/topic_model.dart';
import '../entities/content_block_entity.dart';

abstract class FormRepository {
  Future<Result<List<ContentBlockEntity>>> getDetailSubtopic(
    String topic,
    String subtopic,
  );
  Future<Result<bool>> updateDetail(
    String topic,
    String subtopic,
    List<ContentBlockModel> blocks,
  );
  Future<Result<bool>> deleteBlock(
    String topic,
    String subtopic,
    String blockId,
  );
  Future<Result<bool>> createTopic(String name, String icon);
  Future<Result<bool>> editTopic(String id, String name, String icon);
  Future<Result<bool>> createSubtopic(String topicId, String name, String icon);
  Future<Result<bool>> editSubtopic(
    String topicId,
    String subtopicId,
    String name,
    String icon,
  );
}
