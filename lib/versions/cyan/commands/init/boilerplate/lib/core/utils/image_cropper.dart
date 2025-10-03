import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:croppy/croppy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/core/utils/extensions.dart';

FutureOr<XFile?> cropImage(XFile rawFile, {BuildContext? context}) async {
  CropImageResult? croppedResult;
  try {
    final imageProvider = FileImage(File(rawFile.path));

    croppedResult = await showMaterialImageCropper(
      context.secured,
      imageProvider: imageProvider,
      allowedAspectRatios: [const CropAspectRatio(width: 1, height: 1)],
      heroTag: rawFile.path,
      showLoadingIndicatorOnSubmit: true,
    );
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
  }
  if (croppedResult == null) return null;

  // Convert Image to bytes on main thread (ui.Image can't be sent to isolates)
  final byteData = await croppedResult.uiImage.toByteData(format: ImageByteFormat.png);
  if (byteData == null) return null;

  // Create a new path for the cropped image (don't overwrite original)
  final originalPath = rawFile.path;
  final extension = originalPath.split('.').last;
  final pathWithoutExtension = originalPath.substring(0, originalPath.lastIndexOf('.'));
  final croppedPath = '${pathWithoutExtension}_cropped.$extension';

  // Offload file writing to isolate to prevent UI freezing
  final filePath = await compute(
    _writeImageToFile,
    _FileWriteParams(
      bytes: byteData.buffer.asUint8List(),
      outputPath: croppedPath,
    ),
  );
  if (filePath == null) return null;
  return XFile(filePath);
}

// Helper class for passing byte data to isolate
class _FileWriteParams {
  final Uint8List bytes;
  final String outputPath;

  _FileWriteParams({
    required this.bytes,
    required this.outputPath,
  });
}

// Top-level function for isolate execution - writes bytes to file
Future<String?> _writeImageToFile(_FileWriteParams params) async {
  try {
    final file = File(params.outputPath);
    await file.writeAsBytes(params.bytes);
    return file.path;
  } catch (e) {
    return null;
  }
}
