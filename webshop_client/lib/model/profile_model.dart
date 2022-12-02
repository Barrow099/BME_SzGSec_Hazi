import 'package:json_annotation/json_annotation.dart';
import 'package:webshop_client/model/user_model.dart';

@JsonSerializable()
class ProfileModel {
  String userName;
  String userId;
  String email;
  UserRole role;

  ProfileModel({required this.userId, required this.role, required this.userName, required this.email});

  bool get isAdmin => role == UserRole.admin;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json["id"],
      userName: json["displayName"],
      role: json["role"] == "admin" ? UserRole.admin : UserRole.basic,
      email: json["email"],
    );
  }

//automatic json serialization
//factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
//Map<String, dynamic> toJson() => _$UserModelToJson(this);
}