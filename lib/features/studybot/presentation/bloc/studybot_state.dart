part of 'studybot_bloc.dart';

class StudybotState extends Equatable {
  final bool loading;
  final Option<GeminiChatModel> chat;
  final Option<Either<OperationFailure, GeminiChatModel>> askGeminiResult;

  const StudybotState({
    required this.loading,
    required this.chat,
    required this.askGeminiResult,
  });

  StudybotState copyWith({
    bool? loading,
    Option<GeminiChatModel>? chat,
    Option<Either<OperationFailure, GeminiChatModel>>? askGeminiResult,
  }) => StudybotState(
    loading: loading ?? this.loading,
    chat: chat ?? this.chat,
    askGeminiResult: askGeminiResult ?? this.askGeminiResult,
  );

  factory StudybotState.initial() =>
      StudybotState(loading: false, chat: none(), askGeminiResult: none());

  @override
  List<Object> get props => [loading, chat, askGeminiResult];
}
