import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/gen/assets.gen.dart';

class ErrorView extends StatelessWidget {
  final String? svgPath;
  final String? title;
  final String? subtitle;
  final void Function()? onRetry;

  const ErrorView({
    super.key,
    this.svgPath,
    required this.title,
    this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: kHorizontalPadding, left: kHorizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 136,
            child: SvgPicture.asset(
              svgPath ?? Assets.images.svg.icError,
              width: 136,
              height: 136,
            ),
          ),
          const SizedBox(height: 16),
          Text(title ?? AppStrings.somethingWentWrong, textAlign: TextAlign.center),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(subtitle!, textAlign: TextAlign.center),
            ),
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(AppStrings.retry.tr, textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }
}
