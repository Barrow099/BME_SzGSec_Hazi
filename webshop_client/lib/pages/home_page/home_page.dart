import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/pages/home_page/downloads_page/downloads_page.dart';
import 'package:webshop_client/pages/home_page/profile_page/profile_page.dart';
import 'package:webshop_client/pages/home_page/shopping_page/shopping_page.dart';
import 'package:webshop_client/provider_objects.dart';

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
    final authStateFuture = ref.watch(authStateNotifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPageIndex]),
        actions: [
          IconButton(
              onPressed: authStateFuture.isLoading ? null: logout,
              icon: authStateFuture.isLoading ? const CircularProgressIndicator() : const Icon(Icons.logout))
        ],
      ),
      body: PageView(
        controller: pageController,
        physics: BouncingScrollPhysics(), //TODO extract
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_rounded),
            label: "Browse"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.download_rounded),
              label: "My Downloads"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Browse"
          ),
        ],
        currentIndex: _currentPageIndex,
        onTap: _onItemTapped,

      ),
    );
  }

  void _onItemTapped(int index) {
    pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      _currentPageIndex = index;
    });
  }

  logout() {
    ref.read(authStateNotifier.notifier).logout();
  }
}
