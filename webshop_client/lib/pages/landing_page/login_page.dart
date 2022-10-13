import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/data/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {


    ref.listen(authStateNotifier, (previous, next) {
      next.when(
          data: (authState) {
            if (authState == AuthState.loggedIn) {
              Navigator.of(context).pop();
            }
          },
          error: (error, stacktrace) {
            SnackBar snackBar = SnackBar(
              content: Text(error.toString()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          loading: () {}
      );
    });

    final authStateFuture = ref.watch(authStateNotifier);



    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(flex: 20,),
          const Center(
              child: Text("Login")
          ),
          const Spacer(
            flex: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutofillGroup(
                child: Column(
                  children: [
                    // TODO required fields and validation
                    TextFormField(),
                    TextFormField(),
                    ElevatedButton(
                        onPressed: authStateFuture.isLoading ? null: ref.read(authStateNotifier.notifier).login,
                        child: authStateFuture.isLoading ?
                            const CircularProgressIndicator(color: Colors.white,)
                            :
                            const Text("Login")
                    )
                  ],
                )
            ),
          ),
          const Spacer( flex: 50, ),
        ],
      ),
    );
  }


}

