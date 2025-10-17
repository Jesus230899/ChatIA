import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_repository.dart';
import 'package:dartz/dartz.dart';

class StudybotRepositoryImpl extends StudybotRepository {
  final GeminiRemoteDatasource geminiDatasource;
  StudybotRepositoryImpl({required this.geminiDatasource});

  @override
  Future<Either<OperationFailure, GeminiChatModel>> askGemini({
    required GeminiChatModel chat,
  }) async {
    return await geminiDatasource.askGemini(chat: chat);
  }
}
