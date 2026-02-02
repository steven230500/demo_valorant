import 'package:equatable/equatable.dart';

class SubtopicEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String topicId;

  const SubtopicEntity({
    required this.id,
    required this.name,
    required this.icon,
    this.topicId = '',
  });

  @override
  List<Object?> get props => [id, name, icon];
}
