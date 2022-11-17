import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/user_model.dart';

class AppRestApi {
  //https://pub.dev/packages/dio

  final dio = Dio();

  AppRestApi() {
    dio.options.baseUrl = "http://placeholder.com/api";
  }

  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    Map m = {
      "userName": "ApiUser",
      "uid": "666API666"
    };
    final userStr = jsonEncode(m);

    return UserModel.fromJson(jsonDecode(userStr));
  }

  Future<UserModel> signUp(String userName, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    Map m = {
      "userName": "ApiUser",
      "uid": "666API666"
    };
    final userStr = jsonEncode(m);

    return UserModel.fromJson(jsonDecode(userStr));
  }

  Future logout(UserModel userModel) async {
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<List<CAFFData>> getCaffList() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      CAFFData("https://picsum.photos/800/1200"),
      CAFFData("https://picsum.photos/1200/1000"),
      CAFFData("https://picsum.photos/1200/1200"),
    ];
  }


}