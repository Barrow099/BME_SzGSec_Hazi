import 'package:webshop_client/api/api.dart';
import 'package:webshop_client/data/auth_state.dart';
import 'package:webshop_client/model/user_model.dart';

class AuthRepository {
  final AppRestApi appRestApi;

  UserModel? userModel;

  AuthRepository(this.appRestApi);



  Future<AuthState> getAuthState() async {
    await Future.delayed(const Duration(seconds: 1));
    //TODO check local data for session
    return AuthState.loggedOut;
  }

  Future<AuthState> login() async {
    userModel = await appRestApi.login();
    return AuthState.loggedIn;
  }

  Future<AuthState> signUp(String email, String username, String password) async {
    userModel = await appRestApi.signUp(email, username, password);
    return AuthState.loggedIn;
  }

  Future<AuthState> logout() async {
    if(userModel == null) {
      return Future.error("Invalid user model state: is null, but shouldn't");
    }

    await appRestApi.logout(userModel!);
    userModel = null;
    return AuthState.loggedOut;
  }

  Future<AuthState> deleteAccount() async {
    if(userModel == null) {
      return Future.error("Invalid user model state: is null, but shouldn't");
    }

    appRestApi.deleteAccount(userModel!);
    userModel = null;
    return AuthState.loggedOut;
  }

  Future<void> editeProfile(String email, String userName, String password) async {
    if(userModel == null) {
      return Future.error("Invalid user model state: is null, but shouldn't");
    }

    appRestApi.modifyUserData(userName, email, password);
  }

}