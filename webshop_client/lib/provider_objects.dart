import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/api/api.dart';
import 'package:webshop_client/model/history_model.dart';
import 'package:webshop_client/model/cart_state.dart';
import 'package:webshop_client/model/user_model.dart';
import 'package:webshop_client/providers/auth_state_notifier.dart';
import 'package:webshop_client/providers/downloads_notifier.dart';
import 'package:webshop_client/providers/cart_notifier.dart';
import 'package:webshop_client/providers/shop_notifier.dart';
import 'package:webshop_client/providers/user_list_notifier.dart';
import 'package:webshop_client/providers/user_model_notifier.dart';
import 'package:webshop_client/repository/downloads_repository.dart';
import 'package:webshop_client/repository/shop_repository.dart';
import 'package:webshop_client/repository/user_list_repository.dart';
import 'data/CAFF_data.dart';
import 'model/shop_model.dart';
import 'model/user_list_model.dart';
import 'providers/caff_page_notifier.dart';
import 'repository/auth_repository.dart';
import 'data/auth_state.dart';

final appRestApi = Provider<AppRestApi>((ref) => AppRestApi());

final authRepository = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(appRestApi));
});

final shopRepository = Provider<ShopRepository>((ref) {
  return ShopRepository(ref.watch(appRestApi));
});

final downloadsRepository = Provider<DownloadsRepository>((ref) {
  return DownloadsRepository(ref.watch(appRestApi));
});

final userListRepository = Provider<UserListRepository>((ref) {
  return UserListRepository(ref.watch(appRestApi));
});


final authStateNotifier = StateNotifierProvider<AuthStateNotifier, AsyncValue<AuthState>>(
    (ref) {
      return AuthStateNotifier(authRepository: ref.watch(authRepository));
    }
);

final userModelNotifier = StateNotifierProvider<UserModelNotifier, UserModel?>((ref) {
  return UserModelNotifier(authRepository: ref.watch(authRepository));
});

final userListModelNotifier = StateNotifierProvider<UserListNotifier, AsyncValue<UserListModel>>((ref) {
  return UserListNotifier(userListRepository: ref.watch(userListRepository));
});

final shopNotifier = StateNotifierProvider<ShopNotifier, AsyncValue<ShopModel>>((ref) {
  return ShopNotifier(shopRepository: ref.watch(shopRepository));
});

final downloadsNotifier = StateNotifierProvider<DownloadsNotifier, AsyncValue<HistoryModel>>((ref) {
  return DownloadsNotifier(downloadsRepository: ref.watch(downloadsRepository));
});

final caffStateNotifier = StateNotifierProvider<CaffPageNotifier, AsyncValue<CAFFData>>((ref) {
  return CaffPageNotifier(shopRepository: ref.watch(shopRepository));
});

final cartStateNotifier = StateNotifierProvider<CartNotifier, CartState>( (ref) {
  return CartNotifier(ref.watch(shopRepository));
},);