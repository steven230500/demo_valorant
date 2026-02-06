import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import '../../domain/entities/subtopic_detail_entity.dart';
import '../../domain/repositories/topics_repository.dart';

// Events
abstract class SubtopicDetailEvent {}

class GetSubtopicDetailEvent extends SubtopicDetailEvent {
  final String topicId;
  final String subtopicId;
  GetSubtopicDetailEvent({required this.topicId, required this.subtopicId});
}

// States
abstract class SubtopicDetailState {}

class SubtopicDetailInitial extends SubtopicDetailState {}

class SubtopicDetailLoading extends SubtopicDetailState {}

class SubtopicDetailLoaded extends SubtopicDetailState {
  final List<SubtopicDetailEntity> details;
  SubtopicDetailLoaded(this.details);
}

class SubtopicDetailError extends SubtopicDetailState {
  final String message;
  SubtopicDetailError(this.message);
}

// Bloc
class SubtopicDetailBloc
    extends Bloc<SubtopicDetailEvent, SubtopicDetailState> {
  final TopicsRepository _repository;

  SubtopicDetailBloc(this._repository) : super(SubtopicDetailInitial()) {
    on<GetSubtopicDetailEvent>(_onGetSubtopicDetail);
  }

  Future<void> _onGetSubtopicDetail(
    GetSubtopicDetailEvent event,
    Emitter<SubtopicDetailState> emit,
  ) async {
    emit(SubtopicDetailLoading());
    final result = await _repository.getSubtopicDetail(
      event.topicId,
      event.subtopicId,
    );

    switch (result) {
      case Success(data: final details):
        emit(SubtopicDetailLoaded(details));
      case Failure(error: final error):
        emit(SubtopicDetailError(error.toString()));
    }
  }
}
