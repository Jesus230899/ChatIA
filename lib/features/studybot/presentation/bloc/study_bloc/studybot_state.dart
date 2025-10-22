part of 'studybot_bloc.dart';

class StudybotState extends Equatable {
  final bool loadingMessage;
  final Option<GeminiChatModel> chat;
  final List<GeminiChatModel> chats;
  final int tabIndex;
  final Option<Either<OperationFailure, GeminiChatModel>> askGeminiResult;

  const StudybotState({
    required this.loadingMessage,
    required this.chat,
    required this.chats,
    required this.tabIndex,
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
    tabIndex: tabIndex ?? this.tabIndex,
    askGeminiResult: askGeminiResult ?? this.askGeminiResult,
  );

  factory StudybotState.initial() => StudybotState(
    loadingMessage: false,
    chat: none(),
    chats: [],
    tabIndex: 0,
    askGeminiResult: none(),
  );

  @override
  List<Object> get props => [loadingMessage, chat, chats, tabIndex, askGeminiResult];
}
