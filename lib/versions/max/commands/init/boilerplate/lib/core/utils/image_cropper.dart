import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:croppy/croppy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/core/utils/extensions.dart';

FutureOr<XFile?> cropImage(XFile rawFile, {BuildContext? context, int size = 512}) async {
  CropImageResult? croppedResult;
  try {
    final imageProvider = FileImage(File(rawFile.path));

    croppedResult = await showAdaptiveImageCropper(
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

  // Resize image to max 200x200 if needed (maintaining aspect ratio)
  final resizedImage = await _resizeImageIfNeeded(croppedResult.uiImage, maxSize: size);

  // Convert Image to bytes on main thread (ui.Image can't be sent to isolates)
  final byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return null;

  // Dispose images to free memory
  // Only dispose original image if it's different from resized (resize creates a new image)
  if (resizedImage != croppedResult.uiImage) {
    croppedResult.uiImage.dispose();
  }
  resizedImage.dispose();

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

// Resize image if it exceeds maxSize, maintaining aspect ratio
Future<ui.Image> _resizeImageIfNeeded(ui.Image image, {required int maxSize}) async {
  final width = image.width;
  final height = image.height;

  // If image is already within bounds, return it as-is
  if (width <= maxSize && height <= maxSize) {
    return image;
  }

  // Calculate new dimensions maintaining aspect ratio
  final double scaleFactor = maxSize / (width > height ? width : height);
  final int newWidth = (width * scaleFactor).round();
  final int newHeight = (height * scaleFactor).round();

  // Create a picture recorder and canvas for resizing
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(
    recorder,
    ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
  );

  // Draw the image scaled to new dimensions
  canvas.drawImageRect(
    image,
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
    ui.Paint()..filterQuality = ui.FilterQuality.high,
  );

  // Convert canvas to image
  final picture = recorder.endRecording();
  final resizedImage = await picture.toImage(newWidth, newHeight);
  picture.dispose();

  return resizedImage;
}

/// Resize XFile image if needed and return as XFile
Future<XFile?> resizeXFileImage(XFile imageFile, {int maxSize = 512}) async {
  try {
    // Load XFile as ui.Image
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    final uiImage = frameInfo.image;

    // Resize image if needed
    final resizedImage = await _resizeImageIfNeeded(uiImage, maxSize: maxSize);

    // Convert ui.Image to bytes
    final byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      if (resizedImage != uiImage) {
        uiImage.dispose();
      }
      resizedImage.dispose();
      codec.dispose();
      return null;
    }

    // Dispose images to free memory
    // Only dispose original image if it's different from resized (resize creates a new image)
    if (resizedImage != uiImage) {
      uiImage.dispose();
    }
    resizedImage.dispose();
    codec.dispose();

    // Create a new path for the resized image
    final originalPath = imageFile.path;
    final extension = originalPath.split('.').last;
    final pathWithoutExtension = originalPath.substring(0, originalPath.lastIndexOf('.'));
    final resizedPath = '${pathWithoutExtension}_resized.$extension';

    // Write to file using isolate
    final filePath = await compute(
      _writeImageToFile,
      _FileWriteParams(
        bytes: byteData.buffer.asUint8List(),
        outputPath: resizedPath,
      ),
    );

    if (filePath == null) return null;
    return XFile(filePath);
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
    return null;
  }
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
