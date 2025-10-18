part of 'studybot_bloc.dart';

class StudybotState extends Equatable {
  final bool loadingMessage;
  final Option<GeminiChatModel> chat;
  final Option<Either<OperationFailure, GeminiChatModel>> askGeminiResult;

  const StudybotState({
    required this.loadingMessage,
    required this.chat,
    required this.askGeminiResult,
  });

  StudybotState copyWith({
    bool? loadingMessage,
    Option<GeminiChatModel>? chat,
    Option<Either<OperationFailure, GeminiChatModel>>? askGeminiResult,
  }) => StudybotState(
    loadingMessage: loadingMessage ?? this.loadingMessage,
    chat: chat ?? this.chat,
    askGeminiResult: askGeminiResult ?? this.askGeminiResult,
  );

  factory StudybotState.initial() =>
      StudybotState(loadingMessage: false, chat: none(), askGeminiResult: none());

  @override
  List<Object> get props => [loadingMessage, chat, askGeminiResult];
}
