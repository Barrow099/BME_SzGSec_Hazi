import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final double size;
  final double iconSize;
  final Color? color;


  const RoundIconButton({super.key, required this.icon, required this.onPressed, this.size=40, this.iconSize=24,  this.color});

  @override
  Widget build(BuildContext context) {
    final Color displayColor = onPressed==null ? Colors.grey : color ?? Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(500),
          child: Material(
              color: displayColor,
              child: IconButton(
                  icon: Icon(icon, size: iconSize, color: Colors.white,),
                  onPressed: onPressed
              )
          ),
        ),
      ),
    );
  }
}
