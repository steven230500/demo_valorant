import 'package:commons/services/exceptions/result.dart';

import '../entities/subtopic_entity.dart';
import '../repositories/topics_repository.dart';

class GetSubtopicsUseCase {
  final TopicsRepository repository;

  GetSubtopicsUseCase(this.repository);

  Future<Result<List<SubtopicEntity>>> call(String id) async {
    return await repository.getSubtopics(id);
  }
}
