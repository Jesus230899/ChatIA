import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:dartz/dartz.dart';

class StudybotLocalRepositoryImpl extends StudybotLocalRepository {
  final StudybotLocalDatasource datasource;
  StudybotLocalRepositoryImpl({required this.datasource});

  @override
  Future<Either<OperationFailure, Unit>> saveChat({
    required GeminiChatModel chat,
  }) async {
    return await datasource.saveChat(chat: chat);
  }

  @override
  Future<Either<OperationFailure, List<GeminiChatModel>>> getAllChats() async {
    return await datasource.getAllChats();
  }

  @override
  Future<Either<OperationFailure, Unit>> deleteAllChats() async {
    return await datasource.deleteAllChats();
  }
}
