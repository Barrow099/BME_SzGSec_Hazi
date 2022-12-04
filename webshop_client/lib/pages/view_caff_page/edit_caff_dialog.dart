import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/pages/upload_caff_page/upload_caff_widget.dart';
import 'package:webshop_client/widgets/dialogs/base_dialog.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';

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
    return BaseDialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5 ,
        child: UploadCaffWidget(
          caffData: widget.caffData,
          price: widget.caffData.price,
        ))
    );
  }
}
