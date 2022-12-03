import 'dart:core';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';

import 'package:webshop_client/api/system/caff_picker.dart';
import 'package:webshop_client/data/CAFF_data.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';
import 'package:webshop_client/widgets/other/snackbars.dart';
import 'package:webshop_client/widgets/text_fields/login_text_form_field.dart';

class UploadCaffWidget extends ConsumerStatefulWidget {
  final CAFFData? caffData;
  final int? price;

  const UploadCaffWidget({super.key, this.caffData, this.price});

  @override
  UploadCaffWidgetState createState() => UploadCaffWidgetState();
}

class UploadCaffWidgetState extends ConsumerState<UploadCaffWidget> with LoadableDialogMixin {
  late TextEditingController priceController = TextEditingController(text: widget.price?.toString());
  final _formKey = GlobalKey<FormState>();

  File? selectedCaff;

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.caffData != null;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 10,),
            Center(child: Text(isEditing ? "Edit Caff" :"Upload caff", style: Theme.of(context).textTheme.headlineLarge,)),
            const Spacer(flex: 10,),
            OutlinedButton.icon(
                onPressed: onSelectCaff,
                icon: const Icon(Icons.file_open),

                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
                ),
                label: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(selectedCaff==null ? "Select caff" : "Selected:"),
                      if(selectedCaff!=null) Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(p.basename(selectedCaff?.path ?? ''), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                      ),
                    ],
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LoginTextFormField(
                  labelText: 'Price',
                  hintText: '',
                  controller: priceController,
                  autofillHints: const [],
                  validator: (String? value) {
                    if(value==null || value.isEmpty) {
                      return "Can't be empty";
                    }
                    else if(int.tryParse(value) == null) {
                      return "Enter a whole number";
                    }
                    return null;
                  },
                  icon: Icons.attach_money,
                  inputType: TextInputType.number,
                )
            ),
            const Spacer(flex: 10,),
            ElevatedButton.icon(
              onPressed: selectedCaff!=null ? onUploadCaff : null,
              icon: const Icon(Icons.upload_outlined),
              label: Text( isEditing ? "Edit" : "Upload"),
            ),
            const Spacer(flex: 5,),
          ],
        ),
      ),
    );
  }

  onSelectCaff() async {
    File? file = await CaffPicker.pickCaff();
    setState(() {
      selectedCaff = file;
    });
  }

  onUploadCaff() async {
    if(widget.caffData == null) { // on upload
      if(_formKey.currentState!.validate() && selectedCaff != null) {
        showLoading(context);
        await ref.read(shopNotifier.notifier).uploadCaff(selectedCaff!, int.parse(priceController.text)).then((value) {
          hideLoading(context);
          showOkSnackbar(context, "Caff uploaded");
          Navigator.of(context).pop();
        }).catchError((error) {
          hideLoading(context);
          showErrorSnackbar(context, "Something went wrong");
        });
      }
    } else {  // on edit
      showLoading(context);
      await ref.read(shopNotifier.notifier).editCaff(widget.caffData!.id, selectedCaff!, int.parse(priceController.text)).then((value) {
        hideLoading(context);
        showOkSnackbar(context, "Caff edited");
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }).catchError((error) {
        hideLoading(context);
        showErrorSnackbar(context, "Something went wrong");
      });
    }


  }
}
