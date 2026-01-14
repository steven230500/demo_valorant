import 'package:bloc/bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
  }

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final agents = await _repository.getAgents();
      emit(HomeLoaded(agents));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
