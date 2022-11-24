import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog_implementation.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';

import '../../widgets/other/snackbars.dart';

class EditCaffDialog extends ConsumerStatefulWidget {
  final CAFFData caffData;
  const EditCaffDialog({super.key, required this.caffData});

  @override
  EditCaffDialogState createState() => EditCaffDialogState();
}

class EditCaffDialogState extends ConsumerState<EditCaffDialog> with LoadableDialogMixin{
  late TextEditingController priceEditingController = TextEditingController(text: widget.caffData.price.toString());

  @override
  Widget build(BuildContext context) {
    return BaseDialogImplementation(
      title: "Edit caff",
      onAcceptFunction: onEditCaff,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: priceEditingController,
          ),
        ],
      ),
    );
  }

  onEditCaff() async {
    showErrorSnackbar(context, "TODO unimplemented");
    Navigator.of(context).pop();
    // showLoading(context);
    // ref.read(caffStateNotifier.notifier).editReview(
    //
    // ).onError((error, stackTrace) {
    //   hideLoading(context);
    //   showErrorSnackbar(context, "Something went wrong. Please try again later 😱");
    // }).then((value) {
    //   hideLoading(context);
    //   Navigator.of(context).pop();
    // });

  }
}
