import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/features/login/presentation/bloc/login_bloc.dart';

// Por cada feature creamos un archivo de inyección de dependencias específico.
// Aquí registramos las implementaciones concretas de las interfaces definidas en la capa de dominio

// La diferencia entre registerLazySingleton y registerFactory es que el primero crea una única instancia que se reutiliza, mientras que el segundo crea una nueva instancia cada vez que se solicita.
// En mi caso uso registerFactory en los Blocs porque quiero que cada vez que se solicite un Bloc se cree una nueva instancia, ya que los Blocs manejan estados que pueden cambiar y no quiero compartir el mismo estado entre diferentes partes de la aplicación.
Future<void> initLoginInjection() async {
  unRegisterInjections();

  // BLoCs
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
    ),
  );

  // Casos de uso
  // getIt.registerLazySingleton<AskGeminiUseCase>(
  //   () => AskGeminiUseCase(repository: getIt()),
  // );

  // Repositorios
  // getIt.registerLazySingleton<StudybotRemoteRepository>(
  //   () => StudybotRemoteRepositoryImpl(geminiDatasource: getIt()),
  // );


  // Datasources
  // getIt.registerLazySingleton<GeminiRemoteDatasource>(
  //   () => GeminiRemoteDatasourceImpl(),
  // );
}

void unRegisterInjections() {
  removeRegistrationIfExist<LoginBloc>();
}
