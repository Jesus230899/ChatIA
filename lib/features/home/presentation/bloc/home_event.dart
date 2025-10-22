part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeChatSelectedEvent extends HomeEvent {
  final int value;

  const ChangeChatSelectedEvent({required this.value});

  @override
  List<Object> get props => [value];
}
