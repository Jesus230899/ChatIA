import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:dartz/dartz.dart';

abstract class GeminiRemoteDatasource {
  Future<Either<OperationFailure, GeminiChatModel>> askGemini({
    required GeminiChatModel chat,
  });
}