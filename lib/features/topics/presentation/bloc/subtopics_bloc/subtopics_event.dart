part of 'subtopics_bloc.dart';

sealed class SubtopicsEvent extends Equatable {
  final String id;
  const SubtopicsEvent({required this.id});

  @override
  List<Object> get props => [];
}

final class GetSubtopicsEvent extends SubtopicsEvent {
  const GetSubtopicsEvent({required super.id});
}
