import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/input_validators/ReviewInputValidator.dart';
import 'package:webshop_client/pages/view_caff_page/rate_review_widget.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/other/RoundedCard.dart';

import '../../widgets/other/snackbars.dart';

class WriteCommentWidget extends ConsumerStatefulWidget {
  final AsyncValue<CAFFData> fullCaffFuture;
  final ScrollController scrollController;

  const WriteCommentWidget(this.fullCaffFuture, this.scrollController, {super.key});

  @override
  WriteCommentWidgetState createState() => WriteCommentWidgetState();
}

class WriteCommentWidgetState extends ConsumerState<WriteCommentWidget> {
  bool isLoading = false;

  int _currentReviewValue = 3;
  final TextEditingController reviewTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: RoundedCard(
        child: widget.fullCaffFuture.when(
            data: getDataContent,
            error: getErrorContent,
            loading: getLoadingContent
        ),
      ),
    );
  }

  Widget getDataContent(CAFFData data) {
    return Form(
        key: _formKey,
        child: AbsorbPointer( //disable controls while loading
          absorbing: isLoading,
          child: () {
            if (data.userHasReview(ref.read(userModelNotifier) ?.userId ?? "")) {
              return getCommentView(data);
            }
            else {
              return getReviewView(data);
            }
          }(),
        )
    );

  }


  Widget getReviewView(CAFFData data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: reviewTextController,
            decoration: const InputDecoration(
              label: Text("Review text"),
              hintText: "Write a review",
            ),
            minLines: 1,
            maxLines: 5,
            validator: ReviewInputValidator().validate,
            autovalidateMode: AutovalidateMode.disabled,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: Text("Your rating:", style: Theme.of(context).textTheme.caption,),
          ),
          Row(
            children: [
              Expanded(
                child: RateReviewWidget(
                  reviewValue: _currentReviewValue,
                  onReviewValueChanged: (int reviewValue) {
                    setState(() {
                      _currentReviewValue = reviewValue;
                    });
                  },

                )
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                    onPressed: () => sendReview(data, rating: _currentReviewValue),
                    child: AnimatedSizeAndFade(
                      child: !isLoading ?
                      const Text("Post review") :
                      const SizedBox(height: 16, width: 16, child: CircularProgressIndicator()),
                    )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getCommentView(CAFFData data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: reviewTextController,
            decoration: const InputDecoration(
              label: Text("Comment"),
              hintText: "Post a new comment",
            ),
            minLines: 1,
            maxLines: 5,
            validator: ReviewInputValidator().validate,
            autovalidateMode: AutovalidateMode.disabled,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                  onPressed: () => sendReview(data),
                  child: AnimatedSizeAndFade(
                    child: !isLoading ?
                    const Text("Post comment") :
                    const SizedBox(height: 16, width: 16, child: CircularProgressIndicator()),
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getErrorContent(Object error, StackTrace stackTrace) {
    return Row(
      children: const [
        Icon(Icons.close, color: Colors.red,),
      ],
    );
  }

  Widget getLoadingContent() {
    return const Center(child: Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ));
  }

  sendReview(CAFFData data, {rating=0}) async {
    if(!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();

    await ref.read(caffStateNotifier.notifier).addReview(
        reviewTextController.text,
        rating: rating
    ).catchError((error) {
      showErrorSnackbar(context, 'Something went wrong. Please try again later! 😥');
      setState(() {
        isLoading = false;
      });
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      FocusScope.of(context).unfocus();
      reviewTextController.clear();
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent + 110,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }


}
