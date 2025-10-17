part of 'studybot_bloc.dart';

class StudybotState extends Equatable {
  final bool loading;
  final String message;
  final Option<Either<OperationFailure, String>> askGeminiResult;

  const StudybotState({
    required this.loading,
    required this.message,
    required this.askGeminiResult,
  });

  StudybotState copyWith({
    bool? loading,
    String? message,
    Option<Either<OperationFailure, String>>? askGeminiResult,
  }) => StudybotState(
    loading: loading ?? this.loading,
    message: message ?? this.message,
    askGeminiResult: askGeminiResult ?? this.askGeminiResult,
  );

  factory StudybotState.initial() => StudybotState(
    loading: false,
    message: '',
    askGeminiResult: none(),
  );

  @override
  List<Object> get props => [loading, message, askGeminiResult];
}
