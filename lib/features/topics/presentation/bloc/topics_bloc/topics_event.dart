part of 'topics_bloc.dart';

sealed class TopicsEvent extends Equatable {
  const TopicsEvent();

  @override
  List<Object> get props => [];
}

final class GetTopicsEvent extends TopicsEvent {}
