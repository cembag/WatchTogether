import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSizes {
  final BuildContext context;
  AppSizes(this.context);

  double get safePaddingBottom => MediaQuery.of(context).padding.bottom;
  double get safePaddingTop => MediaQuery.of(context).padding.top;
  double get keyboardHeight => EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets,WidgetsBinding.instance.window.devicePixelRatio).bottom;
  double get statusBarHeight => MediaQueryData.fromWindow(window).padding.top;

  static double getSafePaddingBottom(BuildContext context) => MediaQuery.of(context).viewPadding.bottom;
  static double getStatusBarHeight(BuildContext context) => MediaQuery.of(context).viewPadding.top;
  static double getSafePaddingTop(BuildContext context) => MediaQuery.of(context).padding.top;
  static double calcHeight(double height, double? diff) {
    var maxHeight = diff == null ? Get.height : Get.height - diff;
    return maxHeight > height ? height : maxHeight;
  }
}