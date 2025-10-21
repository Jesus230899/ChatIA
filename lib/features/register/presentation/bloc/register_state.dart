part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool showPassword;
  final bool showConfirmPassword;

  const RegisterState({
    required this.showPassword,
    required this.showConfirmPassword,
  });

  RegisterState copyWith({bool? showPassword, bool? showConfirmPassword}) =>
      RegisterState(
        showPassword: showPassword ?? this.showPassword,
        showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      );

  factory RegisterState.initial() =>
      RegisterState(showPassword: false, showConfirmPassword: false);

  @override
  List<Object> get props => [showPassword, showConfirmPassword];
}
