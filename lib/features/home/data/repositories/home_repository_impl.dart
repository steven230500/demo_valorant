import 'package:demo_valorant/core/error/result.dart';
import 'package:demo_valorant/features/home/domain/entities/agent_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<AgentEntity>>> getAgents() async {
    return await _remoteDataSource.getAgents();
  }
}
