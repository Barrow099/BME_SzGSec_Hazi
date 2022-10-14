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

  Future login(String userName, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.login(userName, password);
    });
  }

  Future signUp(String userName, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.signUp(userName, password);
    });
  }

  Future logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.logout();
    });
  }
}