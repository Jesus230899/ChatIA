import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  LoginBloc({required this.loginUsecase}) : super(LoginState.initial()) {
    on<LoginEvent>((event, emit) async {
      if (event is ChangeShowPasswordEvent) {
        emit(state.copyWith(showPassword: !state.showPassword));
      }

      if (event is LoginRequestEvent) {
        await _onLoginRequestEvent(event, emit);
      }
    });
  }

  Future<void> _onLoginRequestEvent(
    LoginRequestEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(loading: true, loginResult: none()));
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );
    if (result.isRight()) {
      final userData = result.fold((l) => null, (r) => r);
      if (userData != null) _saveUserDataInSecureStorage(data: userData);
    }
    emit(state.copyWith(loading: false, loginResult: some(result)));
  }

  Future<void> _saveUserDataInSecureStorage({
    required UserDataModel data,
  }) async {
    final storage = getIt<FlutterSecureStorage>();
    final userEnv = dotenv.env["USER_DATA"] ?? '';
    await storage.write(key: userEnv, value: jsonEncode(data.toJson()));
  }
}
