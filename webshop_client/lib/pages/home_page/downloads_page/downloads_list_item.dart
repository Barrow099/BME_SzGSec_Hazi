import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/download_data.dart';
import 'package:timeago/timeago.dart' as timeago;

class DownloadsListItem extends ConsumerWidget {
  final DownloadData downloadData;

  const DownloadsListItem({super.key, required this.downloadData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            title: Text(downloadData.caffFileName),
            subtitle: Text(timeago.format(downloadData.downloadedDate)),
            leading: const Icon(Icons.image_outlined, color: Colors.green, size: 40.0)
          ),
        ),
      )
    );
  }
}
