import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/widgets/text_fields/login_text_form_field.dart';

import '../../model/input_validators/sign_up_validator.dart';
import '../../provider_objects.dart';
import '../../data/auth_state.dart';
import '../../widgets/buttons/loadable_button.dart';


class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late SignupValidator signupValidator;

  @override
  void initState() {
    super.initState();

    signupValidator = SignupValidator(passwordController, confirmPasswordController);
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
              child: Form(
                key: _formKey,
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: LoginTextFormField(
                          controller: userNameController,
                          autofocus: true,
                          autofillHints: const [AutofillHints.newUsername],
                          validator: signupValidator.validateUserName,
                          icon: Icons.person_rounded,
                          labelText: "Username",
                          hintText: "Enter a username",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: LoginTextFormField(
                          controller: emailController,
                          autofocus: true,
                          autofillHints: const [AutofillHints.email],
                          validator: signupValidator.validateEmailAddress,
                          icon: Icons.email,
                          labelText: "Email",
                          hintText: "Enter an email address",
                          inputType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: LoginTextFormField(
                            controller: passwordController,
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                            validator: signupValidator.validatePassword,
                            labelText: "Password",
                            hintText: "Enter a password",
                            icon: Icons.lock_rounded,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: LoginTextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: signupValidator.validateConfirmPassword,
                          labelText: "Confirm password",
                          hintText: "Enter your password again",
                          icon: Icons.lock_rounded,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadableButton(
                          onPressed: validateAndSignup,
                          text: "Sign up",
                          isLoading: authStateFuture.isLoading,
                          icon: Icons.login_rounded,
                        ),
                      )
                    ],
              ),
              ),
            ),
          ),
          const Spacer(flex: 40,),
        ],
      ),
    );
  }

  validateAndSignup() {
    if(_formKey.currentState!.validate()) {
      String email = emailController.text;
      String userName = userNameController.text;
      userName = userName.trim();
      final password = passwordController.text;

      ref.read(authStateNotifier.notifier).signUp(email, userName, password);
    }
  }
}
