import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/repositories/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUsecase implements UseCase<UserDataModel, LoginParams> {
  final LoginRepository repository;

  LoginUsecase({required this.repository});

  @override
  Future<Either<OperationFailure, UserDataModel>> call(
    LoginParams params,
  ) async {
    final result = await repository.login(
      email: params.email,
      password: params.password,
    );
    return result;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
