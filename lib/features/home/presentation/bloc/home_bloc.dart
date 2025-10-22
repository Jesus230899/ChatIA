import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) {
      if (event is ChangeChatSelectedEvent) {
        emit(
          state.copyWith(
            chatSelected: event.value == state.chatSelected ? 0 : event.value,
          ),
        );
      }
    });
  }
}
