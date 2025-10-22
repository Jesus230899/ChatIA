
import 'package:http/http.dart';

abstract class LoginRemoteDatasource {
  Future<Response> login({
    required String email,
    required String password,
  });
}
