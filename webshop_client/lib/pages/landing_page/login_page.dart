import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/auth_state.dart';
import 'package:webshop_client/model/input_validators/login_validator.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/buttons/loadable_button.dart';

import '../../widgets/text_fields/login_text_form_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loginValidator = LoginValidator();

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
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: LoginTextFormField(
                          autofocus: true,
                          icon: Icons.person_rounded,
                          labelText: "Username",
                          hintText: "Enter username",
                          autofillHints: const [AutofillHints.username],
                          controller: userNameController,
                          validator: loginValidator.validateUserName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: LoginTextFormField(
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                            labelText: "Password",
                            hintText: "Enter your password",
                          icon: Icons.lock_rounded,
                          controller: passwordController,
                          validator: loginValidator.validatePassword,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadableButton(
                            onPressed: validateAndLogin,
                            text: "Login",
                            isLoading: authStateFuture.isLoading,
                            icon: Icons.login_rounded,
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),
          const Spacer( flex: 40, ),
        ],
      ),
    );
  }

  validateAndLogin() {
    if(_formKey.currentState!.validate()) {
      ref.read(authStateNotifier.notifier).login();
    }
  }

}

