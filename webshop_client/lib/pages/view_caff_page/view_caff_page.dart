import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/pages/view_caff_page/write_comment_widget.dart';
import 'package:webshop_client/pages/view_caff_page/comment_list_container.dart';
import 'package:webshop_client/pages/view_caff_page/edit_caff_dialog.dart';
import 'package:webshop_client/pages/view_caff_page/ratings_bar.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';
import 'package:webshop_client/widgets/other/snackbars.dart';

import '../../widgets/buttons/cart_button.dart';
import '../../widgets/cart_drawer/cart_drawer.dart';

class ViewCaffPage extends ConsumerStatefulWidget {
  final CAFFData caffData;

  const ViewCaffPage(this.caffData, {super.key});

  @override
  ViewCaffPageState createState() => ViewCaffPageState();
}

class ViewCaffPageState extends ConsumerState<ViewCaffPage> with LoadableDialogMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    ref.read(caffStateNotifier.notifier).loadFullCaff(widget.caffData.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final fullCaffFuture = ref.watch(caffStateNotifier);

    return Scaffold(
      endDrawer: const CartDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          buildSliverAppBar(),
          buildHeader(fullCaffFuture),
          WriteCommentWidget(fullCaffFuture, _scrollController ),
          CommentListContainer(fullCaffFuture),
        ],
      ),
    );
  }

  Widget buildHeader(AsyncValue<CAFFData> fullCaffFuture) {
    final cartState = ref.watch(cartStateNotifier);
    final isInCart = cartState.isInCart(widget.caffData);

    return SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeader(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RatingsBar(fullCaffFuture),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,8,16,8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.caffData.caption,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline5
                                ),
                                ElevatedButton.icon(
                                  onPressed: !isInCart ?
                                      (){ ref.read(cartStateNotifier.notifier).addToCart(widget.caffData); }:
                                      null,
                                  icon: Icon(!isInCart ? Icons.add_shopping_cart_rounded : Icons.check),
                                  label: Text("\$${widget.caffData.price}"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, indent: 16, endIndent: 16, height: 1,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          Text(widget.caffData.creationDateString, style: TextStyle(color: Colors.grey[600])),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Icon(Icons.account_circle_rounded, color: Colors.grey[600],),
                              ),
                              Text(widget.caffData.creator, style: TextStyle(color: Colors.grey[600]))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            fixedHeight: 150
          ),
        );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      leading: getBackButton(),
      pinned: true,
      floating: false,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: getImage(),
      ),
      expandedHeight: MediaQuery.of(context).size.height / 2,
      actions: [
        if (ref.read(userModelNotifier)?.isAdmin ?? false) IconButton(
            onPressed: editCaff,
            icon: const Icon(Icons.edit_rounded)
        ),
        if (ref.read(userModelNotifier)?.isAdmin ?? false) IconButton(
            onPressed: deleteCaff,
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.red)
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CartButton(),
        )
      ],
    );
  }

  Widget getImage() {
    return Hero(
      tag: "caff${widget.caffData.id}",
      child: CachedNetworkImage(
        imageUrl: ref.read(appRestApi).getCaffPreviewUrl(widget.caffData.id),
        httpHeaders: ref.read(appRestApi).authHeader,
        placeholder: (context, progress) => const Center(child: CircularProgressIndicator(),),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getBackButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(100)),
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  editCaff() async {
    ref.read(caffStateNotifier).whenData((caffData) {
      showDialog(context: context, builder: (BuildContext context) {
        return EditCaffDialog(caffData: caffData);
      });
    });
  }

  deleteCaff() async {
    showLoading(context);
    ref.read(shopNotifier.notifier).deleteCaff(widget.caffData.id).then((value){
      hideLoading(context);  
      showOkSnackbar(context, "Caff deleted ????");
      Navigator.of(context).pop();
    }).catchError((error) {
      hideLoading(context);
      showErrorSnackbar(context, "Something went wrong ????");
    });
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double fixedHeight;

  PersistentHeader({required this.child, required this.fixedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      width: double.infinity,
      height: fixedHeight,
      child: child
    );
  }

  @override
  double get maxExtent => fixedHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
