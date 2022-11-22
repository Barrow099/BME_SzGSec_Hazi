import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/downloads_model.dart';
import 'package:webshop_client/model/shop_model.dart';
import 'package:webshop_client/repository/downloads_repository.dart';
import 'package:webshop_client/repository/shop_repository.dart';

class DownloadsNotifier extends StateNotifier<AsyncValue<DownloadsModel>> {
  DownloadsRepository downloadsRepository;


  DownloadsNotifier({required this.downloadsRepository}) : super(const AsyncLoading()) {
    refresh();
  }

  refresh() async {
    state = await AsyncValue.guard(() => downloadsRepository.getDownloadsModel());
  }


}