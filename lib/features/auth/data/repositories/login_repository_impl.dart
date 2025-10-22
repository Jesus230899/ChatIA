import 'dart:convert';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/auth/data/datasources/remote/login_remote_datasource.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/repositories/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource datasource;

  LoginRepositoryImpl({required this.datasource});

  @override
  Future<Either<OperationFailure, UserDataModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response result = await datasource.login(
        email: email,
        password: password,
      );
      String source = const Utf8Decoder().convert(result.bodyBytes);
      final responseData = json.decode(source);

      if (result.statusCode == 200) {
        return right(UserDataModel.fromJson(responseData['body']));
      }

      return left(
        OperationFailure.mapError(
          code: result.statusCode,
          message: 'Error registrando al usuario',
        ),
      );
    } catch (e) {
      return left(OperationFailure.mapError(code: 0));
    }
  }
}
