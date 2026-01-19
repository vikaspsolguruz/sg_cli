import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _darkInstance = AppColors._internal(true);
  static final AppColors _lightInstance = AppColors._internal(false);

  factory AppColors.dark() => _darkInstance;

  factory AppColors.light() => _lightInstance;
  final bool isDarkMode;

  AppColors._internal(this.isDarkMode);

  Color get shadesWhite => isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  Color get shadesBlack => isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  // Text Colors
  // Brand
  Color get textBrandPrimary => isDarkMode ? brand.shade50 : brand.shade900;

  Color get textBrandSecondary => isDarkMode ? brand.shade400 : brand.shade600;

  Color get textBrandDisable => isDarkMode ? brand.shade500 : brand.shade400;

  Color get textBrandLight => isDarkMode ? brand.shade800 : brand.shade100;

  // Green(Secondary)
  Color get textSecondaryPrimary => isDarkMode ? greenSecondary.shade50 : greenSecondary.shade900;

  Color get textSecondarySecondary => isDarkMode ? greenSecondary.shade400 : greenSecondary.shade600;

  Color get textSecondaryDisable => isDarkMode ? greenSecondary.shade600 : greenSecondary.shade400;

  Color get textSecondaryLight => isDarkMode ? greenSecondary.shade800 : greenSecondary.shade100;

  // Yellow (Warning)
  Color get textWarningPrimary => isDarkMode ? yellow.shade50 : yellow.shade900;

  Color get textWarningSecondary => isDarkMode ? yellow.shade400 : yellow.shade600;

  Color get textWarningDisable => isDarkMode ? yellow.shade600 : yellow.shade400;

  Color get textWarningLight => isDarkMode ? yellow.shade800 : yellow.shade100;

  // Green (Success)
  Color get textSuccessPrimary => isDarkMode ? green.shade50 : green.shade900;

  Color get textSuccessSecondary => isDarkMode ? green.shade400 : green.shade600;

  Color get textSuccessDisable => isDarkMode ? green.shade600 : green.shade400;

  Color get textSuccessLight => isDarkMode ? green.shade800 : green.shade100;

  // Red (Error)
  Color get textErrorPrimary => isDarkMode ? red.shade50 : red.shade900;

  Color get textErrorSecondary => isDarkMode ? red.shade400 : red.shade600;

  Color get textErrorDisable => isDarkMode ? red.shade600 : red.shade300;

  Color get textErrorLight => isDarkMode ? red.shade800 : red.shade100;

  // Neutral
  Color get textNeutralPrimary => isDarkMode ? neutral.shade50 : neutral.shade900;

  Color get textNeutralSecondary => isDarkMode ? neutral.shade300 : neutral.shade600;

  Color get textNeutralDisable => isDarkMode ? neutral.shade500 : neutral.shade400;

  Color get textNeutralLight => isDarkMode ? neutral.shade800 : neutral.shade100;

  Color get textNeutralWhite => shadesWhite;

  // Background Colors
  // Brand
  Color get bgBrandDefault => isDarkMode ? brand.shade400 : brand.shade600;

  Color get bgBrandHover => isDarkMode ? brand.shade300 : brand.shade500;

  Color get bgBrandPressed => isDarkMode ? brand.shade500 : brand.shade700;

  Color get bgBrandDisabled => isDarkMode ? brand.shade200 : brand.shade300;

  Color get bgBrandLight50 => isDarkMode ? brand.shade600.withValues(alpha: 0.30) : brand.shade50;

  Color get bgBrandLight100 => isDarkMode ? brand.shade600.withValues(alpha: 0.50) : brand.shade100;

  Color get bgBrandLight200 => isDarkMode ? brand.shade600.withValues(alpha: 0.15) : brand.shade200;

  // Green (Secondary)
  Color get bgSecondaryDefault => isDarkMode ? greenSecondary.shade400 : greenSecondary.shade900;

  Color get bgSecondaryHover => isDarkMode ? greenSecondary.shade300 : greenSecondary.shade500;

  Color get bgSecondaryPressed => isDarkMode ? greenSecondary.shade500 : greenSecondary.shade700;

  Color get bgSecondaryDisabled => isDarkMode ? greenSecondary.shade200 : greenSecondary.shade300;

  Color get bgSecondaryLight50 => isDarkMode ? greenSecondary.shade600.withValues(alpha: 0.30) : greenSecondary.shade50;

  Color get bgSecondaryLight100 => isDarkMode ? greenSecondary.shade600.withValues(alpha: 0.50) : greenSecondary.shade100;

  Color get bgSecondaryLight200 => isDarkMode ? greenSecondary.shade600.withValues(alpha: 0.15) : greenSecondary.shade200;

  // Yellow (Warning)
  Color get bgWarningDefault => isDarkMode ? yellow.shade400 : yellow.shade600;

  Color get bgWarningHover => isDarkMode ? yellow.shade300 : yellow.shade500;

  Color get bgWarningPressed => isDarkMode ? yellow.shade500 : yellow.shade700;

  Color get bgWarningDisabled => isDarkMode ? yellow.shade200 : yellow.shade300;

  Color get bgWarningLight50 => isDarkMode ? yellow.shade600.withValues(alpha: 0.30) : yellow.shade500;

  Color get bgWarningLight100 => isDarkMode ? yellow.shade600.withValues(alpha: 0.15) : yellow.shade100;

  Color get bgWarningLight200 => isDarkMode ? yellow.shade600.withValues(alpha: 0.50) : yellow.shade200;

  // Red (Error)
  Color get bgErrorDefault => isDarkMode ? red.shade400 : red.shade600;

  Color get bgErrorHover => isDarkMode ? red.shade300 : red.shade500;

  Color get bgErrorPressed => isDarkMode ? red.shade500 : red.shade700;

  Color get bgErrorDisabled => isDarkMode ? red.shade200 : red.shade300;

  Color get bgErrorLight50 => isDarkMode ? red.shade600.withValues(alpha: 0.30) : red.shade500;

  Color get bgErrorLight100 => isDarkMode ? red.shade600.withValues(alpha: 0.50) : red.shade100;

  Color get bgErrorLight200 => isDarkMode ? red.shade600.withValues(alpha: 0.15) : red.shade200;

  // Green (Success)
  Color get bgSuccessDefault => isDarkMode ? green.shade400 : green.shade600;

  Color get bgSuccessHover => isDarkMode ? green.shade300 : green.shade500;

  Color get bgSuccessPressed => isDarkMode ? green.shade500 : green.shade700;

  Color get bgSuccessDisabled => isDarkMode ? green.shade200 : green.shade300;

  Color get bgSuccessLight50 => isDarkMode ? green.shade600.withValues(alpha: 0.30) : green.shade500;

  Color get bgSuccessLight100 => isDarkMode ? green.shade600.withValues(alpha: 0.50) : green.shade100;

  Color get bgSuccessLight200 => isDarkMode ? green.shade600.withValues(alpha: 0.15) : green.shade200;

  // Neutral
  Color get bgNeutralDefault => isDarkMode ? neutral.shade600 : neutral.shade800;

  Color get bgNeutralHover => isDarkMode ? neutral.shade400 : neutral.shade500;

  Color get bgNeutralPressed => isDarkMode ? neutral.shade500 : neutral.shade700;

  Color get bgNeutralDisabled => isDarkMode ? neutral.shade200 : neutral.shade100;

  Color get bgNeutralLight50 => isDarkMode ? neutral.shade600.withValues(alpha: 0.15) : neutral.shade50;

  Color get bgNeutralLight100 => isDarkMode ? neutral.shade600.withValues(alpha: 0.35) : neutral.shade100;

  Color get bgNeutralLight200 => isDarkMode ? neutral.shade600.withValues(alpha: 0.55) : neutral.shade200;

  // Shades
  Color get bgShadesWhite => isDarkMode ? shadesBlack : shadesWhite;

  Color get bgShadesBlack => isDarkMode ? shadesWhite : shadesBlack;

  // Icon Colors

  // Brand
  Color get iconBrandPrimary => isDarkMode ? brand.shade200 : brand.shade800;

  Color get iconBrandHover => isDarkMode ? brand.shade300 : brand.shade500;

  Color get iconBrandPressed => isDarkMode ? brand.shade500 : brand.shade400;

  Color get iconBrandDisabled => isDarkMode ? brand.shade600 : brand.shade300;

  // Secondary
  Color get iconSecondaryDefault => isDarkMode ? greenSecondary.shade200 : greenSecondary.shade900;

  Color get iconSecondaryHover => isDarkMode ? greenSecondary.shade300 : greenSecondary.shade500;

  Color get iconSecondaryPressed => isDarkMode ? greenSecondary.shade400 : greenSecondary.shade400;

  Color get iconSecondaryDisabled => isDarkMode ? greenSecondary.shade500 : greenSecondary.shade300;

  Color get iconSecondaryLight50 => isDarkMode ? greenSecondary.shade600.withValues(alpha: 0.30) : greenSecondary.shade50;

  Color get iconSecondaryLight100 => isDarkMode ? greenSecondary.shade600.withValues(alpha: 0.50) : greenSecondary.shade100;

  Color get iconSecondaryLight200 => isDarkMode ? greenSecondary.shade600.withValues(alpha: 0.15) : greenSecondary.shade200;

  // Yellow (Warning)
  Color get iconWarningDefault => isDarkMode ? yellow.shade200 : yellow.shade900;

  Color get iconWarningHover => isDarkMode ? yellow.shade300 : yellow.shade500;

  Color get iconWarningPressed => isDarkMode ? yellow.shade400 : yellow.shade400;

  Color get iconWarningDisabled => isDarkMode ? yellow.shade500 : yellow.shade300;

  // Red (Error)
  Color get iconErrorDefault => isDarkMode ? red.shade200 : red.shade900;

  Color get iconErrorHover => isDarkMode ? red.shade300 : red.shade500;

  Color get iconErrorPressed => isDarkMode ? red.shade400 : red.shade400;

  Color get iconErrorDisabled => isDarkMode ? red.shade500 : red.shade300;

  // Green (Success)
  Color get iconSuccessDefault => isDarkMode ? green.shade200 : green.shade900;

  Color get iconSuccessHover => isDarkMode ? green.shade300 : green.shade500;

  Color get iconSuccessPressed => isDarkMode ? green.shade400 : green.shade400;

  Color get iconSuccessDisabled => isDarkMode ? green.shade500 : green.shade300;

  // Neutral
  Color get iconNeutralDefault => isDarkMode ? neutral.shade100 : neutral.shade900;

  Color get iconNeutralHover => isDarkMode ? neutral.shade300 : neutral.shade500;

  Color get iconNeutralPressed => isDarkMode ? neutral.shade400 : neutral.shade400;

  Color get iconNeutralDisabled => isDarkMode ? neutral.shade500 : neutral.shade300;

  // Stroke Colors

  // Brand
  Color get strokeBrandDefault => isDarkMode ? brand.shade200 : brand.shade700;

  Color get strokeBrandHover => isDarkMode ? brand.shade300 : brand.shade600;

  Color get strokeBrandPressed => isDarkMode ? brand.shade500 : brand.shade800;

  Color get strokeBrandDisabled => isDarkMode ? brand.shade500 : brand.shade300;

  // Yellow (Warning)
  Color get strokeWarningDefault => isDarkMode ? yellow.shade200 : yellow.shade600;

  Color get strokeWarningHover => isDarkMode ? yellow.shade300 : yellow.shade500;

  Color get strokeWarningPressed => isDarkMode ? yellow.shade400 : yellow.shade700;

  Color get strokeWarningDisabled => isDarkMode ? yellow.shade500 : yellow.shade300;

  // Red (Error)
  Color get strokeErrorDefault => isDarkMode ? red.shade200 : red.shade600;

  Color get strokeErrorHover => isDarkMode ? red.shade300 : red.shade500;

  Color get strokeErrorPressed => isDarkMode ? red.shade400 : red.shade700;

  Color get strokeErrorDisabled => isDarkMode ? red.shade500 : red.shade300;

  // Green (Success)
  Color get strokeSuccessDefault => isDarkMode ? green.shade200 : green.shade600;

  Color get strokeSuccessHover => isDarkMode ? green.shade300 : green.shade500;

  Color get strokeSuccessPressed => isDarkMode ? green.shade400 : green.shade700;

  Color get strokeSuccessDisabled => isDarkMode ? green.shade500 : green.shade300;

  // Neutral
  Color get strokeNeutralDefault => isDarkMode ? neutral.shade100 : neutral.shade600;

  Color get strokeNeutralHover => isDarkMode ? neutral.shade200 : neutral.shade500;

  Color get strokeNeutralPressed => isDarkMode ? neutral.shade300 : neutral.shade700;

  Color get strokeNeutralDisabled => isDarkMode ? neutral.shade400 : neutral.shade400;

  Color get strokeNeutralLight50 => isDarkMode ? neutral.shade700 : neutral.shade50;

  Color get strokeNeutralLight100 => isDarkMode ? neutral.shade600 : neutral.shade100;

  Color get strokeNeutralLight200 => isDarkMode ? neutral.shade500 : neutral.shade200;

  // Shades
  Color get strokeShadesWhite => isDarkMode ? shadesBlack : shadesWhite;

  Color get strokeShadesBlack => isDarkMode ? shadesWhite : shadesBlack;

  // Shadows
  Color get dropShadowSmall => const Color(0xFF555555);
}

