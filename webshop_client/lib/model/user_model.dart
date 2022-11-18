
import 'package:json_annotation/json_annotation.dart';
//part 'user_model.g.dart';

enum UserRole {
  basic,
  admin
}

@JsonSerializable()
class UserModel {
  String userName;
  String userId;
  UserRole role;

  UserModel({required this.userId, required this.role, this.userName="Not implemented"});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json["client_id"],
        userName: json["name"],
        role: json["role"] == "admin" ? UserRole.admin : UserRole.basic
    );
  }

  //automatic json serialization
  //factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  //Map<String, dynamic> toJson() => _$UserModelToJson(this);
}