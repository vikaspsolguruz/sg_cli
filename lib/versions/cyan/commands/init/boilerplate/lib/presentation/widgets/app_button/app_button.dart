import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/presentation/widgets/app_button/icon_size.dart';
import 'package:newarch/presentation/widgets/app_icons/app_icon.dart';

part 'app_button_size.dart';
part 'app_button_state.dart';
part 'app_button_style.dart';

class AppButton extends StatefulWidget {
  final AppButtonStyle style;
  final AppButtonSize size;
  final AppButtonState state;
  final bool isDestructive;
  final Color? textDecorationColor;

  final String? label;

  final EdgeInsets? padding;

  final bool isIconButton;
  final bool isExpandLabel;

  final AppButtonController? controller;

  /// use the values from [AppIcons]
  final String? appIcon;

  /// use the values from [TablerIcons]
  final IconData? iconData;

  /// use the values from [AppIcons]
  final String? leftSvgIcon;

  /// use the values from [AppColors]
  final Color? leftIconColor;

  /// use the values from [TablerIcons]
  final IconData? leftIconData;

  /// use the values from [AppIcons]
  final String? rightAppIcon;

  /// use the values from [TablerIcons]
  final IconData? rightIconData;

  /// Overrides
  final Color? iconOrTextColorOverride;
  final Color? bgColorOverride;
  final Color? borderColorOverride;
  final double? radiusOverride;
  final double? heightOverride;

  /// `onPanDown` is faster than `onTap`
  /// because it is triggered when the user touches the screen.
  /// Avoid the usage if the button is part of a scrollable widget
  final bool shouldUseOnPanDown;
  final VoidCallback? onPressed;

  /// Adds vertical and horizontal padding to the button
  /// Otherwise the widget tends to take
  /// the full height of the AppBar for some reason
  final bool isAppBarAction;

  final double? appBarActionVerticalPadding;
  final double? appBarActionRightPadding;
  final double? appBarActionLeftPadding;

  final bool fillWidth;
  final double? width;
  final double elevation;

  const AppButton({
    super.key,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.s,
    this.state = AppButtonState.d_efault,
    this.isDestructive = false,
    this.isIconButton = false,
    this.onPressed,
    this.shouldUseOnPanDown = false,
    this.controller,
    this.appIcon,
    this.iconData,
    this.label,
    this.leftSvgIcon,
    this.leftIconData,
    this.leftIconColor,
    this.rightAppIcon,
    this.rightIconData,
    this.isExpandLabel = false,
    this.padding,
    this.iconOrTextColorOverride,
    this.bgColorOverride,
    this.borderColorOverride,
    this.isAppBarAction = false,
    this.appBarActionVerticalPadding,
    this.appBarActionRightPadding,
    this.appBarActionLeftPadding,
    this.fillWidth = false,
    this.width,
    this.heightOverride,
    this.radiusOverride,
    this.textDecorationColor,
    this.elevation = 0,
  }) : assert(
         (isIconButton && (appIcon != null || iconData != null)) || (!isIconButton && (appIcon == null && iconData == null)),
         'icons or iconData should not be null and isIcon should be true',
       ),
       // assert(
       //   (!isIconButton) && label != null,
       //   'label should not be null.',
       // ),
       assert(
         (leftSvgIcon == null && leftIconData == null && rightIconData == null && rightAppIcon == null) || label != null,
         'The assert statement ensures that if any of the '
         'leftIcon, leftIconData, rightIcon, or rightIconData properties '
         'are not null, then the `label` property must also be not null',
       );

  factory AppButton.icon({
    String? appIcon,
    IconData? iconData,
    AppButtonSize? size,
    AppButtonState? state,
    required VoidCallback onPressed,
    bool shouldUseOnPanDown = false,
    Color? iconOrTextColorOverride,
    bool isAppBarAction = false,
    double? appBarActionRightPadding,
  }) {
    assert(
      appIcon != null || iconData != null,
      'icons or iconData should not be null',
    );
    return AppButton(
      style: AppButtonStyle.textOrIcon,
      size: size ?? AppButtonSize.s,
      state: state ?? AppButtonState.d_efault,
      iconData: iconData,
      isIconButton: true,
      appIcon: appIcon,
      onPressed: onPressed,
      shouldUseOnPanDown: shouldUseOnPanDown,
      iconOrTextColorOverride: iconOrTextColorOverride ?? AppColors.shadesWhite,
      isAppBarAction: isAppBarAction,
      appBarActionRightPadding: appBarActionRightPadding,
    );
  }

