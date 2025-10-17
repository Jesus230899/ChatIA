import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:chatia/features/studybot/domain/entities/gemini_chat_entity.dart';
import 'package:chatia/features/studybot/domain/entities/gemini_message_entity.dart';

class GeminiChatModel extends GeminiChatEntity {
  const GeminiChatModel({super.title, required super.contents});

  // Para obtener los datos de local
  factory GeminiChatModel.fromJson(Map<String, dynamic> json) =>
      GeminiChatModel(
        title: json['title'] ?? '',
        contents:
            (json['contents'] as List?)
                ?.map((e) => GeminiMessageModel.fromJson(e))
                .toList() ??
            [],
      );

  // Para guardar localmente
  Map<String, dynamic> toJson() => {
    "title": title,
    "contents": contents
        .map((e) => (e as GeminiMessageModel).toJson())
        .toList(),
  };

  // Para enviar a Gemini
  Map<String, dynamic> toJsonGemini() => {
    "contents": contents
        .map((e) => (e as GeminiMessageModel).toJsonGemini())
        .toList(),
  };

  GeminiChatModel copyWith({
    String? title,
    List<GeminiMessageEntity>? contents,
  }) => GeminiChatModel(
    title: title ?? this.title,
    contents: contents ?? this.contents,
  );
}
