import 'package:carousel_slider/carousel_controller.dart';
import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardScreenController extends GetxController {
  final BuildContext context;
  OnboardScreenController(this.context);

  late final CarouselController carouselController;
  final logo = AssetImage(AppAssets.logoText);
  final imageOne = AssetImage(AppAssets.onboardWallpaperOne);
  final imageTwo = AssetImage(AppAssets.onboardWallpaperTwo);
  final imageThree = AssetImage(AppAssets.onboardWallpaperThree);
  final imageFour = AssetImage(AppAssets.onboardWallpaperFour);
  
  @override
  void onInit() {
    super.onInit();
    carouselController = CarouselController();
    _loadImages();
  }

  final currentPage = 0.obs;
  void setPage(int index) => currentPage.value = index;

  Future<void> _loadImages() async {
    precacheImage(logo, context);
    precacheImage(imageOne, context);
    precacheImage(imageTwo, context);
    precacheImage(imageThree, context);
    precacheImage(imageFour, context);
  }
}