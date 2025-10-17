import 'package:chatia/features/studybot/domain/entities/gemini_message_entity.dart';

class GeminiMessageModel extends GeminiMessageEntity {
  const GeminiMessageModel({
    required super.isUser,
    required super.message,
    super.date,
  });

  // Para obtener los datos de local
  factory GeminiMessageModel.fromJson(Map<String, dynamic> json) =>
      GeminiMessageModel(
        isUser: json['isUser'] ?? false,
        message: json['message'] ?? '',
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
      );

  // Para guardar localmente
  Map<String, dynamic> toJson() => {
    "isUser": isUser,
    "message": message,
    "date": date,
  };

  // Para enviar los datos a Gemini
  Map<String, dynamic> toJsonGemini() => {
    "role": isUser ? "user" : "model",
    "parts": [
      {"text": message},
    ],
  };

  factory GeminiMessageModel.fromJsonLocal(Map<String, dynamic> json) =>
      GeminiMessageModel(
        isUser: json['isUser'] ?? '',
        message: json['message'] ?? '',
        date: json['date'] ?? '',
      );

  GeminiMessageModel copyWith({
    bool? isUser,
    String? message,
    DateTime? date,
  }) => GeminiMessageModel(
    isUser: isUser ?? this.isUser,
    message: message ?? this.message,
    date: date ?? this.date,
  );

  static GeminiMessageModel fromEntity(GeminiMessageEntity entity) {
    return GeminiMessageModel(
      isUser: entity.isUser,
      message: entity.message,
      date: entity.date,
    );
  }
}
