import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/gen/assets.gen.dart';

class EmptyView extends StatelessWidget {
  final String? svgPath;
  final String title;
  final String? subtitle;
  final void Function()? onRetry;
  final String? buttonText;

  const EmptyView({
    super.key,
    this.svgPath,
    required this.title,
    this.subtitle,
    this.onRetry,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: kHorizontalPadding, left: kHorizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (svgPath != null)
            SizedBox.square(
              dimension: 136,
              child: SvgPicture.asset(
                svgPath ?? Assets.images.svg.empty.noData,
                width: 136,
                height: 136,
              ),
            ),
          const SizedBox(height: 24),
          Text(title),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(subtitle!, textAlign: TextAlign.center),
            ),
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(buttonText ?? AppStrings.retry, textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }
}
