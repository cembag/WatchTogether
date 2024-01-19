import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class AppColors {

  /// COLORS
  static final barColor = onScaffoldBackgroundColor;
  static final bottomNavBarColor = barColor;
  static const dialogBackgroundColor = scaffoldBackgroundColor;
  static const bottomSheetBackgroundColor = scaffoldBackgroundColor;
  static final borderColor = dividerColor;
  static const goBackButtonBackgroundColor = cardColor;
  static final barBorderColor = backgroundDark4;
  static const  appBarColor = Color.fromRGBO(16, 16, 20, 1);
  // // static const  appBarColor = Color.fromRGBO(255, 255, 255, 1);
  static const _leeway = 4;

  static final backgroundDark5 = backgroundDark4.changeColor(all: -_leeway);
  static final backgroundDark4Black = backgroundDark3.changeColor(r: -_leeway, g: -_leeway, b: -10);
  static final backgroundDark4 = backgroundDark3.changeColor(all: -_leeway);
  static final backgroundDark3Black = backgroundDark2.changeColor(r: -_leeway, g: -_leeway, b: -10);
  static final backgroundDark3 = backgroundDark2.changeColor(all: -_leeway);
  static final backgroundDark2Black = backgroundDark1.changeColor(r: -_leeway, g: -_leeway, b: -10);
  static final backgroundDark2 = backgroundDark1.changeColor(all: -_leeway);
  static final backgroundDark1 = scaffoldBackgroundColor.changeColor(all: -_leeway);
  static const scaffoldBackgroundColor = Color.fromRGBO(24, 24, 28, 1);
  static final onScaffoldBackgroundColor = backgroundLight1;
  static final backgroundLight1 = scaffoldBackgroundColor.changeColor(all: _leeway);
  static final backgroundLight2 = backgroundLight1.changeColor(all: _leeway);
  static final backgroundLight3 = backgroundLight2.changeColor(all: _leeway);
  static final backgroundLight4 = backgroundLight3.changeColor(all: _leeway);
  static const scaffoldSplashColor = Color.fromRGBO(42, 43, 48, 1);

  static const completionBackgroundColor = Color.fromRGBO(20, 20, 24, 1);
  static const completionCardColor = Color.fromRGBO(32, 32, 36, 1);

  /// TEXT
  
  // White
  static const textWhiteLight1 = Color.fromRGBO(250, 250, 253, 1);
  static const textWhiteLight2 = Color.fromRGBO(235, 235, 238, 1);
  static const textWhiteLight3 = Color.fromRGBO(220, 220, 223, 1);
  static const textWhiteBase = Color.fromRGBO(205, 205, 205, 1);
  static const textWhiteDark1 = Color.fromRGBO(190, 190, 193, 1);
  static const textWhiteDark2 = Color.fromRGBO(175, 175, 178, 1);
  static const textWhiteDark3 = Color.fromRGBO(160, 160, 163, 1);

  // Grey
  static const textGreyLight1 = Color.fromRGBO(145, 145, 148, 1);
  static const textGreyLight2 = Color.fromRGBO(130, 145, 148, 1);
  static const textGreyLight3 = Color.fromRGBO(115, 115, 118, 1);
  static const textGreyBase = Color.fromRGBO(100, 100, 103, 1);
  static const textGreyDark1 = Color.fromRGBO(85, 85, 88, 1);
  static const textGreyDark2 = Color.fromRGBO(70, 70, 73, 1);
  static const textGreyDark3 = Color.fromRGBO(55, 55, 58, 1);

  // Black
  static const textBlackLight1 = Color.fromRGBO(42, 42, 45, 1);
  static const textBlackLight2 = Color.fromRGBO(36, 36, 39, 1);
  static const textBlackLight3 = Color.fromRGBO(30, 30, 33, 1);
  static const textBlackBase = Color.fromRGBO(24, 24, 27, 1);
  static const textBlackDark1 = Color.fromRGBO(18, 18, 21, 1);
  static const textBlackDark2 = Color.fromRGBO(12, 12, 14, 1);
  static const textBlackDark3 = Color.fromRGBO(6, 6, 8, 1);

  // static const textBase = Color.fromRGBO(r, g, b, opacity)

  // static const cardColor = Color.fromRGBO(38, 39, 41, 1);
  static const cardColor = Color.fromRGBO(34, 35, 40, 1);
  static const blackGrey = Color.fromRGBO(52, 52, 52, 1);
  static const cardSplashColor = Color.fromRGBO(52, 52, 52, 1);
  static const primaryTextColor = Color.fromRGBO(245, 245, 245, 1);
  static const secondaryTextColor = Color.fromRGBO(220, 220, 220, 1);
  static const whiteGrey = Color.fromRGBO(200, 200, 200, 1);
  static const whiteGrey2 = Color.fromRGBO(180, 180, 180, 1);
  static const primaryButtonTextColor = Color.fromRGBO(240, 240, 240, 1);
  static const greyTextColor = Color.fromRGBO(120, 120, 120, 1);
  static const greySmoothTextColor = Color.fromRGBO(100, 100, 100, 1);
  // static const themeColor = Color.fromRGBO(224, 79, 27, 1);
  // static const onThemeColor = Color.fromRGBO(216, 75, 24, 1);
  static const themeColor = Color.fromRGBO(255, 11, 55, 1);
  static const onThemeColor = Color.fromRGBO(244, 16, 111, 1);
  // static const themeColor = Color.fromRGBO(223, 49, 51, 1);
  // static const onThemeColor = Color.fromRGBO(216, 46, 48, 1);
  static const brandColor = Color.fromRGBO(36, 52, 229, 1);
  static const onBrandColor = Color.fromRGBO(32, 48, 224, 1);
  static const errorColor = Color.fromRGBO(184, 32, 18, 1);
  static const onErrorColor = Color.fromRGBO(196, 36, 20, 1);
  // static const onErrorColor = Color.fromRGBO(221, 44, 28, 1);
  static const surfaceColor = Color.fromRGBO(120, 120, 120, 1);
  static const onSurfaceColor = Color.fromRGBO(142, 142, 142, 1);
  // static const dividerColor = Color.fromRGBO(48, 49, 50, 1);
  static final dividerColor = backgroundLight1;
  // static const barBorderColor = Color.fromRGBO(26, 27, 34, 1);
  static final hintColor = Colors.grey.shade300;
  static final shadowColorGrey = Colors.grey.shade400;
  static const shadowColorBlack = Colors.black;
  static const shadowColorBlackSmooth = Color.fromRGBO(20, 20, 20, 1);
  static final shadowColorWhite = Colors.white.withOpacity(.2);
  static final shadowColorTheme = AppColors.themeColor.withOpacity(.2);
  static final shadowColorBrand = AppColors.brandColor.withOpacity(.2);
  
  // static const blackV2 = Color.fromRGBO(18, 18, 18, 1);
  // static const scaffoldBackgroundColor = Color.fromRGBO(12, 12, 12, 1);
  // static const onScaffoldBackgroundColor = Color.fromRGBO(16, 16, 16, 1);
  // static const scaffoldSplashColor = Color.fromRGBO(24, 24, 24, 1);
  // static const cardColor = Color.fromRGBO(24, 24, 24, 1);
  // static const blackGrey = Color.fromRGBO(42, 42, 42, 1);
  // static const cardSplashColor = Color.fromRGBO(52, 52, 52, 1);
  // static const primaryTextColor = Color.fromRGBO(245, 245, 245, 1);
  // static const secondaryTextColor = Color.fromRGBO(220, 220, 220, 1);
  // static const whiteGrey = Color.fromRGBO(200, 200, 200, 1);
  // static const whiteGrey2 = Color.fromRGBO(180, 180, 180, 1);
  // static const primaryButtonTextColor = Color.fromRGBO(240, 240, 240, 1);
  // static const greyTextColor = Color.fromRGBO(120, 120, 120, 1);
  // static const greySmoothTextColor = Color.fromRGBO(100, 100, 100, 1);
  // static const themeColor = Color.fromRGBO(224, 79, 27, 1);
  // static const onThemeColor = Color.fromRGBO(216, 75, 24, 1);
  // // static const themeColor = Color.fromRGBO(223, 49, 51, 1);
  // // static const onThemeColor = Color.fromRGBO(216, 46, 48, 1);
  // static const brandColor = Color.fromRGBO(36, 52, 229, 1);
  // static const onBrandColor = Color.fromRGBO(32, 48, 224, 1);
  // static const errorColor = Color.fromRGBO(184, 32, 18, 1);
  // static const onErrorColor = Color.fromRGBO(196, 36, 20, 1);
  // // static const onErrorColor = Color.fromRGBO(221, 44, 28, 1);
  // static const surfaceColor = Color.fromRGBO(120, 120, 120, 1);
  // static const onSurfaceColor = Color.fromRGBO(142, 142, 142, 1);
  // static const dividerColor = Color.fromRGBO(32, 32, 32, 1);
  // static final hintColor = Colors.grey.shade300;
  // static final shadowColorGrey = Colors.grey.shade400;
  // static const shadowColorBlack = Colors.black;
  // static const shadowColorBlackSmooth = Color.fromRGBO(20, 20, 20, 1);
  // static final shadowColorWhite = Colors.white.withOpacity(.2);
  // static final shadowColorTheme = AppColors.themeColor.withOpacity(.2);
  // static final shadowColorBrand = AppColors.brandColor.withOpacity(.2);

  /// GRADIENTS
  static const themeGradient = LinearGradient(colors: [Color.fromARGB(255, 238, 122, 101), AppColors.themeColor], begin: Alignment.topCenter, end: Alignment.bottomCenter,);
  static const greyGradient = LinearGradient(colors: [Color.fromARGB(255, 199, 198, 198), Colors.grey,], begin: Alignment.topCenter, end: Alignment.bottomCenter,);
  
  /// SHADOWS
  static const shadowTextBlackForTitle = BoxShadow(
    offset: AppConstants.offsetSmall,
    blurRadius: AppConstants.zero,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorBlack
  );
  static const shadowTextBlackForText = BoxShadow(
    offset: AppConstants.offsetSmall,
    blurRadius: AppConstants.zero,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorBlackSmooth
  );
  static final shadowSmoothWhite = BoxShadow(
    offset: AppConstants.offsetYMedium,
    blurRadius: AppConstants.blurRadiusSmall,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorWhite
  );
  static const shadowSmoothBlack = BoxShadow(
    offset: AppConstants.offsetYMedium,
    blurRadius: AppConstants.blurRadiusSmall,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorBlack
  );
  static const shadowSmoothBlack2 = BoxShadow(
    offset: AppConstants.offsetYMedium,
    blurRadius: AppConstants.blurRadiusSmall,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorBlackSmooth
  );
  static final shadowSmoothGrey = BoxShadow(
    offset: AppConstants.offsetYMedium,
    blurRadius: AppConstants.blurRadiusSmall,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorGrey
  );
  static final shadowSmoothTheme = BoxShadow(
    offset: AppConstants.offsetYMedium,
    blurRadius: AppConstants.blurRadiusSmall,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorTheme
  );
  static final shadowSmoothBrand = BoxShadow(
    offset: AppConstants.offsetYMedium,
    blurRadius: AppConstants.blurRadiusSmall,
    spreadRadius: AppConstants.zero,
    color: AppColors.shadowColorBrand
  );
}