import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/data/comment.dart';
import 'package:webshop_client/pages/view_caff_page/animated_comment_list.dart';

import '../../widgets/other/rounded_card.dart';

class CommentListContainer extends StatelessWidget {
  final AsyncValue<CAFFData> caffDataFuture;

  const CommentListContainer(this.caffDataFuture, {Key? key}) : super(key: key);

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

    return AnimatedCommentList(comments: List.from(comments));
  }

  Widget getErrorContent(Object error, StackTrace stackTrace) {
    return const SliverToBoxAdapter(
      child: RoundedCard(child: Text("Couldn't load comments!")),
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
