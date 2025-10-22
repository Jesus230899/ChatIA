import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/features/auth/data/datasources/remote/login_remote_datasource.dart';
import 'package:chatia/features/auth/data/datasources/remote/login_remote_datasource_impl.dart';
import 'package:chatia/features/auth/data/datasources/remote/register_remote_datasource.dart';
import 'package:chatia/features/auth/data/datasources/remote/register_remote_datasource_impl.dart';
import 'package:chatia/features/auth/data/repositories/login_repository_impl.dart';
import 'package:chatia/features/auth/data/repositories/register_repository_impl.dart';
import 'package:chatia/features/auth/domain/repositories/login_repository.dart';
import 'package:chatia/features/auth/domain/repositories/register_repository.dart';
import 'package:chatia/features/auth/domain/usecases/login_usecase.dart';
import 'package:chatia/features/auth/domain/usecases/register_usecase.dart';
import 'package:chatia/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:chatia/features/auth/presentation/register/bloc/register_bloc.dart';

// Por cada feature creamos un archivo de inyección de dependencias específico.
// Aquí registramos las implementaciones concretas de las interfaces definidas en la capa de dominio

// La diferencia entre registerLazySingleton y registerFactory es que el primero crea una única instancia que se reutiliza, mientras que el segundo crea una nueva instancia cada vez que se solicita.
// En mi caso uso registerFactory en los Blocs porque quiero que cada vez que se solicite un Bloc se cree una nueva instancia, ya que los Blocs manejan estados que pueden cambiar y no quiero compartir el mismo estado entre diferentes partes de la aplicación.
Future<void> initAuthInjection() async {
  unRegisterInjections();

  // BLoCs
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerUsecase: getIt()),
  );

  getIt.registerFactory<LoginBloc>(() => LoginBloc(loginUsecase: getIt()));

  // Casos de uso
  getIt.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: getIt()),
  );

  // Repositorios
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(datasource: getIt()),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(datasource: getIt()),
  );

  // Datasources
  getIt.registerLazySingleton<RegisterRemoteDatasource>(
    () => RegisterRemoteDatasourceImpl(api: getIt()),
  );

  getIt.registerLazySingleton<LoginRemoteDatasource>(
    () => LoginRemoteDatasourceImpl(api: getIt()),
  );
}

void unRegisterInjections() {
  removeRegistrationIfExist<RegisterBloc>();
  removeRegistrationIfExist<LoginBloc>();
  removeRegistrationIfExist<RegisterUsecase>();
  removeRegistrationIfExist<LoginUsecase>();
  removeRegistrationIfExist<RegisterRepository>();
  removeRegistrationIfExist<LoginRepository>();
  removeRegistrationIfExist<RegisterRemoteDatasource>();
  removeRegistrationIfExist<LoginRemoteDatasource>();
}
