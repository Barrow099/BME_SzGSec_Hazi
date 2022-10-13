import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/data/auth_state.dart';
import 'package:webshop_client/widgets/buttons/loadable_button.dart';

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
          Center(
              child: Text("Login", style: Theme.of(context).textTheme.displayLarge,)
          ),
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
                        autofillHints: const [AutofillHints.username],
                        enableSuggestions: true,
                        decoration: const InputDecoration (
                          prefixIcon: Icon(Icons.person_rounded),
                          labelText: "Username",
                          hintText: "Enter username"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: TextFormField(
                        obscureText: true,
                        autofillHints: const [AutofillHints.password],
                        enableSuggestions: true,
                        decoration: const InputDecoration (
                          prefixIcon: Icon(Icons.lock_rounded),
                          labelText: "Password",
                          hintText: "Enter your password"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadableButton(
                          onPressed: ref.read(authStateNotifier.notifier).login,
                          text: "Login",
                          isLoading: authStateFuture.isLoading,
                          icon: Icons.login_rounded,
                      ),
                    )
                  ],
                )
            ),
          ),
          const Spacer( flex: 40, ),
        ],
      ),
    );
  }


}

