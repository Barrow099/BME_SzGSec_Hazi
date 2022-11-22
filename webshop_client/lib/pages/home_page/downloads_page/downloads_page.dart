import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/downloads_model.dart';
import 'package:webshop_client/provider_objects.dart';

import 'downloads_list_item.dart';

class DownloadsPage extends ConsumerStatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  DownloadsPageState createState() => DownloadsPageState();
}

class DownloadsPageState extends ConsumerState<DownloadsPage> {

  @override
  Widget build(BuildContext context) {

    final downloadsStateFuture = ref.watch(downloadsNotifier);

    return downloadsStateFuture.when(
        data: getDownloadList,
        error: (error, stackTrace)=>Text("$error\n$stackTrace"),
        loading: ()=> const Center(child: CircularProgressIndicator(),)
    );
  }

  Widget getDownloadList(DownloadsModel downloadsModel) {
    final downloads = downloadsModel.downloadsList;

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(shopNotifier.notifier).refresh();
      },
      child:
      downloads.isNotEmpty ?
      ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: downloads.length,
          itemBuilder: (context, idx) {
            return DownloadsListItem(
              downloadData: downloads[idx],
            );
          }
      )
          :
      const Center(child: Text("Nothin to see here 👀"),)
      ,
    );
  }
}
