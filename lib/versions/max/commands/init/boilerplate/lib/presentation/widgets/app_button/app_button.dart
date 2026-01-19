import 'package:flutter/material.dart';
import 'package:max_arch/app/app_state.dart';
import 'package:max_arch/core/constants/constants.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/presentation/widgets/app_button/app_button_controller.dart';
import 'package:max_arch/presentation/widgets/app_icons/app_icon.dart';
import 'package:max_arch/presentation/widgets/loader.dart';

export 'app_button_controller.dart';

enum ButtonSize { xs, s, m, l, xl }

enum ButtonVariant { primary, secondary, outline, ghost, link }

/// Backward compatibility typedefs
typedef AppButtonSize = ButtonSize;
typedef AppButtonStyle = ButtonVariant;

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.m,
    this.controller,
    this.leftIcon,
    this.leftIconData,
    this.rightIcon,
    this.rightIconData,
    this.isDestructive = false,
    this.isDisabled = false,
    this.expandLabel = false,
    this.fillWidth = false,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.elevation = 0,
    this.bgColor,
    this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final AppButtonController? controller;

  final String? leftIcon;
  final IconData? leftIconData;
  final String? rightIcon;
  final IconData? rightIconData;

  final bool isDestructive;
  final bool isDisabled;
  final bool expandLabel;
  final bool fillWidth;

  final double? width;
  final double? height;
  final double? radius;
  final EdgeInsets? padding;
  final double elevation;

  final Color? bgColor;
  final Color? foregroundColor;
  final Color? borderColor;

  factory AppButton.primary({
    required String label,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    bool fillWidth = false,
    double? width,
    double? height,
    double? radius,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      fillWidth: fillWidth,
      width: width,
      height: height,
      radius: radius,
    );
  }

  factory AppButton.secondary({
    required String label,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    bool fillWidth = false,
    double? width,
    double? height,
    double? radius,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      fillWidth: fillWidth,
      width: width,
      height: height,
      radius: radius,
    );
  }

  factory AppButton.outline({
    required String label,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    bool fillWidth = false,
    double? width,
    double? height,
    double? radius,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      fillWidth: fillWidth,
      width: width,
      height: height,
      radius: radius,
    );
  }

  factory AppButton.ghost({
    required String label,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.ghost,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
    );
  }

  factory AppButton.link({
    required String label,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.link,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
    );
  }

  factory AppButton.withLeftIcon({
    required String label,
    required VoidCallback? onPressed,
    String? icon,
    IconData? iconData,
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    bool fillWidth = false,
    bool expandLabel = false,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: variant,
      size: size,
      controller: controller,
      leftIcon: icon,
      leftIconData: iconData,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      fillWidth: fillWidth,
      expandLabel: expandLabel,
    );
  }

  factory AppButton.withRightIcon({
    required String label,
    required VoidCallback? onPressed,
    String? icon,
    IconData? iconData,
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    bool fillWidth = false,
    bool expandLabel = false,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: variant,
      size: size,
      controller: controller,
      rightIcon: icon,
      rightIconData: iconData,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      fillWidth: fillWidth,
      expandLabel: expandLabel,
    );
  }

  factory AppButton.icon({
    String? icon,
    IconData? iconData,
    required VoidCallback? onPressed,
    ButtonVariant variant = ButtonVariant.ghost,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    double? dimension,
    double? iconSize,
    Color? bgColor,
    Color? iconColor,
    double? radius,
  }) {
    return AppIconButton(
      icon: icon,
      iconData: iconData,
      onPressed: onPressed,
      variant: variant,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      dimension: dimension,
      iconSize: iconSize,
      bgColor: bgColor,
      iconColor: iconColor,
      radius: radius,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return ListenableBuilder(
        listenable: controller!,
        builder: (context, _) => _buildButton(
          isLoading: controller!.isLoading,
          isDisabled: isDisabled || controller!.isDisabled,
        ),
      );
    }
    return _buildButton(isLoading: false, isDisabled: isDisabled);
  }

  Widget _buildButton({required bool isLoading, required bool isDisabled}) {
    final effectiveHeight = height ?? size._height;
    final effectiveRadius = radius ?? kBorderRadius;
    final effectivePadding = padding ?? size._padding;

    final bg = bgColor ?? _backgroundColor(isDisabled);
    final fg = foregroundColor ?? _foregroundColor(isDisabled);
    final border = borderColor ?? _borderColor(isDisabled);

    final borderRadius = BorderRadius.circular(effectiveRadius);

    Widget content;
    if (isLoading) {
      content = CommonLoader(size: size._height);
    } else {
      content = _ContentRow(
        label: _Label(
          text: label,
          style: size._textStyle.copyWith(color: fg),
          isUnderlined: variant == ButtonVariant.link,
        ),
        leftIcon: _buildIcon(leftIcon, leftIconData, fg),
        rightIcon: _buildIcon(rightIcon, rightIconData, fg),
        gap: size._gap,
        expandLabel: expandLabel,
      );
    }

    return SizedBox(
      height: effectiveHeight,
      width: fillWidth ? double.infinity : width,
      child: Material(
        elevation: elevation,
        color: bg,
        shadowColor: AppState.colors.shadesBlack.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border != null ? BorderSide(color: border) : BorderSide.none,
        ),
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onPressed,
          borderRadius: borderRadius,
          child: Padding(
            padding: effectivePadding,
            child: Center(child: content),
          ),
        ),
      ),
    );
  }

  Widget? _buildIcon(String? svgPath, IconData? iconData, Color color) {
    if (svgPath == null && iconData == null) return null;
    if (svgPath != null) {
      return AppIcon(svgPath, color: color, size: size._iconSize);
    }
    return Icon(iconData, color: color, size: size._iconSize);
  }

  Color _backgroundColor(bool disabled) {
    if (disabled) return AppState.colors.bgNeutralDisabled;

    return switch (variant) {
      ButtonVariant.primary => isDestructive ? AppState.colors.bgErrorDefault : AppState.colors.bgBrandDefault,
      ButtonVariant.secondary => isDestructive ? AppState.colors.bgErrorLight50 : AppState.colors.bgBrandLight50,
      ButtonVariant.outline => AppState.colors.bgShadesWhite,
      ButtonVariant.ghost => Colors.transparent,
      ButtonVariant.link => Colors.transparent,
    };
  }

  Color _foregroundColor(bool disabled) {
    if (disabled) return AppState.colors.textNeutralDisable;

    return switch (variant) {
      ButtonVariant.primary => AppState.colors.textNeutralWhite,
      ButtonVariant.secondary => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary,
      ButtonVariant.outline => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textNeutralPrimary,
      ButtonVariant.ghost => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary,
      ButtonVariant.link => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary,
    };
  }

  Color? _borderColor(bool disabled) {
    if (variant != ButtonVariant.outline) return null;
    if (disabled) return Colors.transparent;
    return isDestructive ? AppState.colors.strokeErrorDisabled : AppState.colors.strokeNeutralLight200;
  }
}

