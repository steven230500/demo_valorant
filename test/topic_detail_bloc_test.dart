import 'package:commons/commons.dart';
import 'package:demo_valorant/features/topics/domain/entities/subtopic_entity.dart';
import 'package:demo_valorant/features/topics/domain/entities/topic_detail_entity.dart';
import 'package:demo_valorant/features/topics/domain/entities/topic_entity.dart';
import 'package:demo_valorant/features/topics/domain/repositories/topics_repository.dart';
import 'package:demo_valorant/features/topics/presentation/bloc/topic_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTopicsRepository implements TopicsRepository {
  @override
  Future<Result<List<TopicEntity>>> getTopics() async {
    throw UnimplementedError();
  }

  @override
  Future<Result<TopicDetailEntity>> getTopicDetail(String id) async {
    if (id == 'error') {
      return Failure(const UnknownError('Error'));
    }
    return Success(
      const TopicDetailEntity(
        id: '1',
        name: 'Test',
        icon: 'icon',
        description: 'desc',
        bannerImage: 'banner',
        gallery: [],
      ),
    );
  }

  @override
  Future<Result<List<SubtopicEntity>>> getSubtopics(String id) {
    // TODO: implement getSubtopics
    throw UnimplementedError();
  }
}

void main() {
  late TopicsRepository repository;
  late TopicDetailBloc bloc;

  setUp(() {
    repository = MockTopicsRepository();
    bloc = TopicDetailBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  test(
    'emits [TopicDetailLoading, TopicDetailLoaded] when successful',
    () async {
      bloc.add(GetTopicDetailEvent('1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([isA<TopicDetailLoading>(), isA<TopicDetailLoaded>()]),
      );
    },
  );

  test('emits [TopicDetailLoading, TopicDetailError] when failure', () async {
    bloc.add(GetTopicDetailEvent('error'));

    await expectLater(
      bloc.stream,
      emitsInOrder([isA<TopicDetailLoading>(), isA<TopicDetailError>()]),
    );
  });
}
