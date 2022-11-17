import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webshop_client/data/CAFF_data.dart';

class ShoppingListItem extends StatelessWidget {
  final CAFFData caffData;

  const ShoppingListItem(this.caffData) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage (
              imageUrl: caffData.imgUrl,
              fit: BoxFit.fitWidth,
              placeholder: (BuildContext context, url) {
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(150),
                      ],
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("\$${caffData.price}", style: Theme.of(context).textTheme.headline5,),
                      Material(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: IconButton(onPressed: (){} , icon: const Icon(Icons.add_shopping_cart_rounded))
                      )
                    ],
                  ),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}
