import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CaffPicker {
  static Future<String?> pickSaveDirectory() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    return result;
  }
}

