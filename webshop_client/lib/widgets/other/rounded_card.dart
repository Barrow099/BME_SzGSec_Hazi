

import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  const RoundedCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: child
    );
  }
}
