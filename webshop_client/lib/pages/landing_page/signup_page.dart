import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider_objects.dart';
import '../../data/auth_state.dart';
import '../../widgets/buttons/loadable_button.dart';

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
          Center(child: Text("Create account", style: Theme.of(context).textTheme.displayLarge,)),
          const Spacer(
            flex: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutofillGroup(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: TextFormField(
                        autofocus: true,
                        autofillHints: const [AutofillHints.newUsername],
                        enableSuggestions: true,
                        decoration: const InputDecoration (
                            prefixIcon: Icon(Icons.person_rounded),
                            labelText: "Username",
                            hintText: "Enter a username"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: TextFormField(
                        obscureText: true,
                        autofillHints: const [AutofillHints.newPassword],
                        enableSuggestions: true,
                        decoration: const InputDecoration (
                            prefixIcon: Icon(Icons.lock_rounded),
                            labelText: "Password",
                            hintText: "Enter a password"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: TextFormField(
                        obscureText: true,
                        autofillHints: const [AutofillHints.newPassword],
                        enableSuggestions: true,
                        decoration: const InputDecoration (
                            prefixIcon: Icon(Icons.lock_rounded),
                            labelText: "Confirm password",
                            hintText: "Enter your password again"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadableButton(
                        onPressed: ref.read(authStateNotifier.notifier).signUp,
                        text: "Sign up",
                        isLoading: authStateFuture.isLoading,
                        icon: Icons.login_rounded,
                      ),
                    )
                  ],
            )),
          ),
          const Spacer(flex: 40,),
        ],
      ),
    );
  }
}
