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