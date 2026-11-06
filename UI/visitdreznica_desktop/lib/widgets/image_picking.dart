import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dialogs.dart';

const maxImageBytes = 5 * 1024 * 1024;

typedef PickedImage = ({Uint8List bytes, String fileName, String contentType});

Future<PickedImage?> pickImage(BuildContext context) async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png'],
  );

  if (file == null) {
    return null;
  }

  final bytes = await file.readAsBytes();

  if (bytes.length > maxImageBytes) {
    if (context.mounted) {
      showMessage(context, 'Slika može imati najviše 5 MB.', isError: true);
    }
    return null;
  }

  final contentType = file.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
  return (bytes: bytes, fileName: file.name, contentType: contentType);
}