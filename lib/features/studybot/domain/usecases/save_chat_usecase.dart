import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:dartz/dartz.dart';

class SaveChatUsecase implements UseCase<Unit, GeminiChatModel> {
  final StudybotLocalRepository repository;

  SaveChatUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, Unit>> call(GeminiChatModel params) async {
    final result = await repository.saveChat(chat: params);
    return result;
  }
}
