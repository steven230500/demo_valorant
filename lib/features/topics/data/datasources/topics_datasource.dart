import 'package:commons/commons.dart';
import '../../domain/entities/subtopic_entity.dart';
import '../mappers/subtopic_mapper.dart';
import '../mappers/topics_mapper.dart';
import '../models/topic_model.dart';

abstract class TopicsRemoteDataSource {
  Future<Result<List<TopicModel>>> getTopics();
  Future<Result<List<SubtopicEntity>>> getSubtopics(String id);
}

class TopicsRemoteDataSourceImpl implements TopicsRemoteDataSource {
  final BaseClient _client;

  TopicsRemoteDataSourceImpl(this._client);

  @override
  Future<Result<List<TopicModel>>> getTopics() async {
    final result = await _client.get('/topics');

    return switch (result) {
      Success(data: final response) => TopicsMapper.mapper(response),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<List<SubtopicEntity>>> getSubtopics(String id) async {
    final result = await _client.post('/subtopics', data: {
      "topicId": id,
    });

    return switch (result) {
      Success(data: final response) => SubtopicMapper.mapper(response),
      Failure(error: final error) => Failure(error),
    };
  }
}
