import '../api/api.dart';
import '../model/user_list_model.dart';

class UserListRepository {
  final AppRestApi appRestApi;

  UserListModel? _userListModel;

  UserListRepository(this.appRestApi);

  Future<UserListModel> refreshUserListModel() async {
    final users = await appRestApi.getUsers();
    _userListModel = UserListModel(users);
    return _userListModel!;
  }
  
  Future<void> deleteUser(String userId) async {
    await appRestApi.deleteAnotherUser(userId);
  }

  Future<void> promoteUser(String userId) async {
    await appRestApi.promoteUser(userId);
  }
}