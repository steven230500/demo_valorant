import '../../../../core/network/base_client.dart';
import '../models/agent.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<List<AgentModel>> getAgents();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final BaseClient _client;

  HomeRemoteDataSourceImpl(this._client);

  @override
  Future<List<AgentModel>> getAgents() async {
    final response = await _client.get('/agents');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data
          .map((json) => AgentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
