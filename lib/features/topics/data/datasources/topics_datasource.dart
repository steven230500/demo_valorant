import 'package:commons/commons.dart';
import '../../domain/entities/subtopic_entity.dart';
import '../mappers/subtopic_mapper.dart';
import '../mappers/topics_mapper.dart';
import '../models/topic_model.dart';
import '../../domain/entities/topic_detail_entity.dart';

abstract class TopicsRemoteDataSource {
  Future<Result<List<TopicModel>>> getTopics();
  Future<Result<TopicDetailEntity>> getTopicDetail(String id);
  Future<Result<List<SubtopicEntity>>> getSubtopics(String id);
}

class TopicsRemoteDataSourceImpl implements TopicsRemoteDataSource {
  final BaseClient _client;

  TopicsRemoteDataSourceImpl(this._client);

  @override
  Future<Result<List<TopicModel>>> getTopics() async {
    final result = await _client.get('/topics');

    return switch (result) {
      Success(data: final response) => _mapResponse(response),
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

  @override
  Future<Result<TopicDetailEntity>> getTopicDetail(String id) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock delay

    // Mock data based on ID
    return Success(
      TopicDetailEntity(
        id: id,
        name: 'Agent Details',
        icon:
        'https://media.valorant-api.com/agents/e370fa57-4757-3604-3648-499e1f642d3f/displayicon.png',
        description:
        'Role: Duelist\n\nEquipped with various cutting-edge tech, this agent is ready to strike at a moment\'s notice. Their abilities allow them to outmaneuver opponents and secure kills with precision.',
        bannerImage:
        'https://media.valorant-api.com/agents/e370fa57-4757-3604-3648-499e1f642d3f/fullportrait.png',
        gallery: [
          'https://media.valorant-api.com/agents/e370fa57-4757-3604-3648-499e1f642d3f/displayicon.png',
          'https://media.valorant-api.com/agents/add6443a-41bd-e414-f685-518d62a53eca/displayicon.png',
          'https://media.valorant-api.com/agents/f94c3b30-42be-e959-889c-5aa313dba261/displayicon.png',
        ],
      ),
    );
  }

  Result<List<TopicModel>> _mapResponse(response) {
    try {
      final List<dynamic> data = response.data; // List root in JSON

      final topics = data
          .map((json) => TopicModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Success(topics);
    } catch (e) {
      return Failure(const UnknownError('Error al parsear topics'));
    }
  }

}
