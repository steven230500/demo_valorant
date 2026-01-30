import 'package:commons/commons.dart';
import '../../data/models/topic_model.dart';
import '../entities/content_block_entity.dart';

abstract class FormRepository {
  Future<Result<List<ContentBlockEntity>>> getDetailSubtopic(String topic, String subtopic);
  Future<Result<bool>> updateDetail(String topic, String subtopic, List<ContentBlockModel> blocks);
}
