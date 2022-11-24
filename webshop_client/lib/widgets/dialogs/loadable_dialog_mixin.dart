import 'package:flutter/material.dart';

abstract class LoadableDialogMixin {
  void showLoading(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: const Color.fromARGB(50, 0, 0, 0),

      builder: (BuildContext context) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: const CircularProgressIndicator()),
            ),
          ],
        );
      },
    );
  }

  void hideLoading(context) {
    Navigator.pop(context);
  }
}