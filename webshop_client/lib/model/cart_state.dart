import 'package:flutter/foundation.dart';
import 'package:webshop_client/data/CAFF_data.dart';

class CartState {
  List<CAFFData> inCartCaffs = [];
  double downloadProgress = 0;

  CartState({CartState? oldState}) {
    if(oldState != null) {
      inCartCaffs = List.of(oldState.inCartCaffs);
    }
  }

  int get itemCount => inCartCaffs.length;
  bool get hasItems => inCartCaffs.isNotEmpty;

  bool add(CAFFData caffData) {
    if(inCartCaffs.contains(caffData)) {
      return false;
    }
    inCartCaffs.add(caffData);
    return true;
  }

  bool remove(CAFFData caffData) {
    return inCartCaffs.remove(caffData);
  }

  bool isInCart(CAFFData caffData) {
    return inCartCaffs.contains(caffData);
  }

  void addDownloadProgress(double d) {
    downloadProgress += d;
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return (other is CartState) &&
        listEquals(inCartCaffs, other.inCartCaffs) &&
        downloadProgress == other.downloadProgress;
  }





}