const MaterialColor brand = MaterialColor(0xFFE36B14, <int, Color>{
  50: Color(0xFFFEF8EE),
  100: Color(0xFFFEF0D6),
  200: Color(0xFFFBDDAD),
  300: Color(0xFFF8C479),
  400: Color(0xFFF4A143),
  500: Color(0xFFF1841E),
  600: Color(0xFFE36B14), // This is typically your primary color
  700: Color(0xFFBC5112),
  800: Color(0xFF954017),
  900: Color(0xFF783716),
  950: Color(0xFF411E0C),
});

const MaterialColor greenSecondary = MaterialColor(0xFF3DB688, <int, Color>{
  50: Color(0xFFF1FAF7),
  100: Color(0xFFDEF4EC),
  200: Color(0xFFBFEAD9),
  300: Color(0xFF8ED9BC),
  400: Color(0xFF58C79D),
  500: Color(0xFF3DB688), // This is typically your primary color
  600: Color(0xFF339871),
  700: Color(0xFF287758),
  800: Color(0xFF1F5C45),
  900: Color(0xFF194A37),
  950: Color(0xFF0F2C20),
});

const MaterialColor indigo = MaterialColor(0xFF6366F1, <int, Color>{
  50: Color(0xFFEEF2FF),
  100: Color(0xFFE0E7FF),
  200: Color(0xFFC7D2FE),
  300: Color(0xFFA5B4FC),
  400: Color(0xFF818CF8),
  500: Color(0xFF6366F1), // This is typically your primary color
  600: Color(0xFF4F46E5),
  700: Color(0xFF4338CA),
  800: Color(0xFF3730A3),
  900: Color(0xFF312E81),
  950: Color(0xFF122368),
});

