import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/providers/auth_state_notifier.dart';
import 'Repository/auth_repository.dart';
import 'data/auth_state.dart';


final authRepository = Provider<AuthRepository>((ref) => AuthRepository());

final authStateNotifier = StateNotifierProvider<AuthStateNotifier, AsyncValue<AuthState>>(
    (ref) {
      return AuthStateNotifier(authRepository: ref.watch(authRepository));
    }
);