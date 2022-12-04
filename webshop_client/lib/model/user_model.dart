
import 'package:json_annotation/json_annotation.dart';
//part 'user_model.g.dart';

enum UserRole {
  basic,
  admin;

  @override
  String toString() {
    return this == UserRole.admin ? "Admin" : "User";
  }
}

@JsonSerializable()
class UserModel {
  String userName;
  String userId;
  String? email;
  UserRole role;

  UserModel({required this.userId, required this.role, required this.userName, required this.email});

  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json["sub"],
        userName: json["name"],
        role: json["role"] == "admin" ? UserRole.admin : UserRole.basic,
        email: json["email"],
    );
  }

  //automatic json serialization
  //factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  //Map<String, dynamic> toJson() => _$UserModelToJson(this);
}