import 'package:chatia/features/studybot/data/constants/gemini_prompts.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';

// Esta clase se encarga de construir el prompt para Gemini.
class GeminiPromptBuilder {
  static GeminiChatModel buildPromptChat({
    required GeminiChatModel chat,
    required String userMessage,
    String? externalInfo,
  }) {
    // Si no hay mensajes previos, se agrega el prompt inicial
    final responsesByIA = chat.contents.where((e) => e.isUser == false).length;

    // Construir el prompt completo
    final fullPrompt = GeminiPrompts.studyBotPrompt(
      prompt: userMessage,
      externalInfo: externalInfo?.isEmpty ?? true ? null : externalInfo,
      responseByIA: responsesByIA > 0,
    );
    // Actualizar el último mensaje del usuario con el prompt completo
    // Por ejemplo, si el usuario preguntó "¿Cuál es la altura de Pikachu?" y se obtuvo información externa,
    // el prompt completo podría ser "¿Cuál es la altura de Pikachu? Información adicional: El Pokémon Pikachu tiene una altura de 0.4 metros..."
    final lastMessage = GeminiMessageModel.fromEntity(chat.contents.last);
    final updatedMessages = List<GeminiMessageModel>.from(chat.contents)
      ..removeLast()
      ..add(lastMessage.copyWith(message: fullPrompt));

    return chat.copyWith(contents: updatedMessages);
  }
}
