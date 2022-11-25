import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';

class CartButton extends ConsumerWidget {
  const CartButton( {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartStateNotifier);

    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Badge(
          showBadge: cartState.hasItems,
          badgeContent: Text("${cartState.itemCount}"),
          animationType: BadgeAnimationType.scale,
          animationDuration: const Duration(milliseconds: 100),
          child: const Icon(Icons.shopping_cart_rounded)
      ),
      onPressed: Scaffold.of(context).openEndDrawer
    );
  }
}