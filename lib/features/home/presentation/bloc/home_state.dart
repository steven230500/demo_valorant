import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<AgentEntity> agents;

  const HomeLoaded(this.agents);

  @override
  List<Object> get props => [agents];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
