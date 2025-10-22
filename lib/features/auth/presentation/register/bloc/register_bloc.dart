import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/usecases/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterBloc({required this.registerUsecase})
    : super(RegisterState.initial()) {
    on<RegisterEvent>((event, emit) async {
      emit(state.copyWith(registerResult: none()));
      if (event is ChangeShowPasswordEvent) {
        emit(state.copyWith(showPassword: !state.showPassword));
      }
      if (event is ChangeShowConfirmPasswordEvent) {
        emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
      }

      if (event is RegisterRequestEvent) {
        await _onRegisterRequestEvent(emit, event);
      }
    });
  }

  Future<void> _onRegisterRequestEvent(
    Emitter<RegisterState> emit,
    RegisterRequestEvent event,
  ) async {
    emit(state.copyWith(loading: true, registerResult: none()));
    final result = await registerUsecase(
      UserDataModel(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );
    if (result.isRight()) {
      final userData = result.fold((l) => null, (r) => r);
      if (userData != null) _saveUserDataInSecureStorage(data: userData);
    }
    emit(state.copyWith(loading: false, registerResult: optionOf(result)));
  }

  Future<void> _saveUserDataInSecureStorage({
    required UserDataModel data,
  }) async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final userEnv = dotenv.env["USER_DATA"] ?? '';
    await storage.write(key: userEnv, value: jsonEncode(data.toJson()));
  }
}
