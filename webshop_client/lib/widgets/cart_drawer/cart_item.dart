import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/provider_objects.dart';

class CartItem extends ConsumerWidget {
  final CAFFData caffData;
  final Function onClickFunction;

  const CartItem({super.key, required this.caffData,required this.onClickFunction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage (
                  imageUrl: ref.read(appRestApi).getCaffPreviewUrl(caffData.id),
                  httpHeaders: ref.read(appRestApi).authHeader,
                  fit: BoxFit.fitHeight,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("\$${caffData.price}", style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white)),
                          const SizedBox(height: 24,child: VerticalDivider(color: Colors.white, thickness: 1,)),
                          Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white,),
                                onPressed: (){
                                  ref.read(cartStateNotifier.notifier).removeFromCart(caffData);
                                },
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}

