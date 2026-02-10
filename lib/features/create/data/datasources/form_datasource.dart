import 'package:commons/commons.dart';
import '../models/topic_model.dart';

abstract class FormRemoteDataSource {
  Future<Result<List<ContentBlockModel>>> getDetailSubtopic(
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

class FormRemoteDataSourceImpl implements FormRemoteDataSource {
  final BaseClient _client;

  FormRemoteDataSourceImpl(this._client);

  @override
  Future<Result<bool>> updateDetail(
    String topic,
    String subtopic,
    List<ContentBlockModel> blocks,
  ) async {
    final result = await _client.post(
      '/update-detail',
      data: {
        "topicId": topic,
        "subtopicId": subtopic,
        "blocks": blocks.map((e) => e.toJson(e)).toList(),
      },
    );

    return switch (result) {
      Success(data: final _) => Success(true),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<bool>> deleteBlock(
    String topic,
    String subtopic,
    String blockId,
  ) async {
    final result = await _client.post(
      '/delete-block-detail',
      data: {"topicId": topic, "subtopicId": subtopic, "blockId": blockId},
    );

    return switch (result) {
      Success(data: final _) => Success(true),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<List<ContentBlockModel>>> getDetailSubtopic(
    String topic,
    String subtopic,
  ) async {
    final result = await _client.post(
      '/subtopic-detail',
      data: {"topicId": topic, "subtopicId": subtopic, "isAdmin": true},
    );

    return switch (result) {
      Success(data: final response) => _mapResponse(response),
      Failure(error: final error) => Failure(error),
    };
  }

  Result<List<ContentBlockModel>> _mapResponse(response) {
    try {
      final List<dynamic> data = response.data; // List root in JSON

      final topics = data
          .map(
            (json) => ContentBlockModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return Success(topics);
    } catch (e) {
      return Failure(const UnknownError('Error al parsear topics'));
    }
  }

  @override
  Future<Result<bool>> createTopic(String name, String icon) async {
    final result = await _client.post(
      '/topics-subtopics',
      data: {
        "data": {"icon": icon, "name": name},
        "isSubtopic": false,
      },
    );

    return switch (result) {
      Success(data: final _) => Success(true),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<bool>> editTopic(String id, String name, String icon) async {
    final result = await _client.post(
      '/topics-subtopics',
      data: {
        "data": {"icon": icon, "name": name},
        "isSubtopic": false,
        "topicId": id,
      },
    );

    return switch (result) {
      Success(data: final _) => Success(true),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<bool>> createSubtopic(
    String topicId,
    String name,
    String icon,
  ) async {
    final result = await _client.post(
      '/topics-subtopics',
      data: {
        "data": {"icon": icon, "name": name},
        "isSubtopic": true,
        "topicId": topicId,
      },
    );

    return switch (result) {
      Success(data: final _) => Success(true),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<bool>> editSubtopic(
    String topicId,
    String subtopicId,
    String name,
    String icon,
  ) async {
    final result = await _client.post(
      '/topics-subtopics',
      data: {
        "data": {"icon": icon, "name": name},
        "isSubtopic": true,
        "topicId": topicId,
        "subtopicId": subtopicId,
      },
    );

    return switch (result) {
      Success(data: final _) => Success(true),
      Failure(error: final error) => Failure(error),
    };
  }
}
