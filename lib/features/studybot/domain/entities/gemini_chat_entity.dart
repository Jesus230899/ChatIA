import 'package:chatia/features/studybot/domain/entities/gemini_message_entity.dart';
import 'package:equatable/equatable.dart';

class GeminiChatEntity extends Equatable {
  final String id;
  final String? title;
  final List<GeminiMessageEntity> contents;

  const GeminiChatEntity({required this.id, this.title, required this.contents});

  @override
  List<Object?> get props => [id, title, contents];
}
