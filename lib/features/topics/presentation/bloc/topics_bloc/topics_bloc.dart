import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/topic_entity.dart';
import '../../../domain/use_cases/get_topics_use_case.dart';
import 'package:commons/presenter/bloc/base_bloc.dart';

part 'topics_event.dart';
part 'topics_state.dart';

class TopicsBloc extends BaseBloc<TopicsEvent, TopicsState> {
  final GetTopicsUseCase _useCase;

  TopicsBloc(this._useCase) : super(TopicsInitial()) {
    on<GetTopicsEvent>(_onGetTopics);
  }

  Future<void> _onGetTopics(
    GetTopicsEvent event,
    Emitter<TopicsState> emit,
  ) async {
    emit(TopicsLoading());
    final result = await _useCase();

    switch (result) {
      case Success(data: final topics):
        emit(TopicsLoaded(topics));
        break;
      case Failure(error: final error):
        emit(TopicsError(error.message));
        break;
    }
  }
}
