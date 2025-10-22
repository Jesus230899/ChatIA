part of 'studybot_bloc.dart';

class StudybotState extends Equatable {
  final bool loadingMessage;
  final Option<GeminiChatModel> chat;
  final List<GeminiChatModel> chats;
  final Option<Either<OperationFailure, GeminiChatModel>> askGeminiResult;

  const StudybotState({
    required this.loadingMessage,
    required this.chat,
    required this.chats,
    required this.askGeminiResult,
  });

  StudybotState copyWith({
    bool? loadingMessage,
    Option<GeminiChatModel>? chat,
    List<GeminiChatModel>? chats,
    int? tabIndex,
    Option<Either<OperationFailure, GeminiChatModel>>? askGeminiResult,
  }) => StudybotState(
    loadingMessage: loadingMessage ?? this.loadingMessage,
    chat: chat ?? this.chat,
    chats: chats ?? this.chats,
    askGeminiResult: askGeminiResult ?? this.askGeminiResult,
  );

  factory StudybotState.initial() => StudybotState(
    loadingMessage: false,
    chat: none(),
    chats: [],
    askGeminiResult: none(),
  );

  @override
  List<Object> get props => [loadingMessage, chat, chats, askGeminiResult];
}
