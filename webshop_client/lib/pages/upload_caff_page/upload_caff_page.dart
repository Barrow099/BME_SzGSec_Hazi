import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/pages/upload_caff_page/upload_caff_widget.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';

class UploadCaffPage extends ConsumerStatefulWidget {
  const UploadCaffPage({super.key});

  @override
  UploadCaffPageState createState() => UploadCaffPageState();
}

class UploadCaffPageState extends ConsumerState<UploadCaffPage> with LoadableDialogMixin {
  final priceController = TextEditingController();

  File? selectedCaff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload caff"),
      ),
      body: const UploadCaffWidget()
    );
  }
}
