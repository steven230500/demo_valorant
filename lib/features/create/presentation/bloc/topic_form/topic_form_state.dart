part of 'topic_form_bloc.dart';

sealed class TopicFormState extends Equatable {
  const TopicFormState();

  @override
  List<Object> get props => [];
}

final class TopicFormInitial extends TopicFormState {}

final class TopicFormLoading extends TopicFormState {}

final class TopicFormSuccess extends TopicFormState {}

final class TopicFormError extends TopicFormState {
  final String message;

  const TopicFormError(this.message);

  @override
  List<Object> get props => [message];
}
