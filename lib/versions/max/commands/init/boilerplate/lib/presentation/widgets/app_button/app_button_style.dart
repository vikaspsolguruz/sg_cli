part of 'app_button.dart';

enum AppButtonStyle {
  primary,
  secondary,
  outline,
  link,
  textOrIcon,
}

extension AppButtonStyleBoxDecorations on AppButtonStyle {
  BoxDecoration? decoration(
    AppButtonState state, {
    bool isDestructive = false,
    Color? bgColorOverride,
    required AppButtonSize size,
    Color? borderColorOverride,
    double? radiusOverride,
  }) {
    final double radius = radiusOverride ?? size.borderRadius;
    switch (this) {
      case AppButtonStyle.primary:
        final Color color = bgColorOverride ?? _getPrimaryColor(state, isDestructive);
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        );
      case AppButtonStyle.secondary:
        final Color color = bgColorOverride ?? _getSecondaryColor(state, isDestructive);
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        );
      case AppButtonStyle.outline:
        return BoxDecoration(
          color: bgColorOverride ?? _getOutlineStateBgColor(state, isDestructive),
          border: Border.all(
            color: borderColorOverride ?? _getOutlineStateBorderColor(state, isDestructive),
          ),
          borderRadius: BorderRadius.circular(radius),
        );
      case AppButtonStyle.link:
      case AppButtonStyle.textOrIcon:
        return BoxDecoration(
          color: bgColorOverride ?? Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
        );
    }
  }

  Color _getPrimaryColor(AppButtonState state, bool isDestructive) {
    switch (state) {
      case AppButtonState.d_efault:
        return isDestructive ? AppState.colors.bgErrorDefault : AppState.colors.bgBrandDefault;
      case AppButtonState.hover:
        return isDestructive ? AppState.colors.bgErrorHover : AppState.colors.bgBrandHover;
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.bgErrorPressed : AppState.colors.bgBrandPressed;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.bgErrorDisabled : AppState.colors.bgNeutralDisabled;
    }
  }

  Color _getSecondaryColor(AppButtonState state, bool isDestructive) {
    switch (state) {
      case AppButtonState.d_efault:
        return isDestructive ? AppState.colors.bgErrorLight50 : AppState.colors.bgBrandLight50;
      case AppButtonState.hover:
        return isDestructive ? AppState.colors.bgErrorLight100 : AppState.colors.bgBrandLight100;
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.bgErrorLight200 : AppState.colors.bgBrandLight200;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.bgNeutralDisabled : AppState.colors.bgNeutralDisabled;
    }
  }

  Color _getOutlineStateBorderColor(
    AppButtonState state,
    bool isDestructive,
  ) {
    switch (state) {
      case AppButtonState.d_efault:
        return isDestructive ? AppState.colors.strokeErrorDisabled : AppState.colors.strokeNeutralLight200;
      case AppButtonState.hover:
        return isDestructive ? AppState.colors.strokeErrorDisabled : AppState.colors.strokeNeutralLight200;
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.strokeErrorDisabled : AppState.colors.strokeNeutralDisabled;
      case AppButtonState.disabled:
        return Colors.transparent;
    }
  }

  Color? _getOutlineStateBgColor(
    AppButtonState state,
    bool isDestructive,
  ) {
    switch (state) {
      case AppButtonState.d_efault:
        return isDestructive ? AppState.colors.bgShadesWhite : AppState.colors.bgShadesWhite;
      case AppButtonState.hover:
        return isDestructive ? AppState.colors.bgErrorLight50 : AppState.colors.bgShadesWhite;
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.bgShadesWhite : AppState.colors.bgShadesWhite;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.bgNeutralDisabled : AppState.colors.bgNeutralDisabled;
    }
  }
}

extension AppButtonStyleTextColors on AppButtonStyle {
  Color getTextColor(
    AppButtonState state, {
    bool isDestructive = false,
  }) {
    switch (this) {
      case AppButtonStyle.primary:
        return _getPrimaryColor(state, isDestructive);
      case AppButtonStyle.secondary:
        return _getSecondaryColor(state, isDestructive);
      case AppButtonStyle.outline:
        return _getOutlineColor(state, isDestructive);
      case AppButtonStyle.link:
      case AppButtonStyle.textOrIcon:
        return _getLinkColor(state, isDestructive);
    }
  }

  Color _getPrimaryColor(AppButtonState state, bool isDestructive) {
    switch (state) {
      case AppButtonState.d_efault:
      case AppButtonState.hover:
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.textNeutralWhite : AppState.colors.textNeutralWhite;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.textNeutralLight : AppState.colors.textNeutralDisable;
    }
  }

  Color _getSecondaryColor(AppButtonState state, bool isDestructive) {
    switch (state) {
      case AppButtonState.d_efault:
      case AppButtonState.hover:
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.textNeutralDisable : AppState.colors.textNeutralDisable;
    }
  }

  Color _getOutlineColor(AppButtonState state, bool isDestructive) {
    switch (state) {
      case AppButtonState.d_efault:
      case AppButtonState.hover:
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textNeutralPrimary;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.textNeutralDisable : AppState.colors.textNeutralDisable;
    }
  }

  Color _getLinkColor(AppButtonState state, bool isDestructive) {
    switch (state) {
      case AppButtonState.d_efault:
      case AppButtonState.hover:
      case AppButtonState.focus:
        return isDestructive ? AppState.colors.textErrorSecondary : AppState.colors.textBrandSecondary;
      case AppButtonState.disabled:
        return isDestructive ? AppState.colors.textNeutralDisable : AppState.colors.textNeutralDisable;
    }
  }
}
