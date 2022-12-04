import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog_implementation.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';
import 'package:webshop_client/widgets/other/snackbars.dart';

import '../../../model/input_validators/sign_up_validator.dart';
import '../../../widgets/text_fields/login_text_form_field.dart';


class EditProfileDialog extends ConsumerStatefulWidget {
  const EditProfileDialog({super.key});

  @override
  EditProfileDialogState createState() => EditProfileDialogState();
}

class EditProfileDialogState extends ConsumerState<EditProfileDialog> with LoadableDialogMixin{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late SignupValidator signupValidator;

  @override
  void initState() {
    super.initState();
    signupValidator = SignupValidator(passwordController, confirmPasswordController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialogImplementation(
        title: "Edit profile",
        onAcceptFunction: validateAndEditProfile,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: LoginTextFormField(
                    controller: userNameController,
                    autofillHints: const [AutofillHints.username],
                    validator: signupValidator.validateUserName,
                    labelText: "User name",
                    hintText: "Enter your user name",
                    icon: Icons.account_box,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: LoginTextFormField(
                    controller: emailController,
                    autofillHints: const [AutofillHints.email],
                    validator: signupValidator.validateEmailAddress,
                    labelText: "Email",
                    hintText: "Enter your email address",
                    icon: Icons.email,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: LoginTextFormField(
                    controller: passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: signupValidator.validatePassword,
                    labelText: "New password",
                    hintText: "Enter your new password",
                    icon: Icons.lock_rounded,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: LoginTextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: signupValidator.validateConfirmPassword,
                    labelText: "New password again",
                    hintText: "Enter your new password again",
                    icon: Icons.lock_rounded,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  validateAndEditProfile() async {
    if(_formKey.currentState!.validate()) {
      final email = emailController.text;
      final userName = userNameController.text;
      final pwd = passwordController.text;
      showLoading(context);
      ref.read(authStateNotifier.notifier).editProfile(
        email, userName, pwd,
      ).then((value) {
        hideLoading(context);
        showOkSnackbar(context, "Profile edited (mock)");
      }).catchError((error) {
        hideLoading(context);
        showErrorSnackbar(context, "Something went wrong");
      });
    }
  }
}
