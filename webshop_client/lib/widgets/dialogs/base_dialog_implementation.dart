import 'package:flutter/material.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog.dart';

import 'dismissable_dialog_mixin.dart';

class BaseDialogImplementation extends StatelessWidget with DismissibleDialogMixin {
  final String title;
  final String dismissText;
  final Color dismissColor;
  final String acceptText;
  final Color acceptColor;
  final Function onAcceptFunction;
  final Widget body;
  final bool dismissable;

  BaseDialogImplementation({super.key,
    required this.title,
    this.dismissText = "Cancel",
    this.dismissColor = Colors.black26 ,
    this.acceptText = "Ok",
    this.acceptColor = Colors.blue,
    required this.onAcceptFunction,
    required this.body,
    this.dismissable = true
  });

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: Text(
                title,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            body,
            getButtons(context),
          ],
        ),
      ),
    );
  }

  Padding getButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(dismissable) OutlinedButton(
            onPressed: () {
              dismissDialog(context);
            },
            style: OutlinedButton.styleFrom(
            ),
            child: Text(dismissText, style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: onAcceptFunction as void Function()?,
            child: Text(acceptText, style: const TextStyle(fontSize: 16),),
          ),
        ],
      ),
    );
  }
}