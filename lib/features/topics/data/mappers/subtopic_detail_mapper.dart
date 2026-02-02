import 'package:commons/services/exceptions/app_exception.dart';
import 'package:commons/services/exceptions/result.dart';
import '../../domain/entities/subtopic_detail_entity.dart';

class SubtopicDetailMapper {
  static Result<List<SubtopicDetailEntity>> mapper(response) {
    try {
      final List<dynamic> data = response.data;
      final details = data.map((json) {
        return SubtopicDetailEntity(
          id: json['id'] as String,
          type: _mapType(json['type'] as String),
          content: json['content'] as String,
          order: json['order'] as int,
        );
      }).toList();

      return Success(details);
    } catch (e) {
      return Failure(const UnknownError('Error al parsear subtopic detail'));
    }
  }

  static SubtopicDetailType _mapType(String type) {
    return switch (type) {
      'title' => SubtopicDetailType.title,
      'subtitle' => SubtopicDetailType.subtitle,
      'paragraph' => SubtopicDetailType.paragraph,
      'image' => SubtopicDetailType.image,
      'code' => SubtopicDetailType.code,
      'url' => SubtopicDetailType.url,
      _ => SubtopicDetailType.unknown,
    };
  }
}
