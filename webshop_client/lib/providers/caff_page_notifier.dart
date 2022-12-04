import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/repository/shop_repository.dart';

class CaffPageNotifier extends StateNotifier<AsyncValue<CAFFData>> {
  ShopRepository shopRepository;
  int? currentCaffId;

  CaffPageNotifier({required this.shopRepository}) : super(const AsyncLoading());
  
  loadFullCaff(int caffId) async {
    currentCaffId = caffId;
    state = await AsyncValue.guard(() => shopRepository.getFullCaff(caffId));
  }

  Future addReview(String content, {int? rating}) async {
    if(currentCaffId==null) return;

    await shopRepository.addReview(currentCaffId!, content, rating);
    await loadFullCaff(currentCaffId!);
  }

  Future deleteReview(int reviewId) async {
    await shopRepository.deleteReview(reviewId);
    if(currentCaffId==null) return;
    await loadFullCaff(currentCaffId!);
  }

  Future editReview(int reviewId, String content, {int? rating}) async {
    await shopRepository.editReview(reviewId, content, rating);
    if(currentCaffId==null) return;
    await loadFullCaff(currentCaffId!);
  }
}