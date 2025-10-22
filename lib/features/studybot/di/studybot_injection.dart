import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource_impl.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_remote_datasource_impl.dart';
import 'package:chatia/features/studybot/data/repositories/studybot_local_repository_impl.dart';
import 'package:chatia/features/studybot/data/repositories/studybot_remote_repository_impl.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_local_repository.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_remote_repository.dart';
import 'package:chatia/features/studybot/domain/usecases/ask_gemini_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/delete_all_chats_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/get_all_chat_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/get_chat_name_usecase.dart';
import 'package:chatia/features/studybot/domain/usecases/save_chat_usecase.dart';
import 'package:chatia/features/studybot/presentation/bloc/study_bloc/studybot_bloc.dart';
import 'package:chatia/features/studybot/presentation/bloc/study_form_bloc/study_form_bloc.dart';

// Por cada feature creamos un archivo de inyección de dependencias específico.
// Aquí registramos las implementaciones concretas de las interfaces definidas en la capa de dominio

// La diferencia entre registerLazySingleton y registerFactory es que el primero crea una única instancia que se reutiliza, mientras que el segundo crea una nueva instancia cada vez que se solicita.
// En mi caso uso registerFactory en los Blocs porque quiero que cada vez que se solicite un Bloc se cree una nueva instancia, ya que los Blocs manejan estados que pueden cambiar y no quiero compartir el mismo estado entre diferentes partes de la aplicación.
Future<void> initStudybotInjection() async {
  unRegisterInjections();

  // BLoCs
  getIt.registerFactory<StudybotBloc>(
    () => StudybotBloc(
      askGeminiUseCase: getIt(),
      getAllChatsUsecase: getIt(),
      saveChatUsecase: getIt(),
      getChatNameUsecase: getIt(),
    ),
  );
  getIt.registerFactory<StudyFormBloc>(
    () => StudyFormBloc(deleteAllChatsUsecase: getIt(), storage: getIt()),
  );

  // Casos de uso
  getIt.registerLazySingleton<AskGeminiUseCase>(
    () => AskGeminiUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<SaveChatUsecase>(
    () => SaveChatUsecase(repository: getIt()),
  );

  getIt.registerLazySingleton<GetAllChatsUsecase>(
    () => GetAllChatsUsecase(repository: getIt()),
  );

  getIt.registerLazySingleton<GetChatNameUsecase>(
    () => GetChatNameUsecase(repository: getIt()),
  );

  getIt.registerLazySingleton<DeleteAllChatsUsecase>(
    () => DeleteAllChatsUsecase(repository: getIt()),
  );

  // Repositorios
  getIt.registerLazySingleton<StudybotRemoteRepository>(
    () => StudybotRemoteRepositoryImpl(geminiDatasource: getIt()),
  );

  getIt.registerLazySingleton<StudybotLocalRepository>(
    () => StudybotLocalRepositoryImpl(datasource: getIt()),
  );

  // Datasources
  getIt.registerLazySingleton<GeminiRemoteDatasource>(
    () => GeminiRemoteDatasourceImpl(),
  );

  getIt.registerLazySingleton<StudybotLocalDatasource>(
    () => StudybotLocalDatasourceImpl(),
  );
}

void unRegisterInjections() {
  removeRegistrationIfExist<StudybotBloc>();
  removeRegistrationIfExist<AskGeminiUseCase>();
  removeRegistrationIfExist<SaveChatUsecase>();
  removeRegistrationIfExist<GetAllChatsUsecase>();
  removeRegistrationIfExist<GetChatNameUsecase>();
  removeRegistrationIfExist<DeleteAllChatsUsecase>();
  removeRegistrationIfExist<StudybotRemoteRepository>();
  removeRegistrationIfExist<StudybotLocalRepository>();
  removeRegistrationIfExist<GeminiRemoteDatasource>();
  removeRegistrationIfExist<StudybotLocalDatasource>();
}
