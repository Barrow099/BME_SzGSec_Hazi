import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/shop_model.dart';
import 'package:webshop_client/pages/home_page/shopping_page/shopping_list_item.dart';
import 'package:webshop_client/provider_objects.dart';

class ShoppingPage extends ConsumerStatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  ShoppingPageState createState() => ShoppingPageState();
}

class ShoppingPageState extends ConsumerState<ShoppingPage> {

  @override
  Widget build(BuildContext context) {

    final shopStateFuture = ref.watch(shopNotifier);

    return shopStateFuture.when(
        data: getCaffList,
        error: (error, stackTrace)=>Text("$error\n$stackTrace"),
        loading: ()=> const Center(child: CircularProgressIndicator(),)
    );
  }

  Widget getCaffList(ShopModel shopModel) {
    final caffs = shopModel.caffList;

    return RefreshIndicator(
      onRefresh: () {
        //TODO implement refresh
        return Future.delayed(Duration(seconds: 2));
      },
      child: ListView.builder(
        itemCount: caffs.length,
        itemBuilder: (context, idx) {
          return ShoppingListItem(caffs[idx]);
        }
      ),
    );
  }
}
