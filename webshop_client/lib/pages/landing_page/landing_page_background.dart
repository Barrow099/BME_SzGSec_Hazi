import 'package:flutter/material.dart';

class LandingPagesBackground extends StatelessWidget {
  final Widget child;
  const LandingPagesBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade500.withAlpha(255),
                      Colors.blue.shade600.withAlpha(255),
                    ],
                    stops: const [0.0, 1.0]
                )
            ),
          ),
          child
        ]);
  }
}