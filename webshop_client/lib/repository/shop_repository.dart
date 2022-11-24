import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/shop_model.dart';

import '../api/api.dart';

class ShopRepository {
  final AppRestApi appRestApi;

  ShopModel? _shopModel;

  ShopRepository(this.appRestApi);

  Future<ShopModel> getShopModel() async {
    if(_shopModel != null) {
      return _shopModel!;
    }

    await _refreshShopModel();

    if(_shopModel != null) {
      return _shopModel!;
    }

    return Future.error("Couldn't obtain shop model");
  }

  _refreshShopModel() async {
    final caffList = await appRestApi.getCaffList();
    _shopModel = ShopModel(caffList);
  }

  Future<CAFFData> getFullCaff(int caffId) {
    return appRestApi.getCaff(caffId);
  }

  Future addReview(int caffId, String content, int rating) async {
    await Future.delayed(const Duration(milliseconds: 200));
    await appRestApi.addReviewToCaff(caffId, content, rating);
  }

  deleteReview(int reviewId) async {
    await appRestApi.deleteReview(reviewId);
  }

  editReview(int reviewId, String content, int rating) async {
    await appRestApi.editReview(reviewId, content, rating);
  }
}