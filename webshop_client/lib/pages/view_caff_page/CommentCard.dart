import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/user_model.dart';
import 'package:webshop_client/pages/view_caff_page/edit_comment_dialog.dart';
import 'package:webshop_client/provider_objects.dart';

import '../../data/comment.dart';
import '../../widgets/other/RoundedCard.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;

  final Animation<double> animation;
  const CommentCard({Key? key, required this.comment, required Animation<double> this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizeTransition(
      sizeFactor: animation,
      child: RoundedCard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    children: [ Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.account_circle_rounded, color: Colors.grey[600], size: 24,),
                        ),
                        Text(comment.userName ?? "Unknown", style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 16),
                        Text(comment.creationDateString, style: TextStyle(color: Colors.grey[350], fontSize: 14))
                      ],
                    ),
                      Padding(
                        padding: const EdgeInsets.only(top:4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(comment.isReview) const SizedBox(width: 4,),
                            if(comment.isReview) Row(children: [
                              Text(
                                "${comment.rating}",
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20, color: Theme.of(context).primaryColor),
                              ),
                              const Text("/5"),
                            ],),
                            if(comment.isReview) const SizedBox(width: 8,),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                              child: Text(comment.content ?? "Didn't review", textAlign: TextAlign.justify,),
                            )),
                          ],
                        ),
                      ),]
                ),
              ),
              getActions(ref, context)
            ],
          ),
        ),
      ),
    );
  }

  Widget getActions(WidgetRef ref, BuildContext context) {
    if(ref.read(userModelNotifier)?.role == UserRole.admin) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () { editReview(context); },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              fixedSize: const Size(34, 34),
              minimumSize: const Size(0, 0),
              padding: EdgeInsets.zero
            ),
            child: const Icon(Icons.edit_rounded),
          ),
          ElevatedButton(
            onPressed: (){
              ref.read(caffStateNotifier.notifier).deleteReview(comment.id);
            },
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                fixedSize: const Size(34, 34),
                minimumSize: const Size(0, 0),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.red[700]
            ),
            child: const Icon(Icons.delete_forever_rounded),
          )
        ],
      );
    }
    else {
      return Container();
    }
  }

  editReview(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return EditCommentDialog(comment: comment,);
    });
  }
}