class AppIconButton extends AppButton {
  const AppIconButton({
    super.key,
    this.icon,
    this.iconData,
    required super.onPressed,
    super.variant = ButtonVariant.ghost,
    super.size,
    super.controller,
    super.isDestructive,
    super.isDisabled,
    this.dimension,
    this.iconSize,
    super.bgColor,
    this.iconColor,
    super.radius,
  }) : assert(icon != null || iconData != null),
       super(label: '');

  final String? icon;
  final IconData? iconData;
  final double? dimension;
  final double? iconSize;
  final Color? iconColor;

  factory AppIconButton.primary({
    String? icon,
    IconData? iconData,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    double? dimension,
  }) {
    return AppIconButton(
      icon: icon,
      iconData: iconData,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      dimension: dimension,
    );
  }

  factory AppIconButton.outline({
    String? icon,
    IconData? iconData,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    double? dimension,
  }) {
    return AppIconButton(
      icon: icon,
      iconData: iconData,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      dimension: dimension,
    );
  }

  factory AppIconButton.ghost({
    String? icon,
    IconData? iconData,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    double? dimension,
    Color? iconColor,
  }) {
    return AppIconButton(
      icon: icon,
      iconData: iconData,
      onPressed: onPressed,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      dimension: dimension,
      iconColor: iconColor,
    );
  }

  factory AppIconButton.secondary({
    String? icon,
    IconData? iconData,
    required VoidCallback? onPressed,
    ButtonSize size = ButtonSize.m,
    AppButtonController? controller,
    bool isDestructive = false,
    bool isDisabled = false,
    double? dimension,
  }) {
    return AppIconButton(
      icon: icon,
      iconData: iconData,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      controller: controller,
      isDestructive: isDestructive,
      isDisabled: isDisabled,
      dimension: dimension,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return ListenableBuilder(
        listenable: controller!,
        builder: (context, _) => _buildButton(
          isLoading: controller!.isLoading,
          isDisabled: isDisabled || controller!.isDisabled,
        ),
      );
    }
    return _buildButton(isLoading: false, isDisabled: isDisabled);
  }

