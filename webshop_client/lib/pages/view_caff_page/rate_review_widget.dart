import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class RateReviewWidget extends StatelessWidget {
  final int reviewValue;
  final Function(int) onReviewValueChanged;
  const RateReviewWidget({super.key, required this.reviewValue, required this.onReviewValueChanged});

  @override
  Widget build(BuildContext context) {
    return MaterialSegmentedControl(
        selectionIndex: reviewValue-1,
        onSegmentChosen: (index) {
          onReviewValueChanged(index+1);
        },
        borderColor: Colors.grey[350],
        unselectedColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        verticalOffset: 10,
        horizontalPadding: const EdgeInsets.only(right: 8, top: 0),
        children: const {
          0: Text("1"),
          1: Text("2"),
          2: Text("3"),
          3: Text("4"),
          4: Text("5"),
        });
  }
}
