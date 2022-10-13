import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider_objects.dart';
import '../../data/auth_state.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          loading: () {});
    });

    final authStateFuture = ref.watch(authStateNotifier);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(
            flex: 20,
          ),
          const Center(child: Text("Create account")),
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
                    onPressed: authStateFuture.isLoading ? null : ref.read(authStateNotifier.notifier).signUp,
                    child: authStateFuture.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Sign up"))
              ],
            )),
          ),
          const Spacer(
            flex: 50,
          ),
        ],
      ),
    );
  }
}
