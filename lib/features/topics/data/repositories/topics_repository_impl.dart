import 'package:commons/commons.dart';
import '../../domain/entities/subtopic_entity.dart';
import '../../domain/entities/subtopic_detail_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/topics_repository.dart';
import '../datasources/topics_datasource.dart';

class TopicsRepositoryImpl implements TopicsRepository {
  final TopicsRemoteDataSource _remoteDataSource;

  TopicsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<TopicEntity>>> getTopics() async {
    final result = await _remoteDataSource.getTopics();
    return switch (result) {
      Success(data: final data) => Success<List<TopicEntity>>(data),
      Failure(error: final error) => Failure<List<TopicEntity>>(error),
    };
  }

  @override
  Future<Result<List<SubtopicEntity>>> getSubtopics(String id) async {
    final result = await _remoteDataSource.getSubtopics(id);
    return switch (result) {
      Success(data: final data) => Success<List<SubtopicEntity>>(data),
      Failure(error: final error) => Failure<List<SubtopicEntity>>(error),
    };
  }

  @override
  Future<Result<List<SubtopicDetailEntity>>> getSubtopicDetail(
    String topicId,
    String subtopicId,
  ) async {
    final result = await _remoteDataSource.getSubtopicDetail(
      topicId,
      subtopicId,
    );
    return switch (result) {
      Success(data: final data) => Success<List<SubtopicDetailEntity>>(data),
      Failure(error: final error) => Failure<List<SubtopicDetailEntity>>(error),
    };
  }
}
