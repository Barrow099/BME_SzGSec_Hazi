import 'package:flutter/material.dart';

class LoadableButton extends StatelessWidget {
  IconData? icon;
  Function onPressed;
  String text;
  bool isLoading;

  LoadableButton({
    required this.onPressed,
    required this.text,
    required this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if(icon == null) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed as void Function()?,
        child: isLoading ? getLoadingBar() : Text(text),
      );
    }
    else {
      return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
          ),
          onPressed: isLoading ? null : onPressed as void Function()?,
          icon: isLoading ? getLoadingBar() : Icon(icon),
          label: Text(text)
      );
    }
  }

  Widget getLoadingBar() {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }
}
