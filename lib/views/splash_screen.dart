import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    _setSplash();
    controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);            
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: controller, curve: Curves.ease))..addListener(() {
      setState(() {});
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _setSplash() async {
    final storage = GetStorage();
    await storage.write('splash', true);
    await storage.save();
  }

  double get animValue => animation.value < .4 ? 0 :  (animation.value - .4) * (animation.value * 1.666);
  double get animValue2 => animation.value < .6 ? 0 :  (animation.value - .6) * (animation.value * 2.5);
  double get animValue3 => animation.value < .8 ? 0 :  (animation.value - .8) * (animation.value * 5);
  double get animValueLogo => animation.value > .4 ? 1 : animation.value * 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onScaffoldBackgroundColor,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            OverflowBox(
              maxWidth: Get.width * 3,
              maxHeight: Get.height * 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: Get.width * animation.value * 3,
                    height: Get.height * animation.value * 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.scaffoldBackgroundColor.changeColor(all: -3)
                    ),
                  ),
                  Container(
                    width: Get.width * animValue * 3,
                    height: Get.height * animValue * 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.scaffoldBackgroundColor.changeColor(all: -6),
                    ),
                  ),
                  Container(
                    width: Get.width * animValue2 * 3,
                    height: Get.height * animValue2 * 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.scaffoldBackgroundColor.changeColor(all: -9),
                    ),
                  ),
                  Container(
                    width: Get.width * animValue3 * 3,
                    height: Get.height * animValue3 * 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.scaffoldBackgroundColor.changeColor(all: -12),
                    ),
                  ),
                ],
              )
            ),
            Positioned(
              left: (Get.width - animValueLogo * 220)/2,
              bottom: Get.height/2 - 20 + (animValue3 * 20),
              child: Image.asset(AppAssets.logoText, width: animValueLogo * 220,),
            ),
            Positioned(
              left: (Get.width - animValue3 * 30)/2,
              bottom: Get.height/2 - 50,
              child: Opacity(
                opacity: animValue3,
                child: SizedBox(
                  width: animValue3 * 30,
                  height: animValue3 * 30,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.themeColor,
                      backgroundColor: AppColors.onScaffoldBackgroundColor,
                    ),
                  ),
                ),
              )
            )
          ],
        )
      ),
    );
  }
}