const MaterialColor yellow = MaterialColor(0xFFF59E0B, <int, Color>{
  50: Color(0xFFFFFBEB),
  100: Color(0xFFFEF3C7),
  200: Color(0xFFFDE68A),
  300: Color(0xFFFDE047),
  400: Color(0xFFFBBF24),
  500: Color(0xFFF59E0B), // This is typically your primary color
  600: Color(0xFFD97706),
  700: Color(0xFFB45309),
  800: Color(0xFF92400E),
  900: Color(0xFF78350F),
  950: Color(0xFF451A03),
});

const MaterialColor red = MaterialColor(0xFFDC2626, <int, Color>{
  50: Color(0xFFFEF2F2),
  100: Color(0xFFFEE2E2),
  200: Color(0xFFFECACA),
  300: Color(0xFFFCA5A5),
  400: Color(0xFFF87171),
  500: Color(0xFFDC2626), // This is typically your primary color
  600: Color(0xFFDC2626),
  700: Color(0xFFB91C1C),
  800: Color(0xFF991B1B),
  900: Color(0xFF7F1D1D),
  950: Color(0xFF451A03),
});

const MaterialColor green = MaterialColor(0xFF22C55E, <int, Color>{
  50: Color(0xFFF0FDF4),
  100: Color(0xFFDCFCE7),
  200: Color(0xFFBBF7D0),
  300: Color(0xFF86EFAC),
  400: Color(0xFF4ADE80),
  500: Color(0xFF22C55E), // This is typically your primary color
  600: Color(0xFF16A34A),
  700: Color(0xFF15803D),
  800: Color(0xFF166534),
  900: Color(0xFF14532D),
  950: Color(0xFF052E16),
});

