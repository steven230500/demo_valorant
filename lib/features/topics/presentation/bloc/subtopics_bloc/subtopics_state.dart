part of 'subtopics_bloc.dart';

sealed class SubtopicsState extends Equatable {
  const SubtopicsState();

  @override
  List<Object> get props => [];
}

final class SubtopicsInitial extends SubtopicsState {}

final class SubtopicsLoading extends SubtopicsState {}

final class SubtopicsLoaded extends SubtopicsState {
  final List<SubtopicEntity> subtopics;

  const SubtopicsLoaded(this.subtopics);

  @override
  List<Object> get props => [subtopics];
}

final class SubtopicsError extends SubtopicsState {
  final String message;

  const SubtopicsError(this.message);

  @override
  List<Object> get props => [message];
}

final class SubtopicsIsEmpty extends SubtopicsState {}
