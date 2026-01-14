import '../../domain/entities/agent_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AgentEntity>> getAgents() async {
    return await _remoteDataSource.getAgents();
  }
}
