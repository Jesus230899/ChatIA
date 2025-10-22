import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAllChatsUsecase implements UseCase<Unit, NoParams> {
  final StudybotLocalRepository repository;

  DeleteAllChatsUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, Unit>> call(NoParams params) async {
    final result = await repository.deleteAllChats();
    return result;
  }
}
