import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: Container(
        width: Get.width,
        color: AppColors.brandColor,
        child: Row(
          children: [
      
          ],
        ),
      ),
    );
  }
}