import 'package:commons/services/exceptions/app_exception.dart';
import 'package:commons/services/exceptions/result.dart';

import '../models/topic_model.dart';

class TopicsMapper {

  static Result<List<TopicModel>> mapper(response) {
    try {
      final List<dynamic> data = response.data;

      final topics = data
          .map((json) => TopicModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Success(topics);
    } catch (e) {
      return Failure(const UnknownError('Error al parsear topics'));
    }
  }
}