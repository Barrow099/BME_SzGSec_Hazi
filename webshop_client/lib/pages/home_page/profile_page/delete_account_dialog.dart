import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog_implementation.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';

import '../../../widgets/other/snackbars.dart';


class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  DeleteAccountDialogState createState() => DeleteAccountDialogState();
}

class DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> with LoadableDialogMixin{
  @override
  Widget build(BuildContext context) {
    return BaseDialogImplementation(
      title: "Delete account",
      onAcceptFunction: deleteAccount,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Are you sure you want to permanently delete your account?"),
          )
        ],
      ),
    );
  }

  deleteAccount() async {
    ref.read(authStateNotifier.notifier).deleteAccount().then((value) {
      hideLoading(context);
      showOkSnackbar(context, "Account deleted 😎");
    }).catchError((error) {
      hideLoading(context);
      showErrorSnackbar(context, error);
    });
  }
}
