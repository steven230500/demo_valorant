import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injectors/injector.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/topics_bloc/topics_bloc.dart';
import '../widgets/topic_accordion_widget.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double paddingHorizontal = (width * 0.5) / 2;

    return BlocProvider(
      create: (_) => getIt<TopicsBloc>()..add(GetTopicsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Topics')),
        body: BlocBuilder<TopicsBloc, TopicsState>(
          builder: (context, state) {
            if (state is TopicsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopicsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is TopicsLoaded) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width < 600 ? 16 : paddingHorizontal,
                ),
                child: ListView.builder(
                  itemCount: state.topics.length,
                  itemBuilder: (context, index) {
                    final topic = state.topics[index];
                    return TopicAccordionWidget(
                      key: ValueKey(topic.id),
                      topic: topic,
                      onTapInEmpty: () {},
                      onSubtopic: (value) {
                        context.pushNamed(
                          'subtopicDetail',
                          pathParameters: {
                            'topicId': topic.id,
                            'subtopicId': value.id,
                          },
                        );
                      },
                      onEditTopic: () {
                        context.pushNamed(
                          AppRouter.topicForm.name,
                          extra: {
                            'topicId': topic.id,
                            'initialName': topic.name,
                            'initialIcon': topic.icon,
                            'isSubtopic': false,
                          },
                        );
                      },
                      onAddSubtopic: () {
                        context.pushNamed(
                          AppRouter.topicForm.name,
                          extra: {'topicId': topic.id, 'isSubtopic': true},
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('No topics loaded'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed(
              AppRouter.topicForm.name,
              extra: {'isSubtopic': false},
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
