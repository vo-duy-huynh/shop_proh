import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  // Lấy tham chiếu đến ScaffoldMessenger
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (scaffoldMessenger != null) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future<File?> pickImage() async {
  File? image;
  try {
    var file = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (file != null && file.files.isNotEmpty) {
      image = File(file.files.single.path!);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return image;
}
