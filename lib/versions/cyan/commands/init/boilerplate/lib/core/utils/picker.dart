import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/core/utils/toast/toast.dart';

final _picker = ImagePicker();

class Picker {
  Picker._();

  static Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return null;
      int sizeInBytes = await pickedFile.length();
      double sizeInMB = sizeInBytes / (1024 * 1024);
      if (sizeInMB > 10) {
        Toast.show(AppStrings.imageSizeShouldBeLessThan10MB.tr, isPositive: false);
        return null;
      }
      return pickedFile;
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
      return null;
    }
  }

  static Future<List<XFile>> pickImages({ImageSource source = ImageSource.gallery}) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      for (var pickedFile in pickedFiles) {
        int sizeInBytes = await pickedFile.length();
        double sizeInMB = sizeInBytes / (1024 * 1024);
        if (sizeInMB > 10) {
          Toast.show(AppStrings.imageSizeShouldBeLessThan10MB, isPositive: false);
          return [];
        }
      }
      return pickedFiles;
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
      return [];
    }
  }

  static Future<XFile?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);
      return result?.xFiles.firstOrNull;
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
    }
    return null;
  }

  static Future<List<XFile>> pickFiles({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions, allowMultiple: true);
      return result?.xFiles ?? [];
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
    }
    return [];
  }
}
