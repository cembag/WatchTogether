import 'package:ecinema_watch_together/entities/firestore/cinema_entity.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/animations/custom_shimmer_loading_animation.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const padding = 8.0;
const imageRatio = 9/16;
const cardRadius = 16.0;
const infoSectionHeight = 82.0;
final imageWidth = Get.width - AppConstants.mHorizontalPadding * 2 - padding * 2;
final imageHeight = imageWidth * imageRatio;
final cardHeight = imageHeight + infoSectionHeight + padding * 2;

class CinemaCard extends StatelessWidget {
  final CinemaEntity cinema;
  const CinemaCard({super.key, required this.cinema});

  @override
  Widget build(BuildContext context) {
    print("CINEMA: ${cinema.id}");

    String secondsToHHmm(int seconds) => seconds > 3600 ? "${(seconds~/3600).toString().padLeft(2, '0')}:${(seconds%60).toString().padLeft(2, '0')}:${(seconds~/60).toString().padLeft(2, '0')}" : "${(seconds%60).toString().padLeft(2, '0')}:${(seconds~/60).toString().padLeft(2, '0')}";

    return Material(
      clipBehavior: Clip.hardEdge,
      color: AppColors.cardColor,
      borderRadius: BorderRadius.circular(cardRadius),
      child: InkWell(
        onTap: () => RouteService.toTry(),
        splashFactory: InkRipple.splashFactory,
        splashColor: AppColors.cardSplashColor,
        highlightColor: Colors.transparent,
        child: Container(
          width: Get.width,
          height: cardHeight,
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              Container(
                width: imageWidth,
                height: imageHeight,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset("assets/images/ic_alvin-ve-sincaplar.jpeg", fit: BoxFit.cover,),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   left: 0,
                    //   child: Container(
                    //     width: imageWidth,
                    //     height: 32,
                    //     color: Colors.black.withOpacity(.8),
                    //   ),
                    // )
                    Positioned(
                      top: padding,
                      right: padding,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.themeColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: textStyled(secondsToHHmm(cinema.time), 14, AppColors.themeColor, fontWeight: FontWeight.w600, fontFamily: "Barlow"),
                      ),
                    )
                  ],
                )
              ),
              Container(
                width: Get.width,
                height: infoSectionHeight,
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textStyled(cinema.title, 18, AppColors.primaryTextColor, fontWeight: FontWeight.w500),
                    AppSpaces.vertical6,
                    SizedBox(
                      width: double.infinity,
                      height: 24,
                      child: ListView.separated(
                        itemCount: cinema.categories.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => AppSpaces.horizontal6,
                        itemBuilder: (context, index) {
                          final cinemaCategory = cinema.categories[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: AppColors.themeColor.withOpacity(.1),
                            ),
                            child: textStyled(cinemaCategory.name, 12, AppColors.themeColor),
                          );
                        },
                      ),
                    )
                    // Expanded(
                    //   child: CustomButton(
                    //     text: "Sinemayı izle",
                    //     radius: 12,
                    //     onTap: () {},
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CinemaCardSkeletion extends StatelessWidget {
  const CinemaCardSkeletion({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmerLoadingAnimation(
      width: Get.width,
      height: cardHeight,
      radius: cardRadius,
    );
  }
}