import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.close, color: Colors.red,),
        Text(text),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showOkSnackbar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(Icons.check, color: Colors.green,),
        ),
        Expanded(child: Text(text, maxLines: 10)),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}