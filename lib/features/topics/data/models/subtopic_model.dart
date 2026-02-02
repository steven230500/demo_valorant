import '../../domain/entities/subtopic_entity.dart';

class SubtopicModel extends SubtopicEntity {
  const SubtopicModel({
    required super.id,
    required super.name,
    required super.icon,
    super.topicId,
  });

  factory SubtopicModel.fromJson(Map<String, dynamic> json) {
    return SubtopicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}
