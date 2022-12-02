
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/shop_model.dart';
import 'package:webshop_client/repository/shop_repository.dart';

class ShopNotifier extends StateNotifier<AsyncValue<ShopModel>> {
  ShopRepository shopRepository;


  ShopNotifier({required this.shopRepository}) : super(const AsyncLoading()) {
    refresh();
  }

  refresh() async {
    state = await AsyncValue.guard(() => shopRepository.initShopModel());
  }

  Future getPagedCaffs(int pageKey, int pageSize) async {
    final List<CAFFData> pageCaffs = await shopRepository.loadPage(pageKey, pageSize);
    state = await AsyncValue.guard(() => shopRepository.updateShopModel(pageCaffs));
    return pageCaffs;
  }

  Future uploadCaff(File selectedCaff, int price) async {
    await shopRepository.uploadCaff(selectedCaff, price);
    await refresh();
  }

  Future deleteCaff(int caffId) async {
    await shopRepository.deleteCaff(caffId);
    await refresh();
  }

  Future editCaff(int caffId, File selectedCaff, int price) async {
    await shopRepository.editCaff(caffId, selectedCaff, price);
    await refresh();
  }


}