import '../../domain/entities/content_block_entity.dart';

class ContentBlockModel extends ContentBlockEntity {
  const ContentBlockModel({
    required super.id,
    required super.type,
    required super.content,
    required super.order,
  });

  factory ContentBlockModel.fromJson(Map<String, dynamic> json) {
    return ContentBlockModel(
      id: json['id'] as String,
      type: convert(json['type'] as String),
      content: json['content'] as String,
      order: (json['order'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson(ContentBlockModel data) {
    return {
      "id": data.id,
      "type": convertToString(data.type),
      "content": data.content,
      "order": data.order,
    };
  }
}

ContentBlockType convert(String value) {
  switch(value) {
    case "title":
    return ContentBlockType.title;
    case "subtitle":
    return ContentBlockType.subtitle;
    case "paragraph":
    return ContentBlockType.paragraph;
    case "image":
    return ContentBlockType.image;
    case "url":
    return ContentBlockType.url;
    case "code":
    return ContentBlockType.code;
  }
  return ContentBlockType.paragraph;
}

String convertToString(ContentBlockType value) {
  switch(value) {
    case ContentBlockType.title:
      return "title";
    case ContentBlockType.subtitle:
      return "subtitle";
    case ContentBlockType.paragraph:
      return "paragraph";
    case ContentBlockType.image:
      return "image";
    case ContentBlockType.url:
      return "url";
    case ContentBlockType.code:
      return "code";
  }
}