  factory AppButton.primary({
    required String label,
    AppButtonSize? size,
    AppButtonState? state,
    required VoidCallback onPressed,
    bool shouldUseOnPanDown = false,
    Color? iconOrTextColorOverride,
    bool isAppBarAction = false,
    bool? showLoader,
    double? radiusOverride,
    double? heightOverride,
  }) {
    return AppButton(
      size: size ?? AppButtonSize.s,
      state: state ?? AppButtonState.d_efault,
      label: label,
      onPressed: onPressed,
      shouldUseOnPanDown: shouldUseOnPanDown,
      iconOrTextColorOverride: iconOrTextColorOverride,
      isAppBarAction: isAppBarAction,
      radiusOverride: radiusOverride,
      heightOverride: heightOverride,
    );
  }

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isLoading = false;

  @override
  void initState() {
    widget.controller?.addCallbacks(
      startLoading: _startLoading,
      stopLoading: _stopLoading,
      state: this,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    widget.controller?.addCallbacks(
      startLoading: _startLoading,
      stopLoading: _stopLoading,
      state: this,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller?.addCallbacks(
      state: null,
    );
    super.dispose();
  }

  void _startLoading() => WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) => setState(() {
      if (!mounted) return;
      isLoading = true;
    }),
  );

  void _stopLoading() => WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (!mounted) return;
    setState(() => isLoading = false);
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.isIconButton) {
      child = _icon(svgIconPath: widget.appIcon, iconData: widget.iconData, color: widget.iconOrTextColorOverride);
    } else if ((widget.leftSvgIcon != null || widget.leftIconData != null) && (widget.rightAppIcon != null || widget.rightIconData != null)) {
      child = _buttonWithLeftAndRightIcon();
    } else if (widget.leftSvgIcon != null || widget.leftIconData != null) {
      child = _buildWithLeftIcon();
    } else if (widget.rightAppIcon != null || widget.rightIconData != null) {
      child = _buildWithRightIcon();
    } else {
      child = _buildTextButton();
    }

    // Avoid using `Center` because it will take unlimited space
    final Widget centeredChild = Stack(
      alignment: Alignment.center,
      children: [
        isLoading ? _loader() : child,
      ],
    );

    final decoration = widget.style.decoration(
      widget.state,
      isDestructive: widget.isDestructive,
      bgColorOverride: widget.bgColorOverride,
      borderColorOverride: widget.borderColorOverride,
      radiusOverride: widget.radiusOverride,
      size: widget.size,
    );

    final borderRadius = BorderRadius.circular(widget.radiusOverride ?? kBorderRadius);

    final Widget view = SizedBox(
      height: widget.heightOverride ?? widget.size.height,
      width: widget.isIconButton
          ? widget.heightOverride ?? widget.size.height
          : widget.fillWidth
          ? double.infinity
          : widget.width,
      child: Material(
        elevation: widget.elevation,
        color: decoration?.color,
        shadowColor: const Color(0xFF181B25).withValues(alpha: 0.04),

        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: widget.style == AppButtonStyle.outline
              ? BorderSide(
                  color: widget.borderColorOverride ?? widget.style._getOutlineStateBorderColor(widget.state, widget.isDestructive),
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTapDown: widget.shouldUseOnPanDown ? (_) => widget.onPressed?.call() : null,
          onTap: !widget.shouldUseOnPanDown && widget.state != AppButtonState.disabled
              ? () {
                  if (isLoading) return;
                  widget.onPressed?.call();
                }
              : null,

          borderRadius: borderRadius,
          child: Padding(
            padding: widget.padding ?? _padding() ?? EdgeInsets.zero,
            child: centeredChild,
          ),
        ),
      ),
    );

    return view;
  }

  Widget _loader() {
    if (Platform.isAndroid) {
      final size = widget.size.height * 0.4;
      return SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          color: widget.iconOrTextColorOverride ?? widget.style.getTextColor(widget.state, isDestructive: widget.isDestructive),
          strokeWidth: size * 0.1,
        ),
      );
    }
    return CupertinoActivityIndicator(
      color: widget.iconOrTextColorOverride ?? widget.style.getTextColor(widget.state, isDestructive: widget.isDestructive),
      radius: (widget.size.textStyle.fontSize ?? 10) * 0.6,
    );
  }

  Widget _buttonWithLeftAndRightIcon() {
    return Row(
      children: [
        _icon(svgIconPath: widget.leftSvgIcon, iconData: widget.leftIconData),
        const Spacer(),
        _getText(),
        const Spacer(),
        _icon(svgIconPath: widget.rightAppIcon, iconData: widget.rightIconData),
      ],
    );
  }

  Widget _buildWithLeftIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _icon(svgIconPath: widget.leftSvgIcon, iconData: widget.leftIconData, color: widget.state == AppButtonState.disabled ? AppColors.textNeutralDisable : widget.leftIconColor),
        widget.isExpandLabel ? const Spacer() : const SizedBox(width: 13),
        _getText(),
        widget.isExpandLabel ? const Spacer() : const SizedBox(),
      ],
    );
  }

  Widget _buildWithRightIcon() {
    return Row(
      children: [
        const Spacer(),
        _getText(),
        const Spacer(),
        _icon(svgIconPath: widget.rightAppIcon, iconData: widget.rightIconData),
      ],
    );
  }

  /*  Widget _wrapIt(List<Widget> children) {
    return Wrap(
      spacing: size.gap,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }*/
  Widget _buildTextButton() {
    return _getText();
  }

  // Common
  Text _getText() {
    return Text(
      widget.label!,
      textAlign: TextAlign.center,
      style: widget.size.textStyle.copyWith(
        color: _getTextColor(),
        fontWeight: _getFontWeight(),
        decorationColor: widget.textDecorationColor,
        height: 0,
        decoration: widget.style == AppButtonStyle.link ? TextDecoration.underline : null,
      ),
      maxLines: 1,
    );
  }

  Widget _icon({String? svgIconPath, IconData? iconData, Color? color}) {
    if (svgIconPath != null) {
      return AppIcon(
        svgIconPath,
        color: color,
        size: widget.size.iconSize,
        shouldIgnoreColorFilter: widget.leftIconColor == null,
      );
    } else if (iconData != null) {
      return SizedBox(
        height: widget.heightOverride,
        width: widget.width,
        child: Icon(
          iconData,
          color: color,
          size: widget.size.iconSize,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Color _getTextColor() {
    if (widget.iconOrTextColorOverride != null) {
      return widget.iconOrTextColorOverride!;
    }
    if (isLoading) {
      return Colors.transparent;
    } else {
      return widget.style.getTextColor(widget.state, isDestructive: widget.isDestructive);
    }
  }

  FontWeight? _getFontWeight() {
    return widget.size.textStyle.fontWeight;
  }

  EdgeInsets? _padding() {
    if (widget.isIconButton) {
      return EdgeInsets.zero;
    }
    switch (widget.style) {
      case AppButtonStyle.primary:
      case AppButtonStyle.secondary:
      case AppButtonStyle.outline:
        return widget.size.padding;
      case AppButtonStyle.link:
      case AppButtonStyle.textOrIcon:
        return EdgeInsets.zero;
    }
  }
}

class AppButtonController {
  void Function()? _startLoading;
  void Function()? _stopLoading;
  _AppButtonState? _state;

  void addCallbacks({void Function()? startLoading, void Function()? stopLoading, required _AppButtonState? state}) {
    _startLoading = startLoading;
    _stopLoading = stopLoading;
    _state = state;
  }

  bool get isLoading => _state?.isLoading ?? false;

  void startLoading() {
    if (_startLoading == null) {
      xPrint("Button controller is not bound", title: "AppButtonController");
      return;
    }
    _startLoading!.call();
  }

  void stopLoading() {
    if (_startLoading == null) {
      xPrint("Button controller is not bound", title: "AppButtonController");
      return;
    }
    _stopLoading!.call();
  }
}
