import 'package:flutter/material.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/styling/input_decorations.dart';

class AppThemes {
  AppThemes._();

  static ThemeData dark() {
    return ThemeData(
      primaryColor: brand.shade600,
      primaryColorLight: brand.shade600,
      primaryColorDark: brand.shade600,
      scaffoldBackgroundColor: AppColors.light().bgNeutralLight50,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.light().bgNeutralLight50,
        foregroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
      ),
      // fontFamily: FontFamily.inter,
      bottomSheetTheme: BottomSheetThemeData(dragHandleColor: AppColors.light().iconNeutralPressed, dragHandleSize: const Size(38, 4)),
      inputDecorationTheme: InputDecorationTheme(labelStyle: InputDecorations.labelStyleBright, hintStyle: InputDecorations.hintStyleBright, isDense: true),
      tabBarTheme: TabBarThemeData(indicatorColor: brand.shade600, labelColor: AppColors.light().shadesBlack, unselectedLabelColor: AppColors.light().textNeutralDisable),
      colorScheme: ColorScheme.fromSwatch(backgroundColor: AppColors.light().shadesWhite, primarySwatch: brand, accentColor: brand.shade700),
      pageTransitionsTheme: _transitionTheme,
    );
  }

  static ThemeData light() {
    return ThemeData(
      primaryColor: brand.shade600,
      primaryColorLight: brand.shade600,
      primaryColorDark: brand.shade600,
      scaffoldBackgroundColor: AppColors.light().bgNeutralLight50,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.light().bgNeutralLight50,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
      ),
      bottomSheetTheme: BottomSheetThemeData(dragHandleColor: AppColors.light().iconNeutralPressed, dragHandleSize: const Size(38, 4)),
      // fontFamily: FontFamily.inter,
      inputDecorationTheme: InputDecorationTheme(labelStyle: InputDecorations.labelStyleBright, hintStyle: InputDecorations.hintStyleBright, isDense: true),
      tabBarTheme: TabBarThemeData(labelColor: AppColors.light().shadesBlack, indicatorColor: brand.shade600, unselectedLabelColor: AppColors.light().textNeutralDisable),
      colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.black, primarySwatch: brand, accentColor: brand.shade700, brightness: Brightness.dark),
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
