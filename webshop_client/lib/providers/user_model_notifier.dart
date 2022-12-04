import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/user_model.dart';
import 'package:webshop_client/repository/auth_repository.dart';

class UserModelNotifier extends StateNotifier<UserModel?> {
  final AuthRepository authRepository;

  UserModelNotifier({required this.authRepository}) : super(null) {
    state = authRepository.userModel;
  }

}