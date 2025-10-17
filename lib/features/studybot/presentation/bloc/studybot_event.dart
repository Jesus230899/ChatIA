part of 'studybot_bloc.dart';

sealed class StudybotEvent extends Equatable {
  const StudybotEvent();

  @override
  List<Object> get props => [];
}

class AskGeminiEvent extends StudybotEvent {
  final String question;

  const AskGeminiEvent({required this.question});

  @override
  List<Object> get props => [question];
}


