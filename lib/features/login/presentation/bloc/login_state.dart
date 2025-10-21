part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool showPassword;

  const LoginState({required this.showPassword});

  LoginState copyWith({bool? showPassword}) =>
      LoginState(showPassword: showPassword ?? this.showPassword);

  factory LoginState.initial() => LoginState(showPassword: false);

  @override
  List<Object> get props => [showPassword];
}
