import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {

  @override
  Widget build(BuildContext context) {
    final authStateFuture = ref.watch(authStateNotifier);


    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: authStateFuture.isLoading ? null: logout,
              icon: authStateFuture.isLoading ? const CircularProgressIndicator() : const Icon(Icons.logout))
        ],
      ),
      body: const Text("Logged in"),
    );
  }

  logout() {
    ref.read(authStateNotifier.notifier).logout();
  }
}
