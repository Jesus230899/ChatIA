part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int chatSelected;

  const HomeState({required this.chatSelected});

  HomeState copyWith({int? chatSelected}) =>
      HomeState(chatSelected: chatSelected ?? this.chatSelected);

  factory HomeState.initial() => HomeState(chatSelected: 0);

  @override
  List<Object> get props => [chatSelected];
}
