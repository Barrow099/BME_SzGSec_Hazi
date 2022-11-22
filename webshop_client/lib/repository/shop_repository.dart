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

    final caffList = await appRestApi.getCaffList();

    return ShopModel(caffList);
  }
}