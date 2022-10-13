import 'package:webshop_client/data/auth_state.dart';
import 'package:webshop_client/model/user_model.dart';

class AuthRepository {
  UserModel? userModel;

  Future<AuthState> getAuthState() async {
    await Future.delayed(const Duration(seconds: 2));
    return AuthState.loggedOut;
  }

  Future<AuthState> login() async {
    await Future.delayed(const Duration(seconds: 2));
    //return Future.error("ERROR");
    userModel = UserModel(uid: "666UID", userName: "user1");
    return AuthState.loggedIn;
  }

  Future<AuthState> signUp() async {
    await Future.delayed(const Duration(seconds: 2));
    userModel = UserModel(uid: "666UID", userName: "user1");
    return AuthState.loggedIn;
  }

  Future<AuthState> logout() async {
    await Future.delayed(const Duration(seconds: 2));
    userModel = null;
    return AuthState.loggedOut;
  }

}