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

  final caffUrl = "https://10.0.2.2:44384";
  final userUrl = "https://10.0.2.2:44315";

  final secureCaffDio = Dio();
  final secureUserDio = Dio();
  final unsecureUserDio = Dio();

  final oauthClient = WebshopOAuth2Client();

  String? accessToken;

  AppRestApi() {
    secureCaffDio.options.baseUrl = caffUrl;
    secureCaffDio.interceptors.add(PrettyDioLogger());

    secureUserDio.options.baseUrl = userUrl;
    secureUserDio.interceptors.add(PrettyDioLogger());

    unsecureUserDio.options.baseUrl = userUrl;
    unsecureUserDio.interceptors.add(PrettyDioLogger());
  }

  _updateSecureDio(String? accessToken) async {
    this.accessToken = accessToken;
    //TODO add interceptor to update outdated tokens
    secureCaffDio.options.headers["Authorization"] = 'Bearer $accessToken';
    secureUserDio.options.headers["Authorization"] = 'Bearer $accessToken';
  }

  Future<UserModel> login() async {
    String accessToken = await oauthClient.getAccessToken();

    _updateSecureDio(accessToken);

    Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
    return UserModel.fromJson(payload);
  }

  Future<UserModel> signUp(String email, String userName, String password) async {
    Map data = {
      "displayName": userName,
      "password": password,
      "email": email,
    };

    try {
      final response = await unsecureUserDio.post("/Identity/Register", data: data);
      return login();
    } on DioError catch(e) {
      if (e.response?.statusCode == 400) {
        return Future.error(e.response?.data ?? "Response Error!");
      } else {
        return Future.error(e);
      }
    }
  }

  Future logout(UserModel userModel) async {
    secureCaffDio.options.headers["Authorization"] = '';
    secureUserDio.options.headers["Authorization"] = '';
    // TODO check logout
  }

  Future deleteAccount(UserModel userModel) async {
    try {
      final response = await secureUserDio.delete("/Identity");
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  Future<List<CAFFData>> getCaffList() async {
    List<CAFFData> caffs = [];

    try {
      final response = await secureCaffDio.get("/Caff");
      List<dynamic> caffMaps =  response.data;


      caffMaps.forEach((element) {
        caffs.add(CAFFData.fromJson(element));
      });

    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }

    return caffs;
  }

  String getCaffPreviewUrl(int caffId) {
    //return "$apiUrl/Caff/$caffId/preview"; TODO preview
    return "https://picsum.photos/seed/$caffId/1200/1200";
  }

  Map<String, String> get authHeader {
    Map<String, String> stringHeaders = {};

    secureCaffDio.options.headers.forEach((key, value) {
      stringHeaders[key] = value.toString();
    });

    return stringHeaders;
  }

  modifyUserData(String userName, String email, String password) {
    Map data = {
      "displayName": userName,
      "password": password,
      "email": email,
    };

    try {
      final response = secureUserDio.put("/Identity/Profile", data: data);
      return login();
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

}