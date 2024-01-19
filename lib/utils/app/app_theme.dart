import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData get appTheme => ThemeData(
  /// FONTS
  fontFamily: "Roboto",
  /// WIDGETS
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: AppColors.bottomSheetBackgroundColor,),
  appBarTheme: AppBarTheme(
    elevation: 2,
    backgroundColor: AppColors.barColor,
    shadowColor: AppColors.shadowColorBlackSmooth
  ),
  /// COLORS
  datePickerTheme: DatePickerThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), yearStyle: const TextStyle(color: AppColors.surfaceColor)),
  colorScheme: ColorScheme(brightness: Brightness.light, primary: AppColors.themeColor, onPrimary: Colors.white, secondary: AppColors.themeColor, onSecondary: AppColors.themeColor, error: AppColors.errorColor, onError: AppColors.onErrorColor, background: AppColors.scaffoldBackgroundColor, onBackground: AppColors.onScaffoldBackgroundColor, surface: AppColors.surfaceColor, onSurface: AppColors.onSurfaceColor),
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
  dialogBackgroundColor: AppColors.dialogBackgroundColor,
  dividerColor: AppColors.dividerColor,
  cardColor: AppColors.cardColor,
  hintColor: AppColors.hintColor,
);
