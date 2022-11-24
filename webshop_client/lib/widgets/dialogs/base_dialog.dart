import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;
  const BaseDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 12,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: child,
      ),
    );
  }
}
