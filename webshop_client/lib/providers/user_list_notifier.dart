import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/user_list_model.dart';
import 'package:webshop_client/repository/user_list_repository.dart';

class UserListNotifier extends StateNotifier<AsyncValue<UserListModel>> {
  UserListRepository userListRepository;


  UserListNotifier({required this.userListRepository}) : super(const AsyncLoading()) {
    refresh();
  }

  refresh() async {
    state = await AsyncValue.guard(() => userListRepository.refreshUserListModel());
  }

  Future deleteUser(String userId) async {
    await userListRepository.deleteUser(userId);
    await refresh();
  }

  Future promoteUser(String userId) async {
    await userListRepository.promoteUser(userId);
    await refresh();
  }

}