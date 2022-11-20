import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/repository/shop_repository.dart';

class CaffPageNotifier extends StateNotifier<AsyncValue<CAFFData>> {
  ShopRepository shopRepository;
  int caffId;

  CaffPageNotifier({required this.shopRepository, required this.caffId}) : super(const AsyncLoading()) {
    loadFullCaff(caffId);
  }
  
  loadFullCaff(int caffId) async {
    state = await AsyncValue.guard(() => shopRepository.getFullCaff(caffId));
  }
}