  @override
  Widget _buildButton({required bool isLoading, required bool isDisabled}) {
    final effectiveDimension = dimension ?? size._height;
    final effectiveIconSize = iconSize ?? size._iconSize;
    final effectiveRadius = radius ?? effectiveDimension / 2;

    final bg = bgColor ?? _backgroundColor(isDisabled);
    final fg = iconColor ?? _foregroundColor(isDisabled);
    final border = _borderColor(isDisabled);

    final borderRadius = BorderRadius.circular(effectiveRadius);

    Widget content;
    if (isLoading) {
      content = CommonLoader(size: size._height);
    } else {
      if (icon != null) {
        content = AppIcon(icon!, color: fg, size: effectiveIconSize);
      } else {
        content = Icon(iconData, color: fg, size: effectiveIconSize);
      }
    }

    return SizedBox(
      height: effectiveDimension,
      width: effectiveDimension,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border != null ? BorderSide(color: border) : BorderSide.none,
        ),
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onPressed,
          borderRadius: borderRadius,
          child: Center(child: content),
        ),
      ),
    );
  }

  @override
  Color _backgroundColor(bool disabled) {
    if (disabled) return AppState.colors.bgNeutralDisabled;

    return switch (variant) {
      ButtonVariant.primary => isDestructive ? AppState.colors.bgErrorDefault : AppState.colors.bgBrandDefault,
      ButtonVariant.secondary => isDestructive ? AppState.colors.bgErrorLight50 : AppState.colors.bgBrandLight50,
      ButtonVariant.outline => AppState.colors.bgShadesWhite,
      ButtonVariant.ghost => Colors.transparent,
      ButtonVariant.link => Colors.transparent,
    };
  }

  @override
  Color _foregroundColor(bool disabled) {
    if (disabled) return AppState.colors.textNeutralDisable;

    return switch (variant) {
      ButtonVariant.primary => AppState.colors.textNeutralWhite,
      ButtonVariant.secondary => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary,
      ButtonVariant.outline => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textNeutralPrimary,
      ButtonVariant.ghost => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary,
      ButtonVariant.link => isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary,
    };
  }

  @override
  Color? _borderColor(bool disabled) {
    if (variant != ButtonVariant.outline) return null;
    if (disabled) return Colors.transparent;
    return isDestructive ? AppState.colors.strokeErrorDisabled : AppState.colors.strokeNeutralLight200;
  }
}

extension on ButtonSize {
  double get _height => switch (this) {
    ButtonSize.xs => 30,
    ButtonSize.s => 36,
    ButtonSize.m => 40,
    ButtonSize.l => 46,
    ButtonSize.xl => 56,
  };

  TextStyle get _textStyle => switch (this) {
    ButtonSize.xs => AppTextStyles.p4Medium,
    ButtonSize.s => AppTextStyles.p3Medium,
    ButtonSize.m => AppTextStyles.p3Medium,
    ButtonSize.l => AppTextStyles.p3Bold,
    ButtonSize.xl => AppTextStyles.p2SemiBold,
  };

  EdgeInsets get _padding => switch (this) {
    ButtonSize.xs => const EdgeInsets.symmetric(horizontal: 14),
    ButtonSize.s => const EdgeInsets.symmetric(horizontal: 18),
    ButtonSize.m => const EdgeInsets.symmetric(horizontal: 20),
    ButtonSize.l => const EdgeInsets.symmetric(horizontal: 22),
    ButtonSize.xl => const EdgeInsets.symmetric(horizontal: 24),
  };

  double get _iconSize => switch (this) {
    ButtonSize.xs => 16,
    ButtonSize.s => 20,
    ButtonSize.m => 20,
    ButtonSize.l => 22,
    ButtonSize.xl => 24,
  };

  double get _gap => switch (this) {
    ButtonSize.xs => 6,
    ButtonSize.s => 8,
    ButtonSize.m => 10,
    ButtonSize.l => 10,
    ButtonSize.xl => 12,
  };
}

class _Label extends StatelessWidget {
  const _Label({required this.text, required this.style, this.isUnderlined = false});

  final String text;
  final TextStyle style;
  final bool isUnderlined;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: style.copyWith(
        height: 0,
        decoration: isUnderlined ? TextDecoration.underline : null,
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  const _ContentRow({
    required this.label,
    this.leftIcon,
    this.rightIcon,
    required this.gap,
    this.expandLabel = false,
  });

  final Widget label;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double gap;
  final bool expandLabel;

  @override
  Widget build(BuildContext context) {
    if (leftIcon == null && rightIcon == null) return label;

    return Row(
      mainAxisSize: expandLabel ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftIcon != null) ...[
          leftIcon!,
          if (expandLabel) const Spacer() else SizedBox(width: gap),
        ],
        label,
        if (rightIcon != null) ...[
          if (expandLabel) const Spacer() else SizedBox(width: gap),
          rightIcon!,
        ],
      ],
    );
  }
}
