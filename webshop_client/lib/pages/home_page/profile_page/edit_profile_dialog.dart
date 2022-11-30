import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog_implementation.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';


class EditProfileDialog extends ConsumerStatefulWidget {
  const EditProfileDialog({super.key});

  @override
  EditProfileDialogState createState() => EditProfileDialogState();
}

class EditProfileDialogState extends ConsumerState<EditProfileDialog> with LoadableDialogMixin{
  @override
  Widget build(BuildContext context) {
    return BaseDialogImplementation(
      title: "Edite profile",
      onAcceptFunction: deleteAccount,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text("Are you sure you want to permanently delete your account?")
        ],
      ),
    );
  }

  deleteAccount() async {
    ref.read(authStateNotifier.notifier).deleteAccount();
  }
}
