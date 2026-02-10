part of 'topic_form_bloc.dart';

sealed class TopicFormEvent extends Equatable {
  const TopicFormEvent();

  @override
  List<Object> get props => [];
}

class CreateTopicEvent extends TopicFormEvent {
  final String name;
  final String icon;

  const CreateTopicEvent({required this.name, required this.icon});

  @override
  List<Object> get props => [name, icon];
}

class EditTopicEvent extends TopicFormEvent {
  final String id;
  final String name;
  final String icon;

  const EditTopicEvent({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [id, name, icon];
}

class CreateSubtopicEvent extends TopicFormEvent {
  final String topicId;
  final String name;
  final String icon;

  const CreateSubtopicEvent({
    required this.topicId,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [topicId, name, icon];
}

class EditSubtopicEvent extends TopicFormEvent {
  final String topicId;
  final String subtopicId;
  final String name;
  final String icon;

  const EditSubtopicEvent({
    required this.topicId,
    required this.subtopicId,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [topicId, subtopicId, name, icon];
}
