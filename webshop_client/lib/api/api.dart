import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:webshop_client/api/webshop_oauth2_client.dart';
import 'package:webshop_client/model/user_model.dart';

class AppRestApi {
  //https://pub.dev/packages/dio

  final apiUrl = "http://placeholder.com/api";

  final dio = Dio();
  final secureDio = Dio();

  final oauthClient = WebshopOAuth2Client();


  String? accessToken;

  AppRestApi() {
    dio.options.baseUrl = apiUrl;
    secureDio.options.baseUrl = apiUrl;
  }

  Future<UserModel> login() async {
    AccessTokenResponse? token = await oauthClient.helper.getToken();

    if(token == null || token.accessToken == null) {
      return Future.error("Couldn't acquire auth token!");
    }

    accessToken = token.accessToken;

    Map<String, dynamic> payload = Jwt.parseJwt(token.accessToken!);
    return UserModel.fromJson(payload);
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
    //await Future.delayed(const Duration(seconds: 1));
    // TODO implement logout
    throw UnimplementedError("Logout not implemented!!");
  }


}