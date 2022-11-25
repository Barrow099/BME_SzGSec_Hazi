import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/repository/auth_repository.dart';
import 'package:webshop_client/data/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final AuthRepository authRepository;

  AuthStateNotifier({required this.authRepository}) : super(const AsyncLoading()) {
    _getAuthState();
  }

  _getAuthState() async {
    state = await AsyncValue.guard(() {
      return authRepository.getAuthState();
    });
  }

  Future login() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.login();
    });
  }

  Future signUp(String email, String userName, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.signUp(email, userName, password);
    });
  }

  Future logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.logout();
    });
  }

  Future deleteAccount() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.deleteAccount();
    });
  }
}