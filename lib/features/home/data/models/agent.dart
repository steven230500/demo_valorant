import '../../domain/entities/agent_entity.dart';

class AgentModel extends AgentEntity {
  const AgentModel({
    required super.uuid,
    required super.displayName,
    required super.displayIcon,
    required super.description,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      uuid: json['uuid'] ?? '',
      displayName: json['displayName'] ?? '',
      displayIcon: json['displayIcon'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
