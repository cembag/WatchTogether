import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenHeader extends StatelessWidget {
  final String header;
  final Widget? headerWidget;
  final Widget? trailing;
  final bool showTrailing;
  final Color? color;
  const ScreenHeader({super.key, required this.header, this.headerWidget, this.color, this.trailing, this.showTrailing = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 12),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          headerWidget ?? textStyled(header, 16,  color ?? AppColors.secondaryTextColor, fontWeight: FontWeight.w900, fontFamily: "Roboto"),
          if(trailing != null && showTrailing)
          trailing!
        ],
      ),
    );
  }
}