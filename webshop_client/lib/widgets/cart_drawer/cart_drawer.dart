import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/cart_drawer/cart_item.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';
import 'package:webshop_client/widgets/other/snackbars.dart';

class CartDrawer extends ConsumerStatefulWidget {
  const CartDrawer({super.key});

  @override
  CartDrawerState createState() => CartDrawerState();
}

class CartDrawerState extends ConsumerState<CartDrawer> with LoadableDialogMixin {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final cartState = ref.watch(cartStateNotifier);

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.shopping_cart_rounded),
                ),
                Text("Cart", style: Theme.of(context).textTheme.headline5,),
                const Spacer(),
                if(cartState.hasItems) Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("${cartState.itemCount}", style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                )
              ],),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartState.itemCount,
                    itemBuilder: (BuildContext context, int index) {
                      final caffData = cartState.inCartCaffs[index];
                      return CartItem(caffData: caffData, onClickFunction: (){});
                    },
                  ),
                ),
              ),
              //const Spacer(),
              ElevatedButton.icon(
                  onPressed: cartState.hasItems && !isLoading ? (){downloadCaffs(ref);} : null,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text("Buy caffs")
              )
            ],
          ),
        ),
      ),

    );
  }

  void downloadCaffs(WidgetRef ref) async {
    setState(() {
      isLoading = true;
    });
    showLoading(context);
    ref.read(cartStateNotifier.notifier).downloadCaffs().onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      hideLoading(context);
      showErrorSnackbar(context, "Something went wrong. Please try again");
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      hideLoading(context);
      Navigator.of(context).pop();
    });
  }
}
