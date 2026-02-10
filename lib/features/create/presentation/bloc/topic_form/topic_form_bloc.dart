import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/form_repository.dart';

part 'topic_form_event.dart';
part 'topic_form_state.dart';

class TopicFormBloc extends Bloc<TopicFormEvent, TopicFormState> {
  final FormRepository _repository;

  TopicFormBloc(this._repository) : super(TopicFormInitial()) {
    on<CreateTopicEvent>(_onCreateTopic);
    on<EditTopicEvent>(_onEditTopic);
    on<CreateSubtopicEvent>(_onCreateSubtopic);
    on<EditSubtopicEvent>(_onEditSubtopic);
  }

  Future<void> _onCreateTopic(
    CreateTopicEvent event,
    Emitter<TopicFormState> emit,
  ) async {
    emit(TopicFormLoading());
    final result = await _repository.createTopic(event.name, event.icon);
    _handleResult(result, emit);
  }

  Future<void> _onEditTopic(
    EditTopicEvent event,
    Emitter<TopicFormState> emit,
  ) async {
    emit(TopicFormLoading());
    final result = await _repository.editTopic(
      event.id,
      event.name,
      event.icon,
    );
    _handleResult(result, emit);
  }

  Future<void> _onCreateSubtopic(
    CreateSubtopicEvent event,
    Emitter<TopicFormState> emit,
  ) async {
    emit(TopicFormLoading());
    final result = await _repository.createSubtopic(
      event.topicId,
      event.name,
      event.icon,
    );
    _handleResult(result, emit);
  }

  Future<void> _onEditSubtopic(
    EditSubtopicEvent event,
    Emitter<TopicFormState> emit,
  ) async {
    emit(TopicFormLoading());
    final result = await _repository.editSubtopic(
      event.topicId,
      event.subtopicId,
      event.name,
      event.icon,
    );
    _handleResult(result, emit);
  }

  void _handleResult(Result<bool> result, Emitter<TopicFormState> emit) {
    switch (result) {
      case Success():
        emit(TopicFormSuccess());
        break;
      case Failure(error: final error):
        emit(TopicFormError(error.message));
        break;
    }
  }
}
