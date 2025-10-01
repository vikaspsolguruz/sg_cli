import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class CommonPickedFileView extends StatelessWidget {
  const CommonPickedFileView({
    super.key,
    this.totalHeight = 235,
    this.imageHeight = 145,
    required this.imageFile,
    this.onDelete,
    this.onEdit,
  });

  final double totalHeight;
  final double imageHeight;
  final XFile imageFile;
  final void Function()? onDelete;
  final void Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: totalHeight,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.strokeNeutralLight200),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Image.file(
              File(imageFile.path),
              width: 100.w,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.colors.strokeNeutralLight50),
                ),
                alignment: Alignment.center,

                // TODO: Add file type icon based on file type
                // child: AppIcon(Assets.icons.filePng, shouldIgnoreColorFilter: true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(imageFile.name, style: AppTextStyles.p3Medium.withColor(context.colors.textNeutralPrimary), maxLines: 1),
                    FutureBuilder<Uint8List>(
                      future: imageFile.readAsBytes(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          final bytes = snapshot.data!.length;
                          final kB = bytes / 1024;
                          final mB = kB / 1024;
                          return Text(
                            (mB > 1) ? '${mB.toStringAsFixed(1)} MB' : '${kB.toStringAsFixed(0)} KB',
                            style: AppTextStyles.c1Regular.withColor(context.colors.textNeutralSecondary),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(TablerIcons.pencil, color: context.colors.strokeNeutralDisabled),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(TablerIcons.trash, color: context.colors.strokeNeutralDisabled),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
