import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color splashColor;
  final double radius;
  final void Function()? onTap;
  final InteractiveInkFeatureFactory? splashFactory;
  final Color highlightColor; 
  final bool hasBorder;
  final bool outlined;
  final Color? borderColor;
  const CustomButton({super.key, required this.text, this.width, this.height, this.padding, this.fontSize = 20, required this.onTap, this.backgroundColor, this.textColor, this.splashColor = Colors.black26, this.highlightColor = Colors.transparent, this.splashFactory = InkRipple.splashFactory, this.radius = 50, this.hasBorder = false, this.outlined = false, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: outlined ? Colors.transparent : backgroundColor ?? AppColors.themeColor,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        splashFactory: splashFactory,
        highlightColor: highlightColor,
        child: Container(
          width: padding != null ? null : width ?? Get.width - AppConstants.mHorizontalPadding * 2,
          height: padding != null ? null : height ?? 42,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: borderColor != null ? Border.all(
              color: borderColor!,
              width: 1
            ) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textStyled(text, fontSize, textColor ?? (outlined ? AppColors.themeColor : AppColors.primaryButtonTextColor), fontWeight: FontWeight.w700, fontFamily: "Barlow"),
              AppSpaces.vertical4,
            ],
          ),
        ),
      ),
    );
  }
}