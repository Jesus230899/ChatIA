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

class SaveChatEvent extends StudybotEvent {}

class GetAllChatsEvent extends StudybotEvent {}

class DeleteAllChatsEvent extends StudybotEvent {}

class ChangeTabEvent extends StudybotEvent {
  final int tabIndex;

  const ChangeTabEvent({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}

class NewChatEvent extends StudybotEvent {}
