import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatByIdUsecase implements UseCase<GeminiChatModel, String> {
  final StudybotLocalRepository repository;

  GetChatByIdUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, GeminiChatModel>> call(String params) async {
    final result = await repository.getChatById(id: params);
    return result;
  }
}
