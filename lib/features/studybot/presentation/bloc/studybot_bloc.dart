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
    emit(state.copyWith(loadingMessage: true));
    // Obtener el chat actual
    GeminiChatModel? currentChat = state.chat.fold(() => null, (r) => r);

    // Formular el mensaje recibido por el usuario dentro del estado
    final newMessage = GeminiMessageModel(
      isUser: true,
      message: event.question,
      date: DateTime.now(),
    );
    // Formular mensaje temporal de Pensando...
    final thinkingMessage = GeminiMessageModel(
      isUser: false,
      message: 'Pensando...',
      date: DateTime.now(),
    );
    // Actualizar el chat actual con el nuevo mensaje del usuario
    if (currentChat != null) {
      currentChat = currentChat.copyWith(
        contents: [...currentChat.contents, newMessage],
      );
    }
    // Si no hay chat actual, crear uno nuevo con el mensaje del usuario
    final updatedChat =
        currentChat ?? GeminiChatModel.createNew(contents: [newMessage]);
    // Emitir el estado con el chat actualizado mostrando el mensaje del usuario y el mensaje de Pensando...
    emit(
      state.copyWith(
        chat: some(
          updatedChat.copyWith(
            contents: [...updatedChat.contents, thinkingMessage],
          ),
        ),
      ),
    );
    // Llamar al caso de uso para obtener la respuesta de Gemini
    final result = await askGeminiUseCase(updatedChat);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loadingMessage: false,
            askGeminiResult: optionOf(left(failure)),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            loadingMessage: false,
            chat: some(response),
            askGeminiResult: some(right(response)),
          ),
        );
      },
    );
  }
}
