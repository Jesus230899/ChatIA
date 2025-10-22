import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

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
    emit(state.copyWith(loading: false, loginResult: some(result)));
  }
}
