
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:http/http.dart';

abstract class RegisterRemoteDatasource {
  Future<Response> register({
    required UserDataModel user,
  });
}
