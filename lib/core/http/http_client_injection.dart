import '../injection/base_injection.dart';
import 'http_client.dart';

Future<void> initHTTPClientInjection() async {
  unRegisterServices();

  getIt.registerLazySingleton(() => HTTPClient());
}

void unRegisterServices() {
  removeRegistrationIfExist<HTTPClient>();
}
