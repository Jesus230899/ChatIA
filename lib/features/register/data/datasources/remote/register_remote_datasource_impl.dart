import 'package:chatia/core/http/http_client.dart';
import 'package:chatia/features/register/data/datasources/remote/register_remote_datasource.dart';
import 'package:chatia/features/register/data/models/user_data_model.dart';
import 'package:http/http.dart';

class RegisterRemoteDatasourceImpl implements RegisterRemoteDatasource {
  final HTTPClient api;

  RegisterRemoteDatasourceImpl({required this.api});

  @override
  Future<Response> register({required UserDataModel user}) async {
    try {
      final response = await api.post('/register', body: user.toJson());
      return response;
    } catch (e) {
      throw Exception('Error Register: $e');
    }
  }
}
