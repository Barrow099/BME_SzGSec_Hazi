import 'package:flutter/material.dart';

class WelcomePagesBackground extends StatelessWidget {
  final Widget child;
  const WelcomePagesBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 174, 210, 232),
                      Color.fromARGB(255, 216, 224, 226),
                    ],
                    stops: [0.0, 1.0]
                )
            ),
          ),
          child
        ]);
  }
}