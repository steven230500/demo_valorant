import 'package:equatable/equatable.dart';

enum ContentBlockType {
  title,
  subtitle,
  paragraph,
  image,
  url,
  code,
}

class ContentBlockEntity extends Equatable {
  final String id;
  final ContentBlockType type;
  final String content;
  final int order;

  const ContentBlockEntity({
    required this.id,
    required this.type,
    required this.content,
    required this.order,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    content,
    order,
  ];
}
