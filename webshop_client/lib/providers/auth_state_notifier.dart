import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/Repository/auth_repository.dart';
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

  Future signUp() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.signUp();
    });
  }

  Future logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return authRepository.logout();
    });
  }
}