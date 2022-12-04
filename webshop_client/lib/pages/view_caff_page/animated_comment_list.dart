import 'package:flutter/material.dart';

import '../../data/comment.dart';
import 'comment_card.dart';

class AnimatedCommentList extends StatefulWidget {
  final List<Comment> comments;
  const AnimatedCommentList({Key? key, required this.comments}) : super(key: key);

  @override
  AnimatedCommentListState createState() => AnimatedCommentListState();
}

class AnimatedCommentListState extends State<AnimatedCommentList> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();

  late final int _initialItemCount = widget.comments.length;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        Comment comment = widget.comments[index];
        return CommentCard(comment: comment, animation: animation);
      },
      initialItemCount: _initialItemCount,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedCommentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleAddedItems(oldItems: oldWidget.comments, newItems: widget.comments);
    _handleRemovedItems(oldItems: oldWidget.comments, newItems: widget.comments);
  }

  /// Handles any removal of [Comment]
  _handleRemovedItems({
    required List<Comment> oldItems,
    required List<Comment> newItems,
  }) {
    // If an [Item] was in the old but is not in the new, it has
    // been removed
    for (var i = 0; i < oldItems.length; i++) {
      final oldItem = oldItems[i];
      // Here the equality checks use [content] thanks to Equatable
      if (!newItems.contains(oldItem)) {
        _listKey.currentState?.removeItem(i,
              (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: CommentCard(comment: oldItem, animation: animation),
          ),
        );
      }
    }
  }

  /// Handles any added [Comment]
  _handleAddedItems({
    required List<Comment> oldItems,
    required List<Comment> newItems,
  }) {
    // If an [Item] is in the new but was not in the old, it has
    // been added
    for (var i = 0; i < newItems.length; i++) {
      // Here the equality checks use [content] thanks to Equatable
      if (!oldItems.contains(newItems[i])) {
        _listKey.currentState?.insertItem(i);
      }
    }
  }
}
