import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CaffPicker {
  static Future<String?> pickSaveDirectory() async {
    String? result = await FilePicker.platform.getDirectoryPath(dialogTitle: "Select download directory");
    return result;
  }

  static Future<File?> pickCaff() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: "Select caff to upload", type: FileType.any);
    if(result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      return file;
    }
    return null;
  }
}

