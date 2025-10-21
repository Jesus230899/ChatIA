import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_remote_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatNameUsecase implements UseCase<String, List<String>> {
  final StudybotRemoteRepository repository;

  GetChatNameUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, String>> call(List<String> params) async {
    final result = await repository.getChatName(questions: params);
    return result;
  }
}
