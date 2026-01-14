import 'package:demo_valorant/core/error/app_error.dart';
import 'package:demo_valorant/core/error/result.dart';

import '../../../../core/network/base_client.dart';
import '../models/agent.dart';

abstract class HomeRemoteDataSource {
  Future<Result<List<AgentModel>>> getAgents();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final BaseClient _client;

  HomeRemoteDataSourceImpl(this._client);

  @override
  Future<Result<List<AgentModel>>> getAgents() async {
    final result = await _client.get('/agents');

    return switch (result) {
      Success(data: final response) => _mapResponse(response),
      Failure(error: final error) => Failure(error),
    };
  }

  Result<List<AgentModel>> _mapResponse(response) {
    try {
      final List<dynamic> data = response.data['data'];

      final agents = data
          .map(
            (json) => AgentModel.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();

      return Success(agents);
    } catch (e) {
      return Failure(
        const UnknownError('Error al parsear agentes'),
      );
    }
  }
}