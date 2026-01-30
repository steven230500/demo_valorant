import 'package:equatable/equatable.dart';

enum SubtopicDetailType {
  title,
  subtitle,
  paragraph,
  image,
  code,
  url,
  unknown,
}

class SubtopicDetailEntity extends Equatable {
  final String id;
  final SubtopicDetailType type;
  final String content;
  final int order;

  const SubtopicDetailEntity({
    required this.id,
    required this.type,
    required this.content,
    required this.order,
  });

  @override
  List<Object?> get props => [id, type, content, order];

  @override
  String toString() {
    return 'SubtopicDetailEntity(id: $id, type: $type, content: $content, order: $order)';
  }
}