const MaterialColor lime = MaterialColor(0xFF84CC16, <int, Color>{
  50: Color(0xFFF7FEE7),
  100: Color(0xFFECFCCB),
  200: Color(0xFFD9F99D),
  300: Color(0xFFBEF264),
  400: Color(0xFFA3E635),
  500: Color(0xFF84CC16), // This is typically your primary color
  600: Color(0xFF65A30D),
  700: Color(0xFF4D7C0F),
  800: Color(0xFF3F6212),
  900: Color(0xFF365314),
  950: Color(0xFF1B290A),
});

const MaterialColor purple = MaterialColor(0xFFA855F7, <int, Color>{
  50: Color(0xFFFAF5FF),
  100: Color(0xFFF3E8FF),
  200: Color(0xFFE9D5FF),
  300: Color(0xFFD8B4FE),
  400: Color(0xFFC084FC),
  500: Color(0xFFA855F7), // This is typically your primary color
  600: Color(0xFF9333EA),
  700: Color(0xFF7E22CE),
  800: Color(0xFF6B21A8),
  900: Color(0xFF581C87),
  950: Color(0xFF32104C),
});

const MaterialColor fuchsia = MaterialColor(0xFFD946EF, <int, Color>{
  50: Color(0xFFFDF4FF),
  100: Color(0xFFFAE8FF),
  200: Color(0xFFF5D0FE),
  300: Color(0xFFF0ABFC),
  400: Color(0xFFE879F9),
  500: Color(0xFFD946EF), // This is typically your primary color
  600: Color(0xFFC026D3),
  700: Color(0xFFA21CAF),
  800: Color(0xFF86198F),
  900: Color(0xFF701A75),
  950: Color(0xFF4A044E),
});

