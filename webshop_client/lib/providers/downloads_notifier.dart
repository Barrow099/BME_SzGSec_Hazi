import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/history_model.dart';
import 'package:webshop_client/repository/downloads_repository.dart';

class DownloadsNotifier extends StateNotifier<AsyncValue<HistoryModel>> {
  DownloadsRepository downloadsRepository;


  DownloadsNotifier({required this.downloadsRepository}) : super(const AsyncLoading()) {
    refresh();
  }

  refresh() async {
    state = await AsyncValue.guard(() => downloadsRepository.refreshHistoryModel());
  }


}