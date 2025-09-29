import 'package:flutter/material.dart';

import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/styling/input_decorations.dart';

enum AppThemeEnum { darkTheme, lightTheme }

class AppThemesData {
  static final Map<AppThemeEnum, ThemeData> themeData = <AppThemeEnum, ThemeData>{
    AppThemeEnum.lightTheme: ThemeData(
      primaryColor: AppColors.brand.shade600,
      primaryColorLight: AppColors.brand.shade600,
      primaryColorDark: AppColors.brand.shade600,
      scaffoldBackgroundColor: AppColors.bgNeutralLight50,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgNeutralLight50,
        foregroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
      ),
      bottomSheetTheme: BottomSheetThemeData(dragHandleColor: AppColors.iconNeutralPressed, dragHandleSize: const Size(38, 4)),
      inputDecorationTheme: InputDecorationTheme(labelStyle: InputDecorations.labelStyleBright, hintStyle: InputDecorations.hintStyleBright, isDense: true),
      tabBarTheme: TabBarThemeData(indicatorColor: AppColors.brand.shade600, labelColor: AppColors.shadesBlack, unselectedLabelColor: AppColors.textNeutralDisable),
      colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.white, primarySwatch: AppColors.brand, accentColor: AppColors.brand.shade700),
    ),
    AppThemeEnum.darkTheme: ThemeData(
      primaryColor: AppColors.brand.shade600,
      primaryColorLight: AppColors.brand.shade600,
      primaryColorDark: AppColors.brand.shade600,
      scaffoldBackgroundColor: AppColors.bgNeutralLight50,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgNeutralLight50,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
      ),
      bottomSheetTheme: BottomSheetThemeData(dragHandleColor: AppColors.iconNeutralPressed, dragHandleSize: const Size(38, 4)),
      // fontFamily: FontFamily.inter,
      inputDecorationTheme: InputDecorationTheme(labelStyle: InputDecorations.labelStyleBright, hintStyle: InputDecorations.hintStyleBright, isDense: true),
      tabBarTheme: TabBarThemeData(labelColor: AppColors.shadesBlack, indicatorColor: AppColors.brand.shade600, unselectedLabelColor: AppColors.textNeutralDisable),
      colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.black, primarySwatch: AppColors.brand, accentColor: AppColors.brand.shade700, brightness: Brightness.dark),
    ),
  };
}
