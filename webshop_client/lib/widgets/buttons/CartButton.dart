import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Badge(
          badgeContent: Text("2"),
          animationType: BadgeAnimationType.scale,
          child: const Icon(Icons.shopping_cart_rounded)
      ),
      onPressed: () {},
    );
  }
}