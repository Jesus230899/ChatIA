import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/features/home/presentation/bloc/home_bloc.dart';

// Por cada feature creamos un archivo de inyección de dependencias específico.
// Aquí registramos las implementaciones concretas de las interfaces definidas en la capa de dominio

// La diferencia entre registerLazySingleton y registerFactory es que el primero crea una única instancia que se reutiliza, mientras que el segundo crea una nueva instancia cada vez que se solicita.
// En mi caso uso registerFactory en los Blocs porque quiero que cada vez que se solicite un Bloc se cree una nueva instancia, ya que los Blocs manejan estados que pueden cambiar y no quiero compartir el mismo estado entre diferentes partes de la aplicación.
Future<void> initHomeInjection() async {
  unRegisterInjections();

  // BLoCs
  getIt.registerFactory<HomeBloc>(() => HomeBloc());

  // Casos de uso
  // getIt.registerLazySingleton<RegisterUsecase>(
  //   () => RegisterUsecase(repository: getIt()),
  // );

  // Repositorios
  // getIt.registerLazySingleton<RegisterRepository>(
  //   () => RegisterRepositoryImpl(datasource: getIt()),
  // );

  // Datasources
  // getIt.registerLazySingleton<RegisterRemoteDatasource>(
  //   () => RegisterRemoteDatasourceImpl(api: getIt()),
  // );
}

void unRegisterInjections() {
  removeRegistrationIfExist<HomeBloc>();
}
