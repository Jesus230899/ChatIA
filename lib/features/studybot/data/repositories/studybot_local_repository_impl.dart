import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:dartz/dartz.dart';

class StudybotLocalRepositoryImpl extends StudybotLocalRepository {
  final StudybotLocalDatasource geminiDatasource;
  StudybotLocalRepositoryImpl({required this.geminiDatasource});

  @override
  Future<Either<OperationFailure, Unit>> saveChat({
    required GeminiChatModel chat,
  }) async {
    return await geminiDatasource.saveChat(chat: chat);
  }

  @override
  Future<Either<OperationFailure, GeminiChatModel>> getChatById({
    required String id,
  }) async {
    return await geminiDatasource.getChatById(id: id);
  }

  @override
  Future<Either<OperationFailure, List<GeminiChatModel>>> getAllChats() async {
    return await geminiDatasource.getAllChats();
  }

  @override
  Future<Either<OperationFailure, Unit>> deleteChat({
    required String id,
  }) async {
    return await geminiDatasource.deleteChat(id: id);
  }
}
