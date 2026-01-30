import 'package:commons/commons.dart';
import 'package:demo_valorant/features/create/data/models/topic_model.dart';
import '../entities/content_block_entity.dart';
import '../repositories/form_repository.dart';

class GetDetailSubtopicUseCase {
  final FormRepository repository;

  GetDetailSubtopicUseCase(this.repository);

  Future<Result<List<ContentBlockEntity>>> call(String topic, String subtopic) async {
    return await repository.getDetailSubtopic(topic, subtopic);
  }

  Future<Result<bool>> update(String topic, String subtopic, List<ContentBlockModel> blocks) async {
    return await repository.updateDetail(topic, subtopic, blocks);
  }
}
