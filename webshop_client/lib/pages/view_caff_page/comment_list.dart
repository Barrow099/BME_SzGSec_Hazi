import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/data/comment.dart';

import '../../widgets/other/RoundedCard.dart';

class CommentList extends StatelessWidget {
  final AsyncValue<CAFFData> caffDataFuture;

  const CommentList(this.caffDataFuture, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return caffDataFuture.when(
        data: (CAFFData caffData) {
          return getDataContent(caffData, context);
        },
        error: (Object error, StackTrace stackTrace) {
          return getErrorContent(error, stackTrace);
        },
        loading: () {
          return getLoadingContent();
        },
    );
  }

  Widget getDataContent(CAFFData caffData, BuildContext context) {
    List<Comment> comments = caffData.comments ?? [];

    if(comments.isEmpty) {
      return const SliverToBoxAdapter(child: RoundedCard(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Text("No comments yet, but you can add some!"),
      )));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Comment comment = comments[index];
          return Text("");RoundedCard(
            child: ListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.account_circle_rounded, color: Colors.grey[600],),
                  ),
                  Text(comment.userName ?? "Unknown", style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 16),
                  Text(comment.creationDateString, style: TextStyle(color: Colors.grey[350], fontSize: 14))
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Row(
                  children: [
                    SizedBox(width: 4,),
                    Text(
                      "${comment.rating}",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                    const Text("/5"),
                    const SizedBox(width: 8,),
                    Text(comment.content ?? "Didn't review"),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: comments.length,
      ),
    );
  }

  Widget getErrorContent(Object error, StackTrace stackTrace) {
    return SliverToBoxAdapter(
      child: RoundedCard(child: const Text("Couldn't load comments!")),
    );
  }

  Widget getLoadingContent() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
