import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';

class RatingsBar extends StatelessWidget {
  final AsyncValue<CAFFData> caffDataFuture;

  const RatingsBar(this.caffDataFuture, {super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: caffDataFuture.when(
          data: (CAFFData caffData) {
            return getDataContent(caffData, context);
          },
          error: (Object error, StackTrace stackTrace) {
            return getErrorContent();
          },
          loading: () {
            return getLoadingContent();
          },
        )
      ),
    );
  }

  Widget getDataContent(CAFFData caffData, BuildContext context) {
    double ratingRatio = caffData.rating==null ? 0 : caffData.rating!/5.0;
    String ratingText = caffData.rating==null ? "-" : "${caffData.rating}";

    return Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: ratingRatio,
          backgroundColor: Colors.grey[100],
        ),
        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(ratingText, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24)),
                ),
                Text("(${caffData.comments?.length ?? 0})", style: const TextStyle(color: Colors.grey, fontSize: 10))
              ],
            )
        )
      ],
    );
  }

  Widget getErrorContent() {
    return Stack(
      fit: StackFit.expand,
      children: const [
        CircularProgressIndicator(
          value: 1,
          color: Colors.red,
        ),
        Center(
            child: Icon(Icons.close)
        )
      ],
    );
  }

  Widget getLoadingContent() {
    return const CircularProgressIndicator(
    );
  }
}
