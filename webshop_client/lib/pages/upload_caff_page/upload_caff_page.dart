import 'dart:core';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';

import 'package:webshop_client/api/system/caff_picker.dart';
import 'package:webshop_client/pages/upload_caff_page/upload_caff_widget.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';
import 'package:webshop_client/widgets/other/snackbars.dart';
import 'package:webshop_client/widgets/text_fields/login_text_form_field.dart';

class UploadCaffPage extends ConsumerStatefulWidget {
  const UploadCaffPage({super.key});

  @override
  _UploadCaffPageState createState() => _UploadCaffPageState();
}

class _UploadCaffPageState extends ConsumerState<UploadCaffPage> with LoadableDialogMixin {
  final priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? selectedCaff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload caff"),
      ),
      body: const UploadCaffWidget()
    );
  }
}
