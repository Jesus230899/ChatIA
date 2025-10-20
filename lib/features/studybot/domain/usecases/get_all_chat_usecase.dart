import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllChatsUsecase implements UseCase<List<GeminiChatModel>, NoParams> {
  final StudybotLocalRepository repository;

  GetAllChatsUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, List<GeminiChatModel>>> call(NoParams params) async {
    final result = await repository.getAllChats();
    return result;
  }
}
