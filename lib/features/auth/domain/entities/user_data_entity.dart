import 'package:equatable/equatable.dart';

class UserDataEntity extends Equatable {
  final String? fullName;
  final String email;
  final String password;

  const UserDataEntity({
    this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}