const MaterialColor pink = MaterialColor(0xFFEC4899, <int, Color>{
  50: Color(0xFFFDF2F8),
  100: Color(0xFFFCE7F3),
  200: Color(0xFFFBCFE8),
  300: Color(0xFFF9A8D4),
  400: Color(0xFFF472B6),
  500: Color(0xFFEC4899), // This is typically your primary color
  600: Color(0xFFDB2777),
  700: Color(0xFFBE185D),
  800: Color(0xFF9D174D),
  900: Color(0xFF831843),
  950: Color(0xFF500724),
});

const MaterialColor neutral = MaterialColor(0xFF7C7C7C, <int, Color>{
  50: Color(0xFFF8F8F8),
  100: Color(0xFFF2F2F2),
  200: Color(0xFFDCDCDC),
  300: Color(0xFFBDBDBD),
  400: Color(0xFF989898),
  500: Color(0xFF7C7C7C), // This is typically your primary color
  600: Color(0xFF656565),
  700: Color(0xFF525252),
  800: Color(0xFF464646),
  900: Color(0xFF262626),
  950: Color(0xFF1F1F1F),
});

const MaterialColor dark = MaterialColor(0xFF2C2D31, <int, Color>{
  50: Color(0xFF3D3D41),
  100: Color(0xFF38393C),
  200: Color(0xFF36363A),
  300: Color(0xFF333437),
  400: Color(0xFF2E2F33),
  500: Color(0xFF2C2D31), // This is typically your primary color
  600: Color(0xFF272820),
  700: Color(0xFF25262A),
  800: Color(0xFF232427),
  900: Color(0xFF1E1F23),
  950: Color(0xFF121317),
});
