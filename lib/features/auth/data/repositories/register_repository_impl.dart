import 'dart:convert';
import 'dart:developer';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/auth/data/datasources/remote/register_remote_datasource.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDatasource datasource;

  RegisterRepositoryImpl({required this.datasource});

  @override
  Future<Either<OperationFailure, UserDataModel>> register({
    required UserDataModel user,
  }) async {
    try {
      final Response result = await datasource.register(user: user);
      String source = const Utf8Decoder().convert(result.bodyBytes);
      final responseData = json.decode(source);

      log(responseData.toString());
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
