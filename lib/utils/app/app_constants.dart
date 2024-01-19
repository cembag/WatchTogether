import 'package:ecinema_watch_together/services/remote_config_service.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const appBarHeight = 56.0;
  static const bottomNavBarHeight = 46.0;
  static const mHorizontalPadding = 16.0;
  static const tHorizontalPadding = 32.0;
  static const mTopPadding = 20.0;
  static const tTopPadding = 32.0;
  static const mBottomPadding = 20.0;
  static const tBottomPadding = 32.0;
  static const blurRadiusSmall = 5.0;
  static const blurRadiusMedium = 8.0;
  static const blurRadiusLarge = 12.0;
  static const spreadRadiusSmall = 1.0;
  static const spreadRadiusMedium = 2.0;
  static const spreadRadiusLarge = 3.0;
  static const offsetYSmall = Offset(0, 1);
  static const offsetYMedium = Offset(0, 2);
  static const offsetYLarge = Offset(0, 5);
  static const offsetXSmall = Offset(1, 0);
  static const offsetXMedium = Offset(2, 0);
  static const offsetXLarge = Offset(5, 0);
  static const offsetSmall = Offset(1, 1);
  static const offsetMedium = Offset(2, 2);
  static const offsetLarge = Offset(5, 5);
  static const offsetZero = Offset(0, 0);
  static const zero = 0.0;
  // static const localizationDelegates = [
  //   GlobalMaterialLocalizations.delegate,
  //   GlobalWidgetsLocalizations.delegate,
  //   GlobalCupertinoLocalizations.delegate,
  // ];
  static const manAvatarsStartingPoint = 1;
  static const womanAvatarsStartingPoint = 256;
  static const noGenderAvatarsStartingPoint = 512;
  static const manAvatars = 20;
  static const womanAvatars = 18;
  static const noGenderAvatars = 7;
  static const avatars = manAvatars + womanAvatars + noGenderAvatars;
  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('tr', 'TR')
  ];
  static const movieCategories = ["Aksiyon", "Bilim Kurgu", "Biyografi", "Dram", "Fantastik", "Gizem", "Komedi", "Korku", "Macera", "Polisiye", "Romantik", "Tarih"];
  static const movieCategoriesEnglish = ["Action", "Science", "Biography", "Dram", "Fantastic", "Mystery", "Comedy", "Horror", "Adventure", "Detective", "Romantic", "History"];
  // static final abuses = {
  //   "violance": RemoteConfigService.instance.getAbuse(100),
  //   "hate": RemoteConfigService.instance.getAbuse(200),
    
  // };
  static final abuseViolanceOrSexual = RemoteConfigService.instance.getAbuse(100);
  static final abuseHate = RemoteConfigService.instance.getAbuse(200);
  static final abuseSuicideOrSelfHarm = RemoteConfigService.instance.getAbuse(300);
  static final abuseUnhealtyBodyImage = RemoteConfigService.instance.getAbuse(400);
  static final abuseDangerousActivities = RemoteConfigService.instance.getAbuse(500);
  static final abuseNudityOrSexual = RemoteConfigService.instance.getAbuse(600);
  static final abuseDisturbingContent = RemoteConfigService.instance.getAbuse(700);
  static final abuseIncorrectInformation = RemoteConfigService.instance.getAbuse(800);
  static final abuseMisleadingBehaviorOrSpam = RemoteConfigService.instance.getAbuse(900);
  static final abuseRegulatedProductsOrActivities = RemoteConfigService.instance.getAbuse(1000);
  static final abuseFraud = RemoteConfigService.instance.getAbuse(1100);
  static final abuseSharingPersonalInfo = RemoteConfigService.instance.getAbuse(1200);
  static final abuseCounterfeitProductsOrIntellectualProperty = RemoteConfigService.instance.getAbuse(1300);
  static final abuseAnother = RemoteConfigService.instance.getAbuse(1400);
  static final reportVideoAbuses = [abuseViolanceOrSexual, abuseHate, abuseSuicideOrSelfHarm, abuseUnhealtyBodyImage, abuseDangerousActivities, abuseNudityOrSexual, abuseDisturbingContent, abuseIncorrectInformation, abuseMisleadingBehaviorOrSpam, abuseRegulatedProductsOrActivities, abuseFraud, abuseSharingPersonalInfo, abuseCounterfeitProductsOrIntellectualProperty, abuseAnother];
  static final reportImageAbuses = [abuseViolanceOrSexual, abuseHate, abuseSuicideOrSelfHarm, abuseUnhealtyBodyImage, abuseDangerousActivities, abuseNudityOrSexual, abuseDisturbingContent, abuseIncorrectInformation, abuseMisleadingBehaviorOrSpam, abuseRegulatedProductsOrActivities, abuseFraud, abuseSharingPersonalInfo, abuseCounterfeitProductsOrIntellectualProperty, abuseAnother];
  static final reportTextAbuses = [abuseViolanceOrSexual, abuseHate, abuseSuicideOrSelfHarm, abuseUnhealtyBodyImage, abuseIncorrectInformation, abuseMisleadingBehaviorOrSpam, abuseFraud, abuseSharingPersonalInfo, abuseAnother];
}