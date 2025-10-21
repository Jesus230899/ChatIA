part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class ChangeShowPasswordEvent extends RegisterEvent {}

class ChangeShowConfirmPasswordEvent extends RegisterEvent {}

class RegisterRequestEvent extends RegisterEvent {
  final String fullName;
  final String email;
  final String password;

  const RegisterRequestEvent({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [fullName, email, password];
}
