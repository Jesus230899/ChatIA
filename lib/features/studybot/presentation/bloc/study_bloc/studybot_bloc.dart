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
      emit(state.copyWith(askGeminiResult: none()));
      if (event is AskGeminiEvent) {
        await _onAskGeminiEvent(event, emit);
      }
      if (event is SaveChatEvent) {
        await _onSaveChatEvent(event, emit);
      }
      if (event is GetAllChatsEvent) {
        await _onGetAllChatsEvent(event, emit);
      }
      if (event is NewChatEvent) {
        await _onNewChatEvent(event, emit);
      }
    });
  }

  Future<void> _onAskGeminiEvent(
    AskGeminiEvent event,
    Emitter<StudybotState> emit,
  ) async {
    emit(state.copyWith(loadingMessage: true, askGeminiResult: none()));
    // Obtener el chat actual
    GeminiChatModel? currentChat = state.chat.fold(() => null, (r) => r);

    // Crear nuevo mensaje basado en la pregunta del usuario
    final newMessage = GeminiMessageModel(
      isUser: true,
      message: event.question,
      date: DateTime.now().toString(),
    );
    // Crear mensaje temporal de Pensando...
    final thinkingMessage = GeminiMessageModel(
      isUser: false,
      message: 'Pensando...',
      date: DateTime.now().toString(),
    );
    // Crear mensaje de error en caso de fallo
    final errorMessage = GeminiMessageModel(
      isUser: false,
      message:
          'Tuve un error al procesar tu solicitud, por favor intenta de nuevo más tarde.',
      date: DateTime.now().toString(),
    );
    // Agregar el nuevo mensaje al chat actual
    if (currentChat != null) {
      currentChat = currentChat.copyWith(
        contents: [...currentChat.contents, newMessage],
      );
    }
    //  Si el chat actual es nulo, significa que se debe de crear uno nuevo
    final updatedChat =
        currentChat ?? GeminiChatModel(contents: [newMessage], id: Uuid().v4());

    // Se emite el estado con el thinkingMessage para dar una una experiencia agradable al usuario mostrando un mensaje de proceso mientras se obtiene la respuesta de Gemini
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
    // Revisamos la respuesta de Gemini
    if (result.isLeft()) {
      // Si da error tenemos que mostrar el mensaje de error en el chat para que el usuario sepa que hubo un fallo
      final failure = result.fold((l) => l, (r) => null);

      emit(
        state.copyWith(
          loadingMessage: false,
          chat: some(
            updatedChat.copyWith(
              contents: [...updatedChat.contents, errorMessage],
              id: updatedChat.id,
            ),
          ),
          askGeminiResult: optionOf(left(failure!)),
        ),
      );
    } else {
      // Si la respuesta fue correcta tenemos que actualizar el chat con la respuesta de Gemini
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
        // Si se cumple la condición, se agrega el evento para guardar el chat
        add(SaveChatEvent());
      }
    }
  }

  Future<void> _onSaveChatEvent(
    SaveChatEvent event,
    Emitter<StudybotState> emit,
  ) async {
    // Obtenemos el chat actual
    final currentChat = state.chat.fold(() => null, (r) => r);
    if (currentChat == null) return;
    String title = '';

    // Por cuestiones de consistencia, primero guardamos el chat sin título
    await saveChatUsecase(currentChat);
    // Luego obtenemos el título del chat
    title = await _getTitleChat(currentChat);
    // Actualizamos el chat con el título obtenido
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

  Future<String> _getTitleChat(GeminiChatModel chat) async {
    // Extraer las últimas 4 preguntas del usuario para generar un título, si tiene menos de 4, tomamos todas las preguntas.
    List<String> questions = [];
    if (chat.contents.length >= 4) {
      questions = chat.contents
          .where((e) => e.isUser)
          .take(4)
          // Usamos getTextFromPrompt para limpiar posibles prompts y obtener solo el texto que el usuario escribió
          .map((e) => getTextFromPrompt(prompt: e.message) ?? e.message)
          .toList();
    } else {
      questions = chat.contents
          .where((e) => e.isUser)
          .map((e) => getTextFromPrompt(prompt: e.message) ?? e.message)
          .toList();
    }
    final result = await getChatNameUsecase(questions);
    return result.fold((l) => '', (r) => r);
  }

  Future<void> _onNewChatEvent(
    NewChatEvent event,
    Emitter<StudybotState> emit,
  ) async {
    emit(state.copyWith(chat: none()));
  }
}
