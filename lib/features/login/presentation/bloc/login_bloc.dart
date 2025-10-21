import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginEvent>((event, emit) {
      if (event is ChangeShowPasswordEvent) {
        log('Entra en ChangeShowPasswordEvent');
        emit(state.copyWith(showPassword: !state.showPassword));
      }
    });
  }
}
