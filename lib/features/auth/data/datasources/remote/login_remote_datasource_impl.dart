import 'package:chatia/core/http/http_client.dart';
import 'package:chatia/features/auth/data/datasources/remote/login_remote_datasource.dart';
import 'package:http/http.dart';

class LoginRemoteDatasourceImpl implements LoginRemoteDatasource {
  final HTTPClient api;

  LoginRemoteDatasourceImpl({required this.api});

  @override
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        '/login',
        body: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Error Login: $e');
    }
  }
}
