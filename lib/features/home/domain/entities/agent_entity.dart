import 'package:equatable/equatable.dart';

class AgentEntity extends Equatable {
  final String uuid;
  final String displayName;
  final String displayIcon;
  final String description;

  const AgentEntity({
    required this.uuid,
    required this.displayName,
    required this.displayIcon,
    required this.description,
  });

  @override
  List<Object?> get props => [uuid, displayName, displayIcon, description];
}
