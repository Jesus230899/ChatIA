import 'package:chatia/features/auth/domain/entities/user_data_entity.dart';

class UserDataModel extends UserDataEntity {
  const UserDataModel({
    super.fullName,
    required super.email,
    required super.password,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "password": password,
  };

  UserDataModel copyWith({String? fullName, String? email, String? password}) =>
      UserDataModel(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  static UserDataModel fromEntity(UserDataEntity entity) {
    return UserDataModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }
}
