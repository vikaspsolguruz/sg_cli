import 'package:flutter/material.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/styling/input_decorations.dart';
import 'package:newarch/gen/fonts.gen.dart';

class AppThemes {
  AppThemes._();

  static ThemeData light() {
    final appColors = AppColors.light();
    return ThemeData(
      primaryColor: brand.shade600,
      primaryColorLight: brand.shade600,
      primaryColorDark: brand.shade600,
      scaffoldBackgroundColor: neutral.shade50,
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.bgNeutralLight50,
        foregroundColor: appColors.shadesBlack,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: appColors.shadesBlack),
      ),
      fontFamily: FontFamily.inter,
      bottomSheetTheme: BottomSheetThemeData(dragHandleColor: appColors.iconNeutralPressed, dragHandleSize: const Size(38, 4)),
      inputDecorationTheme: InputDecorationTheme(labelStyle: InputDecorations.labelStyleBright, hintStyle: InputDecorations.hintStyleBright, isDense: true),
      tabBarTheme: TabBarThemeData(indicatorColor: brand.shade600, labelColor: appColors.shadesBlack, unselectedLabelColor: appColors.textNeutralDisable),
      colorScheme: ColorScheme.fromSwatch(backgroundColor: appColors.shadesWhite, primarySwatch: brand, accentColor: brand.shade700),
      pageTransitionsTheme: _transitionTheme,
    );
  }

  static ThemeData dark() {
    final appColors = AppColors.dark();

    return ThemeData(
      primaryColor: brand.shade600,
      primaryColorLight: brand.shade600,
      primaryColorDark: brand.shade600,
      scaffoldBackgroundColor: appColors.bgNeutralLight50,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: appColors.shadesBlack,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: appColors.shadesBlack),
      ),
      fontFamily: FontFamily.inter,
      bottomSheetTheme: BottomSheetThemeData(dragHandleColor: appColors.iconNeutralPressed, dragHandleSize: const Size(38, 4)),
      inputDecorationTheme: InputDecorationTheme(labelStyle: InputDecorations.labelStyleBright, hintStyle: InputDecorations.hintStyleBright, isDense: true),
      tabBarTheme: TabBarThemeData(indicatorColor: brand.shade600, labelColor: appColors.shadesBlack, unselectedLabelColor: appColors.textNeutralDisable),
      colorScheme: ColorScheme.fromSwatch(backgroundColor: appColors.shadesWhite, primarySwatch: brand, accentColor: brand.shade700, brightness: Brightness.dark),
      pageTransitionsTheme: _transitionTheme,
    );
  }

  static const _transitionTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  );
}
