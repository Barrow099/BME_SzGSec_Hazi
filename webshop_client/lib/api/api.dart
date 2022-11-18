import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:webshop_client/api/webshop_oauth2_client.dart';
import 'package:webshop_client/model/user_model.dart';

class AppRestApi {
  //https://pub.dev/packages/dio

  final apiUrl = "https://10.0.2.2:44384";

  final secureDio = Dio();

  final oauthClient = WebshopOAuth2Client();

  String? accessToken;

  AppRestApi() {
    secureDio.options.baseUrl = apiUrl;
    secureDio.interceptors.add(PrettyDioLogger());
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
    List<CAFFData> caffs = [];

    try {
      final response = await secureDio.get("/Caff");
      List<dynamic> caffMaps =  response.data;


      caffMaps.forEach((element) {
        caffs.add(CAFFData.fromJson(element));
      });

    } on DioError catch(e) {
      Future.error(e, e.stackTrace);
    }

    return caffs;
  }

  String getCaffPreviewUrl(int caffId) {
    //return "$apiUrl/Caff/$caffId/preview"; TODO preview
    return "https://picsum.photos/seed/$caffId/1200/1200";
  }

  Map<String, String> get authHeader {
    Map<String, String> stringHeaders = {};

    secureDio.options.headers.forEach((key, value) {
      stringHeaders[key] = value.toString();
    });

    return stringHeaders;
  }


}