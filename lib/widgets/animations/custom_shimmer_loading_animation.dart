import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerLoadingAnimation extends StatelessWidget {
  final double? radius;
  final Widget? child;
  final double width;
  final double height;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  const CustomShimmerLoadingAnimation({super.key, this.child, required this.width, required this.height, this.radius, this.isLoading = true, this.baseColor, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return isLoading ? Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.backgroundLight1,
      highlightColor: highlightColor ?? AppColors.backgroundLight2,
      period: const Duration(milliseconds: 1000),
      enabled: true,
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          // color: AppColors.cardColor,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
      ), 
    ) : child ?? const SizedBox.shrink();
  }
}