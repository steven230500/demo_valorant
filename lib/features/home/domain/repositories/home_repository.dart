import 'package:demo_valorant/core/error/result.dart';
import '../entities/agent_entity.dart';

abstract class HomeRepository {
  Future<Result<List<AgentEntity>>> getAgents();
}
