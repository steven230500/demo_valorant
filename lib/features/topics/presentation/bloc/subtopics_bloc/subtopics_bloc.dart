import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/subtopic_entity.dart';
import '../../../domain/use_cases/get_subtopics_use_case.dart';
import 'package:commons/presenter/bloc/base_bloc.dart';

part 'subtopics_event.dart';

part 'subtopics_state.dart';

class SubtopicsBloc extends BaseBloc<SubtopicsEvent, SubtopicsState> {
  final GetSubtopicsUseCase _useCase;

  SubtopicsBloc(this._useCase) : super(SubtopicsInitial()) {
    on<SubtopicsEvent>(_onGetTopics);
  }

  Future<void> _onGetTopics(
    SubtopicsEvent event,
    Emitter<SubtopicsState> emit,
  ) async {
    emit(SubtopicsLoading());
    final result = await _useCase(event.id);

    switch (result) {
      case Success(data: final subtopics):
        if (subtopics.isEmpty) {
          emit(SubtopicsIsEmpty());

          return;
        }

        emit(SubtopicsLoaded(subtopics));
        break;
      case Failure(error: final error):
        emit(SubtopicsError(error.message));
        break;
    }
  }
}
