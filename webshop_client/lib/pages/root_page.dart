import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/auth_state.dart';
import 'package:webshop_client/pages/landing_page/landing_page_background.dart';

import '../provider_objects.dart';
import 'home_page/home_page.dart';
import 'landing_page/landing_page.dart';

class RootPage extends ConsumerWidget {
  const RootPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authStateFuture = ref.watch(authStateNotifier);

    return authStateFuture.when(
        data: getLoadedPageContent,
        error: getLoginErrorContent,
        loading: () => getLoadingContent()
    );
  }

  Widget getLoadedPageContent(AuthState loginState) {
    if(loginState == AuthState.loggedIn) {
      return const HomePage();
    }
    else {
      return const LandingPage();
    }
  }

  Widget getLoginErrorContent(error, stackTrace) {
    return Scaffold(
      body: Center(child: Text("Error: $error\n$stackTrace"))
    );
  }

  Widget getLoadingContent() {
    return const Scaffold(
        body: LandingPagesBackground(
            child: Center(
                child: CircularProgressIndicator(color: Colors.white,)
            )
        )
    );
  }
}
