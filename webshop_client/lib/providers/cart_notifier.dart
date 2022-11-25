import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/cart_state.dart';
import 'package:webshop_client/repository/shop_repository.dart';

class CartNotifier extends StateNotifier<CartState> {
  ShopRepository shopRepository;

  CartNotifier(this.shopRepository) : super(CartState());

  addToCart(CAFFData caffData) {
    final added = state.add(caffData);
    if(added) {
      state = CartState(oldState: state);
    }
  }

  removeFromCart(CAFFData caffData) {
    final removed = state.remove(caffData);
    if(removed) {
      state = CartState(oldState: state);
    }
  }

  Future downloadCaffs() async {
    state.downloadProgress = 0;
    await shopRepository.downloadCaffs(state.inCartCaffs, _downLoadProgressCallback);
    state = CartState();
  }

  _downLoadProgressCallback(double progress) {
    state.addDownloadProgress(progress/state.itemCount);
    state = CartState(oldState: state);
  }
}