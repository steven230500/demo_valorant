part of 'topics_bloc.dart';

sealed class TopicsState extends Equatable {
  const TopicsState();

  @override
  List<Object> get props => [];
}

final class TopicsInitial extends TopicsState {}

final class TopicsLoading extends TopicsState {}

final class TopicsLoaded extends TopicsState {
  final List<TopicEntity> topics;

  const TopicsLoaded(this.topics);

  @override
  List<Object> get props => [topics];
}

final class TopicsError extends TopicsState {
  final String message;

  const TopicsError(this.message);

  @override
  List<Object> get props => [message];
}
