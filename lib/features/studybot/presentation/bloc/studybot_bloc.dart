import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:chatia/features/studybot/domain/usecases/ask_gemini_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'studybot_event.dart';
part 'studybot_state.dart';

class StudybotBloc extends Bloc<StudybotEvent, StudybotState> {
  final AskGeminiUseCase askGeminiUseCase;
  StudybotBloc({required this.askGeminiUseCase})
    : super(StudybotState.initial()) {
    on<StudybotEvent>((event, emit) async {
      if (event is AskGeminiEvent) {
        await _onAskGeminiEvent(event, emit);
      }
    });
  }

  Future<void> _onAskGeminiEvent(
    AskGeminiEvent event,
    Emitter<StudybotState> emit,
  ) async {
    // log('Entra en _onAskGeminiEvent');
    emit(state.copyWith(loading: true));
    GeminiChatModel? currentChat = state.chat.fold(() => null, (r) => r);
    // log('El current chat es null? ${currentChat == null}');
    final newMessage = GeminiMessageModel(
      isUser: true,
      message: event.question,
      date: DateTime.now(),
    );
    if (currentChat != null) {
      currentChat = currentChat.copyWith(
        contents: [...currentChat.contents, newMessage],
      );
    }
    final updatedChat = currentChat ?? GeminiChatModel(contents: [newMessage]);


    final result = await askGeminiUseCase(updatedChat);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loading: false,
            askGeminiResult: optionOf(left(failure)),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            loading: false,
            chat: some(response),
            askGeminiResult: some(right(response)),
          ),
        );
      },
    );
  }
}
