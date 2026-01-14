import '../entities/agent_entity.dart';

abstract class HomeRepository {
  Future<List<AgentEntity>> getAgents();
}
