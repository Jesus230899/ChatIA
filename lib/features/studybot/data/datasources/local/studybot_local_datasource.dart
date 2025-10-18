import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';

abstract class StudybotLocalDatasource {
  Future<void> saveChat(GeminiChatModel chat);
  Future<GeminiChatModel?> getChatById(String id);
  Future<List<GeminiChatModel>> getAllChats();
  Future<void> deleteChat(String id);
  Future<void> deleteAllChats();
}