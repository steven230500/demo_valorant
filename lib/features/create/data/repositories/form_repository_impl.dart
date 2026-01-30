import 'package:commons/commons.dart';
import 'package:demo_valorant/features/create/data/models/topic_model.dart';
import '../../domain/entities/content_block_entity.dart';
import '../../domain/repositories/form_repository.dart';
import '../datasources/form_datasource.dart';

class FormRepositoryImpl implements FormRepository {
  final FormRemoteDataSource _remoteDataSource;

  FormRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ContentBlockEntity>>> getDetailSubtopic(String topic, String subtopic) async {
    final result = await _remoteDataSource.getDetailSubtopic(topic, subtopic);
    return switch (result) {
      Success(data: final data) => Success<List<ContentBlockEntity>>(data),
      Failure(error: final error) => Failure<List<ContentBlockEntity>>(error),
    };
  }

  @override
  Future<Result<bool>> updateDetail(String topic, String subtopic, List<ContentBlockModel> blocks) async {
    final result = await _remoteDataSource.updateDetail(topic, subtopic, blocks);
    return switch (result) {
      Success(data: final data) => Success<bool>(data),
      Failure(error: final error) => Failure<bool>(error),
    };
  }
}
