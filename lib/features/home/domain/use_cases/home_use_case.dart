import 'package:demo_valorant/core/error/result.dart';

import '../entities/agent_entity.dart';
import '../repositories/home_repository.dart';

class HomeUseCase {
  final HomeRepository homeRepository;

  HomeUseCase({required this.homeRepository});

  Future<Result<List<AgentEntity>>> getAgents() async {
    return await homeRepository.getAgents();
  }
}