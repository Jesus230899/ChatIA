import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/core/utils/text_cleanners.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:chatia/features/studybot/domain/usecases/ask_gemini_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/get_all_chat_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/get_chat_name_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/save_chat_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'studybot_event.dart';
part 'studybot_state.dart';

class StudybotBloc extends Bloc<StudybotEvent, StudybotState> {
  final AskGeminiUseCase askGeminiUseCase;
  final SaveChatUsecase saveChatUsecase;
  final GetAllChatsUsecase getAllChatsUsecase;
  final GetChatNameUsecase getChatNameUsecase;
  StudybotBloc({
    required this.askGeminiUseCase,
    required this.saveChatUsecase,
    required this.getAllChatsUsecase,
    required this.getChatNameUsecase,
  }) : super(StudybotState.initial()) {
    on<StudybotEvent>((event, emit) async {
      if (event is AskGeminiEvent) {
        await _onAskGeminiEvent(event, emit);
      }
      if (event is SaveChatEvent) {
        await _onSaveChatEvent(event, emit);
      }
      if (event is GetAllChatsEvent) {
        await _onGetAllChatsEvent(event, emit);
      }
      if (event is ChangeTabEvent) {
        await _onChangeTabEvent(event, emit);
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
      date: DateTime.now().toString(),
    );
    // Formular mensaje temporal de Pensando...
    final thinkingMessage = GeminiMessageModel(
      isUser: false,
      message: 'Pensando...',
      date: DateTime.now().toString(),
    );
    // Actualizar el chat actual con el nuevo mensaje del usuario
    if (currentChat != null) {
      currentChat = currentChat.copyWith(
        contents: [...currentChat.contents, newMessage],
      );
    }
    // Si no hay chat actual, crear uno nuevo con el mensaje del usuario
    // final updatedChat =
    //     currentChat ?? GeminiChatModel(contents: [newMessage], id: Uuid().v4());

    final updatedChat =
        currentChat ?? GeminiChatModel(contents: [newMessage], id: Uuid().v4());

    // Emitir el estado con el chat actualizado mostrando el mensaje del usuario y el mensaje de Pensando...
    emit(
      state.copyWith(
        chat: some(
          updatedChat.copyWith(
            contents: [...updatedChat.contents, thinkingMessage],
            id: updatedChat.id,
          ),
        ),
      ),
    );
    // Llamar al caso de uso para obtener la respuesta de Gemini
    final result = await askGeminiUseCase(updatedChat);
    // Cuando de error actualizar el estado con el fallo
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emit(
        state.copyWith(
          loadingMessage: false,
          askGeminiResult: optionOf(left(failure!)),
        ),
      );
    } else {
      // Cuando sea exitoso actualizar el estado con el chat actualizado
      final response = result.fold((l) => null, (r) => r);
      if (response == null) return;
      // Se tiene que hacer emit sobre el estado actual para que se muestre la UI correcta en lo que continuamos con los procesos debidos.
      emit(
        state.copyWith(
          loadingMessage: false,
          chat: some(response),
          askGeminiResult: some(right(response)),
        ),
      );
      // Tenemos mensajes sentinelas con los cuales podemos realizar acciones adicionales
      // Por ejemplo, si el mensaje de Gemini contiene #guardar_chat, podemos guardar el chat automáticamente
      // En este caso, el guardado automatico se da si en el historial Gemini respondió al menos una vez con la palabra clave
      final bool hasResponseByIA = response.contents
          .where(
            (e) => e.isUser == false && e.message.contains('#guardar_chat'),
          )
          .isNotEmpty;
      if (hasResponseByIA) {
        log('Entra en que debe de guardar el chat automaticamente');
        add(SaveChatEvent());
      }
    }

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

  Future<void> _onSaveChatEvent(
    SaveChatEvent event,
    Emitter<StudybotState> emit,
  ) async {
    log('Entra en saveChatEvent');
    final currentChat = state.chat.fold(() => null, (r) => r);
    if (currentChat == null) return;
    String title = '';
    // if (currentChat.title == null || currentChat.title!.isEmpty) {
    title = await _getTitleChat(currentChat);
    // }

    await saveChatUsecase(currentChat.copyWith(title: title));

    emit(state.copyWith(askGeminiResult: some(right(currentChat))));
  }

  Future<void> _onGetAllChatsEvent(
    GetAllChatsEvent event,
    Emitter<StudybotState> emit,
  ) async {
    final result = await getAllChatsUsecase(NoParams());
    emit(state.copyWith(chats: result.fold((l) => [], (r) => r)));
  }

  Future<void> _onChangeTabEvent(
    ChangeTabEvent event,
    Emitter<StudybotState> emit,
  ) async {
    emit(state.copyWith(tabIndex: event.tabIndex));
    if (event.tabIndex == 1) {
      add(GetAllChatsEvent());
    }
  }

  Future<String> _getTitleChat(GeminiChatModel chat) async {
    List<String> questions = [];
    if (chat.contents.length >= 3) {
      questions = chat.contents
          .where((e) => e.isUser)
          .take(3)
          .map((e) => getTextFromPrompt(prompt: e.message) ?? e.message)
          .toList();
    } else {
      questions = chat.contents
          .where((e) => e.isUser)
          .map((e) => getTextFromPrompt(prompt: e.message) ?? e.message)
          .toList();
    }
    final result = await getChatNameUsecase(questions);
    log('Result es $result');
    return result.fold((l) => '', (r) => r);
  }
}
