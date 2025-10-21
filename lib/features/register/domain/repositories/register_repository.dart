import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/register/data/models/user_data_model.dart';
import 'package:dartz/dartz.dart';

abstract class RegisterRepository {
  Future<Either<OperationFailure, UserDataModel>> register({
    required UserDataModel user,
  });
}
