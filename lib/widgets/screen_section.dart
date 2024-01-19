import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/widgets/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSection extends StatelessWidget {
  final String header;
  final Widget? headerWidget;
  final Widget? trailing;
  final bool showTrailing;
  final bool showHeader;
  final Widget child;
  final Color backgroundColor;
  final Color? headerColor;
  final double verticalPadding;
  final double horizontalPadding;
  final bool hasShadow;
  final double? spacingBottom;
  final double? spacingTop;
  final double? spacingVertical;
  const ScreenSection({super.key, required this.header, this.headerWidget, this.trailing, this.showTrailing = true, this.showHeader = true, required this.child, this.backgroundColor = AppColors.scaffoldBackgroundColor, this.verticalPadding = 10.0, this.horizontalPadding = 0, this.hasShadow = false, this.spacingTop, this.spacingBottom, this.spacingVertical, this.headerColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(spacingTop != null || spacingVertical != null)
        SizedBox(height: spacingTop ?? spacingVertical,),
        if(showHeader)
        ScreenHeader(
          header: header,
          headerWidget: headerWidget,
          trailing: trailing,
          showTrailing: showTrailing,
          color: headerColor,
        ),
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: hasShadow ? [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)
              )
            ] : []
          ),
          child: child,
        ),
        if(spacingBottom != null || spacingVertical != null)
        SizedBox(height: spacingBottom ?? spacingVertical,)
      ],
    );
  }
}