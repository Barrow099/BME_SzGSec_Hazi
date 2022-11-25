import 'package:flutter/material.dart';

abstract class DismissibleDialogMixin {
  void dismissDialog(context) {
    Navigator.pop(context);
  }
}