import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudybotLocalDatasource {
  Future<Either<OperationFailure, Unit>> saveChat({required GeminiChatModel chat});
  Future<Either<OperationFailure, GeminiChatModel>> getChatById({required String id});
  Future<Either<OperationFailure, List<GeminiChatModel>>> getAllChats();
  Future<Either<OperationFailure, Unit>> deleteChat({required String id});
}