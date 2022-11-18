import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:webshop_client/api/webshop_oauth2_client.dart';
import 'package:webshop_client/model/user_model.dart';

class AppRestApi {
  //https://pub.dev/packages/dio

  final apiUrl = "https://10.0.2.2:44384";

  final dio = Dio();
  final secureDio = Dio();

  final oauthClient = WebshopOAuth2Client();

  String? accessToken;

  AppRestApi() {
    dio.options.baseUrl = apiUrl;
    secureDio.options.baseUrl = apiUrl;
  }

  _updateSecureDio(String? accessToken) async {
    this.accessToken = accessToken;
    //TODO add interceptor to update outdated tokens
    secureDio.options.headers["Authorization"] = 'Bearer $accessToken';
  }

  Future<UserModel> login() async {
    String accessToken = await oauthClient.getAccessToken();

    _updateSecureDio(accessToken);

    Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
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

  Future<List<CAFFData>> getCaffList() async {
    await Future.delayed(const Duration(seconds: 1));

    // try {
    //   final response = await secureDio.get("/Caff");
    // } on DioError catch(e) {
    //   print(e);
    // }

    return [
      CAFFData("https://picsum.photos/800/1200", 2),
      CAFFData("https://picsum.photos/1200/1000", 2),
      CAFFData("https://picsum.photos/1200/1200", 3),
    ];
  }


}