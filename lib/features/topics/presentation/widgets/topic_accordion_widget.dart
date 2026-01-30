import 'package:demo_valorant/core/injectors/injector.dart';
import 'package:demo_valorant/features/topics/domain/entities/topic_entity.dart';
import 'package:demo_valorant/features/topics/presentation/bloc/subtopics_bloc/subtopics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/subtopic_entity.dart';
import '../atoms_design/organisms/topic_accordion.dart';

class TopicAccordionWidget extends StatelessWidget {
  final TopicEntity topic;
  final VoidCallback? onTapInEmpty;
  final ValueChanged<SubtopicEntity>? onSubtopic;

  const TopicAccordionWidget({
    super.key,
    required this.topic,
    this.onTapInEmpty,
    this.onSubtopic,
  });

  void _handleTap(
    BuildContext context,
    SubtopicsBloc bloc,
    SubtopicsState state,
  ) {
    if (state is SubtopicsInitial) {
      bloc.add(GetSubtopicsEvent(id: topic.id));
    } else if (state is SubtopicsIsEmpty) {
      onTapInEmpty?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtopicsBloc = getIt<SubtopicsBloc>();

    return BlocProvider(
      create: (context) => subtopicsBloc,
      child: BlocConsumer<SubtopicsBloc, SubtopicsState>(
        listener: (context, state) {
          if (state is SubtopicsIsEmpty) {
            onTapInEmpty?.call();
          }
        },
        builder: (context, state) {
          return TopicAccordion(
            onSubtopic: onSubtopic,
            topic: topic,
            isLoading: state is SubtopicsLoading,
            subtopics: state is SubtopicsLoaded ? state.subtopics : [],
            errorMessage: state is SubtopicsError ? state.message : null,
            shouldExpand: state is SubtopicsLoaded,
            onTap: () => _handleTap(context, subtopicsBloc, state),
          );
        },
      ),
    );
  }
}
