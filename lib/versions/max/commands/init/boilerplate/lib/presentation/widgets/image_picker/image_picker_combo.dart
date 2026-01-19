import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:max_arch/presentation/widgets/image_picker/common_picker_file_view.dart';
import 'package:max_arch/presentation/widgets/image_picker/common_upload_image_widget.dart';

class ImagePickerCombo extends StatefulWidget {
  const ImagePickerCombo({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.isRequired = false,
    this.height = 235,
    this.imageHeight = 145,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
  });

  final XFile? initialValue;
  final void Function(XFile? image) onChanged;
  final bool isRequired;
  final double height;
  final double imageHeight;
  final AutovalidateMode autoValidateMode;

  @override
  State<ImagePickerCombo> createState() => _ImagePickerComboState();
}

class _ImagePickerComboState extends State<ImagePickerCombo> {
  XFile? _currentFile;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<XFile?>(
      initialValue: widget.initialValue,
      validator: widget.isRequired ? (value) => value == null ? 'Please choose an image' : null : null,
      autovalidateMode: widget.autoValidateMode,
      builder: (FormFieldState<XFile?> state) {
        final hasError = state.hasError;
        void setFile(XFile? file) {
          setState(() {
            _currentFile = file;
            state.didChange(file);
            widget.onChanged(file);
          });
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 167),
          curve: Curves.fastOutSlowIn,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _currentFile != null
                  ? CommonPickedFileView(
                      totalHeight: widget.height,
                      imageHeight: widget.imageHeight,
                      imageFile: _currentFile!,
                      onEdit: () async {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setFile(pickedFile);
                        }
                      },
                      onDelete: () => setFile(null),
                    )
                  : CommonUploadImageWidget(
                      height: widget.height,
                      hasError: hasError,
                      onTap: () async {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setFile(pickedFile);
                        }
                      },
                    ),
              if (hasError)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 167),
                  switchInCurve: Curves.fastOutSlowIn,
                  switchOutCurve: Curves.fastOutSlowIn,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: context.colors.textErrorSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
