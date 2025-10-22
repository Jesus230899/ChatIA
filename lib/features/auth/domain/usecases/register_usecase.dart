import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUsecase implements UseCase<UserDataModel, UserDataModel> {
  final RegisterRepository repository;

  RegisterUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, UserDataModel>> call(
    UserDataModel params,
  ) async {
    final result = await repository.register(user: params);
    return result;
  }
}
