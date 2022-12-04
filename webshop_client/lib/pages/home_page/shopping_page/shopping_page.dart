import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/model/shop_model.dart';
import 'package:webshop_client/pages/home_page/shopping_page/shopping_list_item.dart';
import 'package:webshop_client/provider_objects.dart';

import '../../view_caff_page/view_caff_page.dart';

class ShoppingPage extends ConsumerStatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  ShoppingPageState createState() => ShoppingPageState();
}

class ShoppingPageState extends ConsumerState<ShoppingPage> {
  final int _pageSize = 1;
  final PagingController<int, CAFFData> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ref.read(shopNotifier.notifier).getPagedCaffs(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final int nextPageKey = pageKey + newItems.length as int;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {

    final shopStateFuture = ref.watch(shopNotifier);

    ref.listen(shopNotifier, (previous, next) {
      if(next.hasValue) {
        if(next.value?.caffList.isEmpty ?? false) {
          _pagingController.refresh();
        }
      }
    });

    return shopStateFuture.when(
        data: getCaffList,
        error: (error, stackTrace)=>Text("$error\n$stackTrace"),
        loading: ()=> const Center(child: CircularProgressIndicator(),)
    );
  }

  Widget getCaffList(ShopModel shopModel) {
    //final caffs = shopModel.caffList;

    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<CAFFData>(
            itemBuilder: (context, caff, idx) {
              return ShoppingListItem(
                        caffData: caff,
                        onClickFunction: goToCaffPage,
              );
            }
          )
      ),
    );
  }

  goToCaffPage(CAFFData caffData) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ViewCaffPage(caffData))
    );
  }
}
