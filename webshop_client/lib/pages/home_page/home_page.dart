import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/pages/home_page/downloads_page/downloads_page.dart';
import 'package:webshop_client/pages/home_page/profile_page/profile_page.dart';
import 'package:webshop_client/pages/home_page/shopping_page/shopping_page.dart';

import '../../widgets/buttons/CartButton.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  PageController pageController = PageController();
  int _currentPageIndex = 0;

  final _pageTitles = ["Browse", "My Downloads", "Profile"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPageIndex]),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CartButton(),
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        physics: const BouncingScrollPhysics(), //TODO extract
        onPageChanged: (id) {
          setState(() {
            pageController=PageController(initialPage: id);
            _currentPageIndex = id;
          });
        },
        children: const [
          ShoppingPage(),
          DownloadsPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_basket_rounded),
            label: _pageTitles[0],
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.download_rounded),
              label: _pageTitles[1],
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: _pageTitles[2],
          ),
        ],
        currentIndex: _currentPageIndex,
        onTap: _onItemTapped,

      ),
    );
  }

  void _onItemTapped(int index) {
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      _currentPageIndex = index;
    });
  }
}


