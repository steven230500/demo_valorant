import 'package:bloc/bloc.dart';
import 'package:demo_valorant/features/home/domain/use_cases/home_use_case.dart';
import '../../../../core/error/result.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUseCase _useCase;

  HomeBloc(this._useCase) : super(HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
  }

  Future<void> _onHomeStarted(
      HomeStarted event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());

    final result = await _useCase.getAgents();

    switch (result) {
      case Success(data: final agents):
        emit(HomeLoaded(agents));
        break;

      case Failure(error: final error):
        emit(HomeError(error.message));
        break;
    }
  }
}
