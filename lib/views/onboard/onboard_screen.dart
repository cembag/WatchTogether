import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/onboard/onboard_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const buttonHeight = 52.0;
const bottomPadding = 30.0;
final onboardPages = <Widget>[
  onboardPageOne(),
  onboardPageTwo(),
  onboardPageThree(),
  onboardPageFour()
];

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return GetBuilder(
      init: OnboardScreenController(context),
      builder: (controller) {
        return Scaffold(
          body: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CarouselSlider.builder(
                    carouselController: controller.carouselController,
                    options: CarouselOptions(
                      height: Get.height,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      initialPage: controller.currentPage.value,
                      onPageChanged: (index, reason) => controller.setPage(index),
                      // enlargeCenterPage: true
                    ),
                    itemCount: onboardPages.length,
                    itemBuilder: (BuildContext context, int index, int pageViewIndex) => onboardPages[index]
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40, sizes.safePaddingTop + 24, 40, sizes.safePaddingBottom + bottomPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: controller.logo, width: 220,),
                        AppSpaces.expandedSpace,
                        SizedBox(
                          width: Get.width,
                          height: 8,
                          child: Center(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: onboardPages.length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => AppSpaces.horizontal3,
                              itemBuilder: (context, index) =>  Obx(
                                () {
                                  final onboardController = Get.find<OnboardScreenController>();
                                  final pageIndex = onboardController.currentPage.value;
                                  final isSelected = pageIndex == index;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.fastEaseInToSlowEaseOut,
                                    width: isSelected ? 32 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.themeColor : AppColors.themeColor.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(16)
                                    ),
                                  );
                                }
                              )
                            ),
                          ),
                        ),
                        AppSpaces.vertical20,
                        CustomButton(
                          text: "HAYDİ BAŞLAYALIM",
                          width: Get.width,
                          height: buttonHeight,
                          fontSize: 22,
                          onTap: () => RouteService.offAllRegisterPhoneNumber(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        );
      },
    );
  }
}

class OnboardBuilder extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final double filterOpacity;
  const OnboardBuilder({super.key, required this.imagePath, required this.title, required this.message, this.filterOpacity = .4});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        /// DESIGN MARK
        /// notes
        /// ********************
        /// Can be removed later
        /// ********************
        /// relevant line start
        color: AppColors.themeColor.withOpacity(.2),
        /// relevant line end
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(.8), BlendMode.dstATop),
          image: AssetImage(imagePath),
        )
      ),
      child: Column(
        children: [
          AppSpaces.expandedSpace,
          textStyled(title, 28, Colors.white, fontWeight: FontWeight.w700, fontFamily: "Barlow", textAlign: TextAlign.center, shadows: [AppColors.shadowTextBlackForTitle], lineHeight: 1.1),
          AppSpaces.vertical10,
          textStyled(message, 16, Colors.white, fontWeight: FontWeight.w500, textAlign: TextAlign.center, shadows: [AppColors.shadowTextBlackForText], lineHeight: 1.4),
          AppSpaces.customHeight(56 + bottomPadding + buttonHeight + AppSizes.getSafePaddingBottom(context))
        ],
      ),
    );
  }
}

Widget onboardPageOne() {
  return OnboardBuilder(
    imagePath: AppAssets.onboardWallpaperOne, 
    title: "HER YERDE, DİLEDİĞİN AN BİRLİKTE İZLE",
    message: "Tek başına bir şeyler izlemekten sıkılmadın mı? Hemen indir ve izlemeye başla.",
  );
}

Widget onboardPageTwo() {
  return OnboardBuilder(
    imagePath: AppAssets.onboardWallpaperTwo, 
    title: "HER YERDE, DİLEDİĞİN AN BİRLİKTE İZLE",
    message: "Tek başına bir şeyler izlemekten sıkılmadın mı? Hemen indir ve izlemeye başla.",
  );
}

Widget onboardPageThree() {
  return OnboardBuilder(
    imagePath: AppAssets.onboardWallpaperThree, 
    title: "HER YERDE, DİLEDİĞİN AN BİRLİKTE İZLE",
    message: "Tek başına bir şeyler izlemekten sıkılmadın mı? Hemen indir ve izlemeye başla.",
  );
}

Widget onboardPageFour() {
  return OnboardBuilder(
    imagePath: AppAssets.onboardWallpaperFour, 
    title: "HER YERDE, DİLEDİĞİN AN BİRLİKTE İZLE",
    message: "Tek başına bir şeyler izlemekten sıkılmadın mı? Hemen indir ve izlemeye başla.",
  );
}

