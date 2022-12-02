import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webshop_client/api/webshop_oauth2_client.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/data/download_data.dart';
import 'package:webshop_client/model/user_model.dart';

import '../model/profile_model.dart';


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
    secureCaffDio.interceptors
      ..add(PrettyDioLogger())
      ..add(InterceptorsWrapper(  //interceptor that refreshes old token if needed
          onRequest:(options, handler) => handler.next(options),
          onResponse:(response,handler) => handler.next(response),
          onError: (DioError e, ErrorInterceptorHandler  handler) async {
            if (e.response?.statusCode == 401) { //TODO retries
              String accessToken = await oauthClient.getAccessToken();
              _updateSecureDio(accessToken);
              e.requestOptions.headers["Authorization"] = 'Bearer $accessToken';

              final response = await secureCaffDio.request(
                e.requestOptions.path,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers
                )
              );
              return handler.resolve(response);
            }
            return  handler.next(e);//continue
          }
      ));

    // duplicated
    secureUserDio.options.baseUrl = userUrl;
    secureUserDio.interceptors
      ..add(PrettyDioLogger())
      ..add(InterceptorsWrapper(  //interceptor that refreshes old token if needed
          onRequest:(options, handler) => handler.next(options),
          onResponse:(response,handler) => handler.next(response),
          onError: (DioError e, ErrorInterceptorHandler  handler) async {
            if (e.response?.statusCode == 401) { //TODO retries
              String accessToken = await oauthClient.getAccessToken();
              _updateSecureDio(accessToken);
              e.requestOptions.headers["Authorization"] = 'Bearer $accessToken';

              final response = await secureUserDio.request(
                  e.requestOptions.path,
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                  options: Options(
                      method: e.requestOptions.method,
                      headers: e.requestOptions.headers
                  )
              );
              return handler.resolve(response);
            }
            return  handler.next(e);//continue
          }
      ));

    unsecureUserDio.options.baseUrl = userUrl;
    unsecureUserDio.interceptors.add(PrettyDioLogger());
  }

  Map<String, String> get authHeader {
    Map<String, String> stringHeaders = {};

    secureCaffDio.options.headers.forEach((key, value) {
      stringHeaders[key] = value.toString();
    });

    return stringHeaders;
  }

  _updateSecureDio(String? accessToken) async {
    this.accessToken = accessToken;
    secureCaffDio.options.headers["Authorization"] = 'Bearer $accessToken';
    secureUserDio.options.headers["Authorization"] = 'Bearer $accessToken';
    secureUserDio.options.followRedirects = true;
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
    // final res2 = await secureUserDio.getUri(revoke);
    final res = await secureUserDio.postUri(revoke);
    // secureCaffDio.options.headers["Authorization"] = '';
    // secureUserDio.options.headers["Authorization"] = '';
  }

  Future deleteAnotherUser(String userId) async {
    try {
      final response = await secureUserDio.delete("/Identity/$userId");
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  Future deleteAccount(UserModel userModel) async {
    try {
      final response = await secureUserDio.delete("/Identity");
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  Future<List<CAFFData>> getCaffList(int pageKey, int pageSize) async {
    List<CAFFData> caffs = [];

    try {
      final response = await secureCaffDio.get(
          "/Caff/paged",
          queryParameters: {
            "PageSize": pageSize,
            "PageNumber": pageKey
          }
      );
      List<dynamic> caffMaps =  response.data["results"];


      for (var caffJson in caffMaps) {
        caffs.add(CAFFData.fromJson(caffJson));
      }

    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }

    return caffs;
  }

  String getCaffPreviewUrl(int caffId) {
    return "$caffUrl/Caff/$caffId/preview";
  }

  Future<CAFFData> getCaff(int caffId) async {
    final response = await secureCaffDio.get("/Caff/$caffId");
    return CAFFData.fromJson(response.data);
  }

  addReviewToCaff(int caffId, String content, int? rating) async {
    try {
      await secureCaffDio.post("/Caff/comment/new", data: {
        "content": content,
        "caffFileId": caffId,
        "rating": rating
      });
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  editReview(int reviewId, String content, int? rating) async {
    try {
      await secureCaffDio.put("/Caff/comment/$reviewId", data: {
        "content": content,
        "rating": rating
      });
    } on DioError catch (e) {
      return Future.error(e, e.stackTrace);
    }
  }

  deleteReview(int reviewId) async {
    try {
      await secureCaffDio.delete("/Caff/Comment/delete/$reviewId");
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  modifyUserData(String userName, String email, String password) async {
    Map data = {
      "displayName": userName,
      "password": password,
      "email": email,
    };

    try {
      final response = await secureUserDio.put("/Identity/Profile", data: data);
      return login();
    } on DioError catch(e) {
      return Future.error(e);
    }
  }


  downloadCaffs(List<CAFFData> inCartCaffs, String targetPath,Future Function(double, CAFFData) downloadProgressCallback) async {
    for (CAFFData caffData in inCartCaffs) {
      await secureCaffDio.download(
          "/Caff/${caffData.id}/download",
          "$targetPath/caff_${caffData.id}.caff",
          onReceiveProgress: (recieved, total) async {
            await downloadProgressCallback(recieved/total, caffData);
          }
      );
      await Future.delayed(Duration(seconds: 3));
      await downloadProgressCallback(1.0, caffData);
    }
  }

  Future<List<DownloadData>> getCaffHistory() async {
    List<DownloadData> caffs = [];

    try {
      final response = await secureCaffDio.get("/Caff/histories");
      List<dynamic> downloadsMaps =  response.data;


      for (var downloadJson in downloadsMaps) {
        caffs.add(DownloadData.fromJson(downloadJson));
      }

    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }

    return caffs;
  }

  Future<List<ProfileModel>> getUsers() async {
    List<ProfileModel> users = [];
    try {
      final response = await secureUserDio.get("/Identity");
      List<dynamic> userMaps =  response.data;


      for (var userJson in userMaps) {
        users.add(ProfileModel.fromJson(userJson));
      }

    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
    return users;
  }

  uploadCaff(File selectedCaff, int price) async {
    try {
      final formData = FormData.fromMap({
        "File": await MultipartFile.fromFile(selectedCaff.path, filename: 'caff.caff'),
        "Price": price
      });

      await secureCaffDio.post("/Caff/new", data: formData);
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  deleteCaff(int caffId) async {
    try {
      await secureCaffDio.delete("/Caff/delete/$caffId");
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }

  editCaff(int caffId, File selectedCaff, int price) async {
    try {
      final formData = FormData.fromMap({
        "File": await MultipartFile.fromFile(selectedCaff.path, filename: 'caff.caff'),
        "Price": price
      });

      await secureCaffDio.put("/Caff/$caffId", data: formData);
    } on DioError catch(e) {
      return Future.error(e, e.stackTrace);
    }
  }
}