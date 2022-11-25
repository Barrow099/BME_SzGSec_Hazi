import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/pages/view_caff_page/rate_review_widget.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog_implementation.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';
import 'package:webshop_client/widgets/other/snackbars.dart';

import '../../data/comment.dart';

class EditCommentDialog extends ConsumerStatefulWidget {
  final Comment comment;
  const EditCommentDialog({super.key, required this.comment});

  @override
  EditCommentDialogState createState() => EditCommentDialogState();
}

class EditCommentDialogState extends ConsumerState<EditCommentDialog> with LoadableDialogMixin{
  late int _currentReviewValue = widget.comment.rating ?? 0;
  late TextEditingController editingController = TextEditingController(text: widget.comment.content ?? "");

  @override
  Widget build(BuildContext context) {
    return BaseDialogImplementation(
      title: "Edit comment",
      onAcceptFunction: onEditComment,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: editingController,
          ),
          if(_currentReviewValue!=0) Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RateReviewWidget(
                reviewValue: _currentReviewValue,
              onReviewValueChanged: (int reviewValue) {
                setState(() {
                  _currentReviewValue = reviewValue;
                });
              },

            ),
          )
        ],
      ),
    );
  }

  onEditComment() async {
    showLoading(context);
    ref.read(caffStateNotifier.notifier).editReview(
        widget.comment.id,
        editingController.text,
        rating: _currentReviewValue
    ).onError((error, stackTrace) {
      hideLoading(context);
      showErrorSnackbar(context, "Something went wrong. Please try again later 😱");
    }).then((value) {
      hideLoading(context);
      Navigator.of(context).pop();
    });

  }
}
