import 'package:webshop_client/model/history_model.dart';

import '../api/api.dart';

class DownloadsRepository {
  final AppRestApi appRestApi;

  HistoryModel? _historyModel;

  DownloadsRepository(this.appRestApi);

  Future<HistoryModel> refreshHistoryModel() async {
    final downloads = await appRestApi.getCaffHistory();
    _historyModel = HistoryModel(downloads);
    return _historyModel!;
  }

}