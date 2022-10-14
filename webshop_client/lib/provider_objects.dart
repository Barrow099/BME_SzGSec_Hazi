import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/api/api.dart';
import 'package:webshop_client/model/user_model.dart';
import 'package:webshop_client/providers/auth_state_notifier.dart';
import 'package:webshop_client/providers/user_model_notifier.dart';
import 'repository/auth_repository.dart';
import 'data/auth_state.dart';

final appRestApi = Provider<AppRestApi>((ref) => AppRestApi());

final authRepository = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(appRestApi));
});

final authStateNotifier = StateNotifierProvider<AuthStateNotifier, AsyncValue<AuthState>>(
    (ref) {
      return AuthStateNotifier(authRepository: ref.watch(authRepository));
    }
);

final userModelNotifier = StateNotifierProvider<UserModelNotifier, UserModel?>((ref) {
  return UserModelNotifier(authRepository: ref.watch(authRepository));
});