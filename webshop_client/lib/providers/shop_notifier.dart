
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/shop_model.dart';
import 'package:webshop_client/repository/shop_repository.dart';

class ShopNotifier extends StateNotifier<AsyncValue<ShopModel>> {
  ShopRepository shopRepository;


  ShopNotifier({required this.shopRepository}) : super(const AsyncLoading()) {
    loadModel();
  }

  loadModel() async {
    state = await AsyncValue.guard(() => shopRepository.getShopModel());
  }


}