import 'package:webshop_client/model/downloads_model.dart';

import '../api/api.dart';
import '../data/download_data.dart';

class DownloadsRepository {
  final AppRestApi appRestApi;

  DownloadsModel? _downloadsModel;

  DownloadsRepository(this.appRestApi);

  Future<DownloadsModel> getDownloadsModel() async {
    if(_downloadsModel != null) {
      return _downloadsModel!;
    }

    final downloadData = await generateDummyList();

    return DownloadsModel(downloadData);
  }

  Future<List<DownloadData>> generateDummyList() async {
    List<DownloadData> downloads = [
        DownloadData(caption: "Test Caption", creationDate: DateTime.parse("2022-11-20T12:31:17.912Z")),
        DownloadData(caption: "Test Caption", creationDate: DateTime.parse("2022-11-20T12:31:17.912Z")),
        DownloadData(caption: "Test Caption", creationDate: DateTime.parse("2022-11-20T12:31:17.912Z")),
    ];

    return downloads;
  }
}