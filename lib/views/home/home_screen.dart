import 'dart:math';
import 'package:ecinema_watch_together/controlllers/main_controller.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/home/home_controller.dart';
import 'package:ecinema_watch_together/widgets/animations/custom_shimmer_loading_animation.dart';
import 'package:ecinema_watch_together/widgets/animations/tap_down_scale_animation.dart';
import 'package:ecinema_watch_together/widgets/cinema_card.dart';
import 'package:ecinema_watch_together/widgets/screen_section.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    final contentHeight = Get.height - appBarHeight - sizes.safePaddingBottom;
    const actionButtonWidth = 58.0;
    const actionSectionHeight = actionButtonWidth + 24.0;
    // const actionSectionHeight = 0.0;
    return GetBuilder(
      init: HomeScreenController(),
      builder: (controller) {
        final positionX = controller.cardPositionX;
        final positionY = controller.cardPositionY;
        final positionXabs = controller.cardPositionX.abs();
        return Scaffold(
          backgroundColor: AppColors.appBarColor,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: _appBar(appBarHeight, sizes.statusBarHeight)
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Obx(
                  () {
                    final mainController = Get.find<MainController>();
                    final hasCinemasInitialized = mainController.hasCinemasInitialized.value;
                    final cinemas = mainController.cinemas.value;
                    print("OBX_CINEMAS: $cinemas");
                          
                    if(!hasCinemasInitialized) {
                      return ScreenSection(
                        header: "loading",
                        headerWidget: const CustomShimmerLoadingAnimation(width: 80, height: 20, radius: 6,),
                        backgroundColor: Colors.transparent,
                        verticalPadding: 0,
                        child: SizedBox(
                          width: Get.width,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: 6,
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) => AppSpaces.vertical12,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 0),
                            itemBuilder: (context, index) => const CinemaCardSkeletion()
                          ),
                        ),
                      );
                    }
                          
                    if(cinemas == null || cinemas.isEmpty) {
                      return SizedBox(
                        width: Get.width,
                        height: Get.height - sizes.safePaddingBottom - 56 - 50 - sizes.statusBarHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/ic_icon-popcorn.png", width: 62, height: 62,),
                            AppSpaces.vertical16,
                            textStyled("Sinema bulunamadı", 14, AppColors.themeColor, fontWeight: FontWeight.w500),
                            AppSpaces.vertical2,
                            textStyled("Aktif bir sinema bulunmamaktadır.", 12, AppColors.greyTextColor, fontWeight: FontWeight.w400),
                          ],
                        ),
                      );
                    }
                
                    // return ScreenSection(
                    //   header: "Cinemas",
                    //   backgroundColor: Colors.transparent,
                    //   verticalPadding: 0,
                    //   child: SizedBox(
                    //     width: Get.width,
                    //     child: ListView.separated(
                    //       shrinkWrap: true,
                    //       itemCount: cinemas.length,
                    //       scrollDirection: Axis.vertical,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       separatorBuilder: (context, index) => AppSpaces.vertical12,
                    //       padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 0),
                    //       itemBuilder: (context, index) => CinemaCard(
                    //         cinema: cinemas[index],
                    //       ),
                    //     ),
                    //   ),
                    // );

                    return Stack(
                      children: [
                        for(var i=controller.girls.length-1; i>=0; i--)
                        Builder(
                          builder: (context) {
                            final girl = controller.girls[i];
                            final isCurrent = i == 0;
                            print("girl: $girl");
                            return SizedBox(
                              width: Get.width,
                              height: Get.height,
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.fastEaseInToSlowEaseOut,
                                    top: isCurrent ? appBarHeight + controller.cardPositionY : appBarHeight + controller.cardPositionY/20,
                                    left: isCurrent ? controller.cardPositionX : controller.cardPositionX/20,
                                    child: Transform.rotate(
                                      angle: isCurrent ? controller.cardPositionX * pi/180/40 : 0,
                                      alignment: controller.cardPositionX > 0 ? Alignment.bottomLeft : Alignment.bottomRight,
                                      child: GestureDetector(
                                        onPanStart: (details) {
                                          controller.cardStartPosition = details.localPosition;
                                          controller.update();
                                          print("x: ${details.localPosition.dx}, y: ${details.localPosition.dy}");
                                        },
                                        onPanUpdate: (details) {
                                          controller.cardPositionX = details.localPosition.dx - controller.cardStartPosition.dx;
                                          controller.cardPositionY = details.localPosition.dy - controller.cardStartPosition.dy;
                                          controller.cardPosition2X = (details.localPosition.dx - controller.cardStartPosition.dx)/16;
                                          controller.cardPosition2Y = (details.localPosition.dy - controller.cardStartPosition.dy)/16;
                                          controller.update();
                                          print("x: ${details.localPosition.dx - controller.cardStartPosition.dx}");
                                        },
                                        onPanCancel: () {
                                          print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                                        },
                                        onPanEnd: (details) async {
                                          print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                                          if(positionXabs > 40) {
                                            // controller.girls.insert(controller.girls.length, controller.girls2[controller.order.value]);
                                            controller.cardPositionX = positionX > 0 ? 600 : -600;
                                            controller.update();
                                          }
                                          await Future.delayed(const Duration(milliseconds: 200), () {
                                            if(positionXabs > 40) {
                                              controller.girls.removeAt(0);
                                              controller.girls.add(controller.girls2[controller.order.value]);
                                            }
                                            if(controller.cardPositionX < -40) {
                                              print("ORDER: ${controller.order}");
                                              controller.order.value += 1;
                                            } else if(controller.cardPositionX > 40) {
                                              print("ORDER: ${controller.order}");
                                              controller.order.value += 1;
                                            }
                                            controller.cardPositionX = 0;
                                            controller.cardPositionY = 0;
                                            controller.update();
                                          });
                                        },
                                        child: Container(
                                          height: contentHeight - 10,
                                          width: Get.width,
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.2),
                                                  offset: const Offset(0, 1),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                )
                                              ],
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            clipBehavior: Clip.none,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              clipBehavior: Clip.none,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(16),
                                                            child: Image.network(girl, fit: BoxFit.cover),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              // color: Colors.black.withOpacity(.4),
                                                              borderRadius: BorderRadius.circular(16)
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ),
                                                    if((positionX == 0 && positionY == 0) || !isCurrent)
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Container(
                                                        width: Get.width - 16,
                                                        padding: const EdgeInsets.fromLTRB(16, 64, 16, actionSectionHeight + 4),
                                                        decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(16),
                                                            bottomRight: Radius.circular(16),
                                                          ),
                                                          gradient: LinearGradient(colors: [Color.fromRGBO(0, 0, 0, 1), Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, 0)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            RichText(
                                                              text: const TextSpan(
                                                                text: "Gizem",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: ", 18",
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Color.fromRGBO(220, 220, 220, 1)
                                                                    )
                                                                  )
                                                                ]
                                                              ),
                                                            ),
                                                            AppSpaces.vertical6,
                                                            Row(
                                                              children: [
                                                                Image.asset("assets/images/ic_icon-location.png", width: 14, height: 14, color: Colors.white,),
                                                                AppSpaces.horizontal6,
                                                                textStyled("14 km", 14, Colors.white, fontWeight: FontWeight.w500),
                                                                // AppSpaces.horizontal8,
                                                                // Container(
                                                                //   width: 4,
                                                                //   height: 4,
                                                                //   decoration: BoxDecoration(
                                                                //     borderRadius: BorderRadius.circular(20),
                                                                //     color: const Color.fromRGBO(200, 200, 200, 1)
                                                                //   ),
                                                                // ),
                                                                // AppSpaces.horizontal8,
                                                                // textStyled("Uzman doktor", 16, Colors.white, fontWeight: FontWeight.w500),
                                                                AppSpaces.horizontal8,
                                                                Container(
                                                                  width: 4,
                                                                  height: 4,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    color: const Color.fromRGBO(200, 200, 200, 1)
                                                                  ),
                                                                ),
                                                                AppSpaces.horizontal8,
                                                                textStyled("Çevrimiçi", 14, Colors.green, fontWeight: FontWeight.w500),
                                                                // Container(
                                                                //   width: 12,
                                                                //   height: 12,
                                                                //   decoration: const BoxDecoration(
                                                                //     shape: BoxShape.circle,
                                                                //     color: Color.fromARGB(255, 9, 125, 13),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                            AppSpaces.vertical8,
                                                            textStyled("Merhaba, ben matchup kullanıyorum.", 14, const Color.fromRGBO(220, 220, 220, 1), fontWeight: FontWeight.w300, lineHeight: 1.4, maxLines: 3, overflow: TextOverflow.ellipsis)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                if(isCurrent && controller.cardPositionX < -10)
                                                AnimatedOpacity(
                                                  duration: const Duration(milliseconds: 200),
                                                  opacity: controller.cardPositionX.abs()/180 > 1 ? 1 : controller.cardPositionX.abs()/180,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.asset("assets/images/ic_unlike-background.png", fit: BoxFit.cover,),
                                                  ),
                                                ),
                                                if(isCurrent && controller.cardPositionX > 10)
                                                AnimatedOpacity(
                                                  duration: const Duration(milliseconds: 200),
                                                  opacity: controller.cardPositionX.abs()/180 > 1 ? 1 : controller.cardPositionX.abs()/180,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.asset("assets/images/ic_like-background.png", fit: BoxFit.cover,),
                                                  ),
                                                ),
                                                if(isCurrent && controller.cardPositionX > 0)
                                                Positioned(
                                                  top: contentHeight/2 + (positionX > 180 ? -36 : -positionX*.2),
                                                  left: positionX > 180 ? -36 : -positionX*.2,
                                                  child: AnimatedOpacity(
                                                    duration: const Duration(milliseconds: 200),
                                                    opacity: controller.cardPositionX.abs()/180 > 1 ? 1 : controller.cardPositionX.abs()/180,
                                                    child: Container(
                                                      width: positionX > 180 ? 72 : positionX * .4,
                                                      height: positionX > 180 ? 72 : positionX * .4,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: positionXabs/30 > 6 ? 6 : positionXabs/30
                                                        ),
                                                        borderRadius: BorderRadius.circular(positionX > 180 ? 24 : positionX*.13),
                                                        image: const DecorationImage(
                                                          image: AssetImage("assets/images/ic_like-background.png"),
                                                          fit: BoxFit.cover
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset("assets/images/ic_icon-like.png", color: Colors.white, width: positionX > 180 ? 32 : positionX*.17, height: positionX > 180 ? 32 : positionX*.17,),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if(isCurrent && controller.cardPositionX < 0)
                                                Positioned(
                                                  top: contentHeight/2 + (positionXabs > 180 ? -36 : -positionXabs*.2),
                                                  right: positionXabs > 180 ? -36 : -positionXabs*.2,
                                                  child: AnimatedOpacity(
                                                    duration: const Duration(milliseconds: 200),
                                                    opacity: controller.cardPositionX.abs()/180 > 1 ? 1 : controller.cardPositionX.abs()/180,
                                                    child: Container(
                                                      width: positionXabs > 180 ? 72 : positionXabs * .4,
                                                      height: positionXabs > 180 ? 72 : positionXabs * .4,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: positionXabs/30 > 6 ? 6 : positionXabs/30
                                                        ),
                                                        borderRadius: BorderRadius.circular(positionXabs > 180 ? 24 : positionXabs*.13),
                                                        image: const DecorationImage(
                                                          image: AssetImage("assets/images/ic_unlike-background.png"),
                                                          fit: BoxFit.cover
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset("assets/images/ic_icon-unlike.png", color: Colors.white, width: positionXabs > 180 ? 32 : positionXabs*.17, height: positionXabs > 180 ? 32 : positionXabs*.17,),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.ease,
                                    left: 0,
                                    bottom: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? sizes.safePaddingBottom - 20 : sizes.safePaddingBottom,
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200),
                                      opacity: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : 1,
                                      child: SizedBox(
                                        width: Get.width,
                                        height: actionSectionHeight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 24),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TapDownScaleAnimation(
                                                onTap: () {},
                                                child: Container(
                                                  width: actionButtonWidth,
                                                  height: actionButtonWidth,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(22),
                                                    // gradient: const LinearGradient(colors: [Color(0xFFFBAB43), Color(0xFFFF4B00)], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                                                    gradient: const LinearGradient(colors: [Color.fromARGB(255, 189, 141, 77), Color.fromARGB(255, 181, 70, 22)], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                                                  ), 
                                                  child: Center(
                                                    child: Image.asset("assets/images/ic_icon-unlike.png", width: 26, height: 26, color: Colors.white,),
                                                  ),
                                                ),
                                              ),
                                              AppSpaces.horizontal16,
                                              TapDownScaleAnimation(
                                                onTap: () {},
                                                child: Container(
                                                  width: actionButtonWidth - 4,
                                                  height: actionButtonWidth - 4,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    gradient: const LinearGradient(colors: [Color(0xFF43AFFB), Color(0xFF0022FF)], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset("assets/images/ic_icon-super-like.png", width: 26, height: 26, color: Colors.white,),
                                                  ),
                                                ),
                                              ),
                                              AppSpaces.horizontal16,
                                              TapDownScaleAnimation(
                                                onTap: () {},
                                                child: Container(
                                                  width: actionButtonWidth,
                                                  height: actionButtonWidth,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(22),
                                                    gradient: const LinearGradient(colors: [Color.fromARGB(255, 193, 36, 67), Color.fromARGB(255, 177, 0, 0)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                                                    // gradient: const LinearGradient(colors: [Color(0xFFF93159), Color(0xFFFF0000)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                                                  ),
                                                  child: Center(
                                                    child: Image.asset("assets/images/ic_icon-like.png", width: 32, height: 32, color: Colors.white,),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // if(!controller.isOrderEven)
                        // SizedBox(
                        //   width: Get.width,
                        //   height: Get.height,
                        //   child: Stack(
                        //     children: [
                        //       Positioned(
                        //         // duration: const Duration(milliseconds: 200),
                        //         // curve: Curves.fastEaseInToSlowEaseOut,
                        //         top: !controller.isOrderEven ? appBarHeight + controller.cardPositionY/16 : appBarHeight + controller.cardPositionY,
                        //         left: !controller.isOrderEven ? controller.cardPositionX/16 : controller.cardPositionX,
                        //         child: Transform.rotate(
                        //           angle: !controller.isOrderEven ? controller.cardPositionX * pi/180/180 : controller.cardPositionX * pi/180/20,
                        //           alignment: Alignment.bottomRight,
                        //           child: GestureDetector(
                        //             onPanStart: (details) {
                        //               controller.cardStartPosition = details.localPosition;
                        //               controller.update();
                        //               print("x: ${details.localPosition.dx}, y: ${details.localPosition.dy}");
                        //             },
                        //             onPanUpdate: (details) {
                        //               controller.cardPositionX = details.localPosition.dx - controller.cardStartPosition.dx;
                        //               controller.cardPositionY = details.localPosition.dy - controller.cardStartPosition.dy;
                        //               controller.update();
                        //               print("x: ${details.localPosition.dx - controller.cardStartPosition.dx}");
                        //             },
                        //             onPanCancel: () {
                        //               print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                        //             },
                        //             onPanEnd: (details) {
                        //               print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                        //               if(controller.cardPositionX.abs() > 40) {
                        //                 // controller.girls.insert(controller.girls.length, controller.girls2[controller.order.value]);
                        //                 controller.girls.add(controller.girls2[controller.order.value]);
                        //               }
                        //               if(controller.cardPositionX < -40) {
                        //                 print("ORDER: ${controller.order}");
                        //                 controller.order.value += 1;
                        //               } else if(controller.cardPositionX > 40) {
                        //                 print("ORDER: ${controller.order}");
                        //                 controller.order.value += 1;
                        //               }
                        //               controller.cardPositionX = 0;
                        //               controller.cardPositionY = 0;
                        //               print(controller.girls);
                        //               controller.update();
                        //             },
                        //             child: Container(
                        //               height: contentHeight - 10,
                        //               width: Get.width,
                        //               padding: const EdgeInsets.symmetric(horizontal: 8),
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   boxShadow: [
                        //                     BoxShadow(
                        //                       color: Colors.black.withOpacity(.4),
                        //                       offset: const Offset(0, 1),
                        //                       spreadRadius: 1,
                        //                       blurRadius: 5,
                        //                     )
                        //                   ],
                        //                   image: DecorationImage(
                        //                     image: NetworkImage(controller.girls.last),
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                   borderRadius: BorderRadius.circular(16),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       AnimatedPositioned(
                        //         duration: const Duration(milliseconds: 200),
                        //         curve: Curves.ease,
                        //         left: 0,
                        //         bottom: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : sizes.safePaddingBottom,
                        //         child: AnimatedOpacity(
                        //           duration: const Duration(milliseconds: 200),
                        //           opacity: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : 1,
                        //           child: SizedBox(
                        //             width: Get.width,
                        //             height: actionSectionHeight,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(bottom: 24),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Container(
                        //                     width: actionButtonWidth,
                        //                     height: actionButtonWidth,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(24),
                        //                       color: Colors.white
                        //                     ),
                        //                   ),
                        //                   AppSpaces.horizontal16,
                        //                   Container(
                        //                     width: actionButtonWidth - 6,
                        //                     height: actionButtonWidth - 6,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(22),
                        //                       color: Colors.white
                        //                     ),
                        //                   ),
                        //                   AppSpaces.horizontal16,
                        //                   Container(
                        //                     width: actionButtonWidth,
                        //                     height: actionButtonWidth,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(24),
                        //                       color: Colors.white
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: Get.width,
                        //   height: Get.height,
                        //   child: Stack(
                        //     children: [
                        //       Positioned(
                        //         // duration: const Duration(milliseconds: 200),
                        //         // curve: Curves.fastEaseInToSlowEaseOut,
                        //         top: controller.isOrderEven ? appBarHeight + controller.cardPositionY/16 : appBarHeight + controller.cardPositionY,
                        //         left: controller.isOrderEven ? controller.cardPositionX/16 : controller.cardPositionX,
                        //         child: Transform.rotate(
                        //           angle: controller.isOrderEven ? controller.cardPositionX * pi/180/180 : controller.cardPositionX * pi/180/20,
                        //           alignment: Alignment.bottomRight,
                        //           child: GestureDetector(
                        //             onPanStart: (details) {
                        //               controller.cardStartPosition = details.localPosition;
                        //               controller.update();
                        //               print("x: ${details.localPosition.dx}, y: ${details.localPosition.dy}");
                        //             },
                        //             onPanUpdate: (details) {
                        //               controller.cardPositionX = details.localPosition.dx - controller.cardStartPosition.dx;
                        //               controller.cardPositionY = details.localPosition.dy - controller.cardStartPosition.dy;
                        //               controller.update();
                        //               print("x: ${details.localPosition.dx - controller.cardStartPosition.dx}");
                        //             },
                        //             onPanCancel: () {
                        //               print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                        //             },
                        //             onPanEnd: (details) {
                        //               print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                        //               if(controller.cardPositionX.abs() > 40) {
                        //                 // controller.girls.insert(controller.girls.length, controller.girls2[controller.order.value]);
                        //                 controller.girls.add(controller.girls2[controller.order.value]);
                        //               }
                        //               if(controller.cardPositionX < -40) {
                        //                 print("ORDER: ${controller.order}");
                        //                 controller.order.value += 1;
                        //               } else if(controller.cardPositionX > 40) {
                        //                 print("ORDER: ${controller.order}");
                        //                 controller.order.value += 1;
                        //               }
                        //               controller.cardPositionX = 0;
                        //               controller.cardPositionY = 0;
                        //               print(controller.girls);
                        //               controller.update();
                        //             },
                        //             child: Container(
                        //               height: contentHeight - 10,
                        //               width: Get.width,
                        //               padding: const EdgeInsets.symmetric(horizontal: 8),
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   boxShadow: [
                        //                     BoxShadow(
                        //                       color: Colors.black.withOpacity(.4),
                        //                       offset: const Offset(0, 1),
                        //                       spreadRadius: 1,
                        //                       blurRadius: 5,
                        //                     )
                        //                   ],
                        //                   image: DecorationImage(
                        //                     image: NetworkImage(controller.isOrderEven ? controller.girls.last : controller.girls[controller.girls.length - 2]),
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                   borderRadius: BorderRadius.circular(16),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       AnimatedPositioned(
                        //         duration: const Duration(milliseconds: 200),
                        //         curve: Curves.ease,
                        //         left: 0,
                        //         bottom: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : sizes.safePaddingBottom,
                        //         child: AnimatedOpacity(
                        //           duration: const Duration(milliseconds: 200),
                        //           opacity: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : 1,
                        //           child: SizedBox(
                        //             width: Get.width,
                        //             height: actionSectionHeight,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(bottom: 24),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Container(
                        //                     width: 56,
                        //                     height: 56,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(24),
                        //                       color: Colors.white
                        //                     ),
                        //                   ),
                        //                   AppSpaces.horizontal16,
                        //                   Container(
                        //                     width: 52,
                        //                     height: 52,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(22),
                        //                       color: Colors.white
                        //                     ),
                        //                   ),
                        //                   AppSpaces.horizontal16,
                        //                   Container(
                        //                     width: 56,
                        //                     height: 56,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(24),
                        //                       color: Colors.white
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // if(controller.isOrderEven)
                        // SizedBox(
                        //   width: Get.width,
                        //   height: Get.height,
                        //   child: Stack(
                        //     children: [
                        //       AnimatedPositioned(
                        //         duration: const Duration(milliseconds: 200),
                        //         curve: Curves.fastEaseInToSlowEaseOut,
                        //         top: appBarHeight + controller.cardPositionY,
                        //         left: controller.cardPositionX,
                        //         child: Transform.rotate(
                        //           angle: controller.cardPositionX * pi/180/20,
                        //           alignment: controller.cardPositionX > 0 ? Alignment.bottomLeft : Alignment.bottomRight,
                        //           child: GestureDetector(
                        //             onPanStart: (details) {
                        //               controller.cardStartPosition = details.localPosition;
                        //               controller.update();
                        //               print("x: ${details.localPosition.dx}, y: ${details.localPosition.dy}");
                        //             },
                        //             onPanUpdate: (details) {
                        //               controller.cardPositionX = details.localPosition.dx - controller.cardStartPosition.dx;
                        //               controller.cardPositionY = details.localPosition.dy - controller.cardStartPosition.dy;
                        //               controller.cardPosition2X = (details.localPosition.dx - controller.cardStartPosition.dx)/16;
                        //               controller.cardPosition2Y = (details.localPosition.dy - controller.cardStartPosition.dy)/16;
                        //               controller.update();
                        //               print("x: ${details.localPosition.dx - controller.cardStartPosition.dx}");
                        //             },
                        //             onPanCancel: () {
                        //               print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                        //             },
                        //             onPanEnd: (details) {
                        //               print("FINAL POINT X: ${controller.cardPositionX}, Y: ${controller.cardPositionY}");
                        //               if(controller.cardPositionX.abs() > 40) {
                        //                 // controller.girls.insert(controller.girls.length, controller.girls2[controller.order.value]);
                        //                 controller.girls.add(controller.girls2[controller.order.value]);
                        //               }
                        //               if(controller.cardPositionX < -40) {
                        //                 print("ORDER: ${controller.order}");
                        //                 controller.order.value += 1;
                        //               } else if(controller.cardPositionX > 40) {
                        //                 print("ORDER: ${controller.order}");
                        //                 controller.order.value += 1;
                        //               }
                        //               controller.cardPositionX = 0;
                        //               controller.cardPositionY = 0;
                        //               print(controller.girls);
                        //               controller.update();
                        //             },
                        //             child: Container(
                        //               height: contentHeight - 10,
                        //               width: Get.width,
                        //               padding: const EdgeInsets.symmetric(horizontal: 8),
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   boxShadow: [
                        //                     BoxShadow(
                        //                       color: Colors.black.withOpacity(.6),
                        //                       offset: const Offset(0, 1),
                        //                       spreadRadius: 1,
                        //                       blurRadius: 5,
                        //                     )
                        //                   ],
                        //                   borderRadius: BorderRadius.circular(16),
                        //                 ),
                        //                 clipBehavior: Clip.none,
                        //                 child: Stack(
                        //                   fit: StackFit.expand,
                        //                   clipBehavior: Clip.none,
                        //                   children: [
                        //                     Stack(
                        //                       children: [
                        //                         Positioned.fill(
                        //                           child: Stack(
                        //                             fit: StackFit.expand,
                        //                             children: [
                        //                               ClipRRect(
                        //                                 borderRadius: BorderRadius.circular(16),
                        //                                 child: Image.network(controller.girls[controller.girls.length - 2], fit: BoxFit.cover),
                        //                               ),
                        //                               Container(
                        //                                 decoration: BoxDecoration(
                        //                                   // color: Colors.black.withOpacity(.4),
                        //                                   borderRadius: BorderRadius.circular(16)
                        //                                 ),
                        //                               )
                        //                             ],
                        //                           )
                        //                         ),
                        //                         if(positionX == 0 && positionY == 0)
                        //                         Positioned(
                        //                           bottom: 0,
                        //                           left: 0,
                        //                           child: Container(
                        //                             width: Get.width - 16,
                        //                             padding: const EdgeInsets.fromLTRB(16, 64, 16, actionSectionHeight + 4),
                        //                             decoration: const BoxDecoration(
                        //                               borderRadius: BorderRadius.only(
                        //                                 bottomLeft: Radius.circular(16),
                        //                                 bottomRight: Radius.circular(16),
                        //                               ),
                        //                               gradient: LinearGradient(colors: [Color.fromRGBO(0, 0, 0, 1), Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, 0)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                        //                             ),
                        //                             child: Column(
                        //                               crossAxisAlignment: CrossAxisAlignment.start,
                        //                               children: [
                        //                                 RichText(
                        //                                   text: const TextSpan(
                        //                                     text: "Bahar",
                        //                                     style: TextStyle(
                        //                                       color: Colors.white,
                        //                                       fontSize: 24,
                        //                                       fontWeight: FontWeight.w700,
                        //                                     ),
                        //                                     children: [
                        //                                       TextSpan(
                        //                                         text: ", 18",
                        //                                         style: TextStyle(
                        //                                           fontSize: 22,
                        //                                           fontWeight: FontWeight.bold,
                        //                                           color: Color.fromRGBO(200, 200, 200, 1)
                        //                                         )
                        //                                       )
                        //                                     ]
                        //                                   ),
                        //                                 ),
                        //                                 AppSpaces.vertical8,
                        //                                 Row(
                        //                                   children: [
                        //                                     Image.asset("assets/images/ic_icon-location.png", width: 16, height: 16, color: Colors.white,),
                        //                                     AppSpaces.horizontal6,
                        //                                     textStyled("14 km", 16, Colors.white, fontWeight: FontWeight.w500),
                        //                                     // AppSpaces.horizontal8,
                        //                                     // Container(
                        //                                     //   width: 4,
                        //                                     //   height: 4,
                        //                                     //   decoration: BoxDecoration(
                        //                                     //     borderRadius: BorderRadius.circular(20),
                        //                                     //     color: const Color.fromRGBO(200, 200, 200, 1)
                        //                                     //   ),
                        //                                     // ),
                        //                                     // AppSpaces.horizontal8,
                        //                                     // textStyled("Uzman doktor", 16, Colors.white, fontWeight: FontWeight.w500),
                        //                                     AppSpaces.horizontal8,
                        //                                     Container(
                        //                                       width: 4,
                        //                                       height: 4,
                        //                                       decoration: BoxDecoration(
                        //                                         borderRadius: BorderRadius.circular(20),
                        //                                         color: const Color.fromRGBO(200, 200, 200, 1)
                        //                                       ),
                        //                                     ),
                        //                                     AppSpaces.horizontal8,
                        //                                     // textStyled("Çevrimiçi", 16, Colors.green, fontWeight: FontWeight.w500),
                        //                                     Container(
                        //                                       width: 14,
                        //                                       height: 14,
                        //                                       decoration: const BoxDecoration(
                        //                                         shape: BoxShape.circle,
                        //                                         color: Color.fromARGB(255, 0, 158, 5),
                        //                                       ),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                                 AppSpaces.vertical12,
                        //                                 textStyled("Eğlenmeyi severim, gemi mühendisiyim, uzun süreli ilişki arıyorum.", 15, const Color.fromRGBO(220, 220, 220, 1), fontWeight: FontWeight.w300, lineHeight: 1.4, maxLines: 3, overflow: TextOverflow.ellipsis)
                        //                               ],
                        //                             ),
                        //                           ),
                        //                         )
                        //                       ],
                        //                     ),
                        //                     if(controller.cardPositionX < -10)
                        //                     AnimatedOpacity(
                        //                       duration: const Duration(milliseconds: 200),
                        //                       opacity: controller.cardPositionX.abs()/144 > 1 ? 1 : controller.cardPositionX.abs()/144,
                        //                       child: ClipRRect(
                        //                         borderRadius: BorderRadius.circular(16),
                        //                         child: Image.asset("assets/images/ic_unlike-background.png", fit: BoxFit.cover,),
                        //                       ),
                        //                     ),
                        //                     if(controller.cardPositionX > 10)
                        //                     AnimatedOpacity(
                        //                       duration: const Duration(milliseconds: 200),
                        //                       opacity: controller.cardPositionX.abs()/144 > 1 ? 1 : controller.cardPositionX.abs()/144,
                        //                       child: ClipRRect(
                        //                         borderRadius: BorderRadius.circular(16),
                        //                         child: Image.asset("assets/images/ic_like-background.png", fit: BoxFit.cover,),
                        //                       ),
                        //                     ),
                        //                     if(controller.cardPositionX > 0)
                        //                     Positioned(
                        //                       top: contentHeight/2 + (positionX * 1.5 > 144 ? -36 : -positionX*3/8),
                        //                       left: positionX * 1.5 > 144 ? -36 : -positionX * 3/8,
                        //                       child: AnimatedOpacity(
                        //                         duration: const Duration(milliseconds: 200),
                        //                         opacity: controller.cardPositionX.abs()/144 > 1 ? 1 : controller.cardPositionX.abs()/144,
                        //                         child: Container(
                        //                           width: positionX * 1.5 > 144 ? 72 : positionX * 3/4,
                        //                           height: positionX * 1.5 > 144 ? 72 : positionX * 3/4,
                        //                           decoration: BoxDecoration(
                        //                             border: Border.all(
                        //                               color: Colors.black,
                        //                               width: positionXabs/24 > 6 ? 6 : positionXabs/24
                        //                             ),
                        //                             borderRadius: BorderRadius.circular(positionX * 2 > 144 ? 24 : positionX/3.2),
                        //                             image: const DecorationImage(
                        //                               image: AssetImage("assets/images/ic_like-background.png"),
                        //                               fit: BoxFit.cover
                        //                             ),
                        //                           ),
                        //                           child: Center(
                        //                             child: Image.asset("assets/images/ic_icon-like.png", color: Colors.white, width: positionX * 1.5 > 144 ? 32 : positionX/3, height: positionX * 1.5 > 144 ? 32 : positionX/3,),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     if(controller.cardPositionX < 0)
                        //                     Positioned(
                        //                       top: contentHeight/2 + (positionXabs * 1.5 > 144 ? -36 : -positionXabs*3/8),
                        //                       right: positionXabs * 1.5 > 144 ? -36 : -positionXabs * 3/8,
                        //                       child: AnimatedOpacity(
                        //                         duration: const Duration(milliseconds: 200),
                        //                         opacity: controller.cardPositionX.abs()/144 > 1 ? 1 : controller.cardPositionX.abs()/144,
                        //                         child: Container(
                        //                           width: positionXabs * 1.5 > 144 ? 72 : positionXabs * 3/4,
                        //                           height: positionXabs * 1.5 > 144 ? 72 : positionXabs * 3/4,
                        //                           decoration: BoxDecoration(
                        //                             border: Border.all(
                        //                               color: Colors.black,
                        //                               width: positionXabs/24 > 6 ? 6 : positionXabs/24
                        //                             ),
                        //                             borderRadius: BorderRadius.circular(positionXabs * 2 > 144 ? 24 : positionXabs/3.2),
                        //                             image: const DecorationImage(
                        //                               image: AssetImage("assets/images/ic_unlike-background.png"),
                        //                               fit: BoxFit.cover
                        //                             ),
                        //                           ),
                        //                           child: Center(
                        //                             child: Image.asset("assets/images/ic_icon-unlike.png", color: Colors.white, width: positionXabs * 1.5 > 144 ? 28 : positionXabs/3.6, height: positionXabs * 1.5 > 144 ? 28 : positionXabs/3.6,),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       AnimatedPositioned(
                        //         duration: const Duration(milliseconds: 200),
                        //         curve: Curves.ease,
                        //         left: 0,
                        //         bottom: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : sizes.safePaddingBottom,
                        //         child: AnimatedOpacity(
                        //           duration: const Duration(milliseconds: 200),
                        //           opacity: (controller.cardPositionX.abs() > 20 || controller.cardPositionY.abs() > 20) ? 0 : 1,
                        //           child: SizedBox(
                        //             width: Get.width,
                        //             height: actionSectionHeight,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(bottom: 24),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   TapDownScaleAnimation(
                        //                     onTap: () {},
                        //                     child: Container(
                        //                       width: actionButtonWidth - 8,
                        //                       height: actionButtonWidth - 8,
                        //                       decoration: BoxDecoration(
                        //                         borderRadius: BorderRadius.circular(22),
                        //                         gradient: const LinearGradient(colors: [Color(0xFFFBAB43), Color(0xFFFF4B00)], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                        //                       ),
                        //                       child: Center(
                        //                         child: Image.asset("assets/images/ic_icon-unlike.png", width: 26, height: 26, color: Colors.white,),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   AppSpaces.horizontal16,
                        //                   TapDownScaleAnimation(
                        //                     onTap: () {},
                        //                     child: Container(
                        //                       width: actionButtonWidth,
                        //                       height: actionButtonWidth,
                        //                       decoration: BoxDecoration(
                        //                         borderRadius: BorderRadius.circular(24),
                        //                         gradient: const LinearGradient(colors: [Color(0xFF43AFFB), Color(0xFF0022FF)], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                        //                       ),
                        //                       child: Center(
                        //                         child: Image.asset("assets/images/ic_icon-super-like.png", width: 34, height: 34, color: Colors.white,),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   AppSpaces.horizontal16,
                        //                   TapDownScaleAnimation(
                        //                     onTap: () {},
                        //                     child: Container(
                        //                       width: actionButtonWidth - 8,
                        //                       height: actionButtonWidth - 8,
                        //                       decoration: BoxDecoration(
                        //                         borderRadius: BorderRadius.circular(22),
                        //                         gradient: const LinearGradient(colors: [Color(0xFFF93159), Color(0xFFFF0000)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                        //                       ),
                        //                       child: Center(
                        //                         child: Image.asset("assets/images/ic_icon-like.png", width: 32, height: 32, color: Colors.white,),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

PreferredSize _appBar(double appBarHeight, double statusBarHeight) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight),
    child: Container(
      height: appBarHeight,
      width: Get.width,
      // color: Colors.red,
      // decoration: BoxDecoration(
      //   // border: Border(
      //   //   bottom: BorderSide(
      //   //     color: AppColors.borderColor,
      //   //     width: 1
      //   //   )
      //   // )
      //   // color: AppColors.barColor,
      //   // boxShadow: [
      //   //   BoxShadow(
      //   //     color: AppColors.shadowColorBlackSmooth,
      //   //     offset: Offset(0, 0),
      //   //     blurRadius: 5,
      //   //     spreadRadius: 0
      //   //   )
      //   // ],
      // ),
      padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
          ),
          // textStyled("Home", 16, AppColors.secondaryTextColor),
          // Image.asset(AppAssets.animationLogo, width: 36,),
          Image.asset("assets/images/ic_matchup-logo.png", width: 132,),
          const SizedBox(
            width: 42,
            height: 42,
          )
        ],
      ),
    ),
  );
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sizes = AppSizes(context);
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       appBar: AppBar(),
//       body: ScrollConfiguration(
//         behavior: const ScrollBehavior(),
//         child: GlowingOverscrollIndicator(
//           showLeading: false,
//           showTrailing: false,
//           color: Colors.transparent,
//           axisDirection: AxisDirection.down,
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 20, top: 30),
//             child: Column(
//               children: [
//                 AppSpaces.vertical20,
//                 Obx(
//                   () {
//                     final homeController = HomeScreenController();
//                     final cinemas = homeController.cinemas;
//                     print("OBX_CINEMAS: $cinemas");
//                     return SizedBox(
//                       width: Get.width,
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: cinemas.length,
//                         scrollDirection: Axis.vertical,
//                         separatorBuilder: (context, index) => AppSpaces.vertical8,
//                         padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 0),
//                         itemBuilder: (context, index) => CinemaCard(
//                           cinema: cinemas[index],
//                         ),
//                       ),
//                     );
//                   }
//                 ),
//               ],
//             ),
//           ),
//         ),
//       )
//     );
//   }
// }


// import 'package:ecinema_watch_together/controlllers/main_controller.dart';
// import 'package:ecinema_watch_together/utils/app/app_assets.dart';
// import 'package:ecinema_watch_together/utils/app/app_colors.dart';
// import 'package:ecinema_watch_together/utils/app/app_constants.dart';
// import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
// import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
// import 'package:ecinema_watch_together/views/home/home_controller.dart';
// import 'package:ecinema_watch_together/widgets/animations/custom_shimmer_loading_animation.dart';
// import 'package:ecinema_watch_together/widgets/cinema_card.dart';
// import 'package:ecinema_watch_together/widgets/screen_section.dart';
// import 'package:ecinema_watch_together/widgets/text_styled.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sizes = AppSizes(context);
//     final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
//     return GetBuilder(
//       init: HomeScreenController(),
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: AppColors.appBarColor,
//           appBar: _appBar(appBarHeight, sizes.statusBarHeight),
//           body: ScrollConfiguration(
//             behavior: const ScrollBehavior().copyWith(overscroll: false),
//             child: GlowingOverscrollIndicator(
//               showLeading: false,
//               showTrailing: false,
//               color: AppColors.themeColor,
//               axisDirection: AxisDirection.down,
//               child: SingleChildScrollView(
//                 physics: const ClampingScrollPhysics(),
//                 padding: EdgeInsets.only(bottom: sizes.safePaddingBottom, top: 0),
//                 child: Column(
//                   children: [
//                     Obx(
//                       () {
//                         final mainController = Get.find<MainController>();
//                         final hasCinemasInitialized = mainController.hasCinemasInitialized.value;
//                         final cinemas = mainController.cinemas.value;
//                         print("OBX_CINEMAS: $cinemas");

//                         if(!hasCinemasInitialized) {
//                           return ScreenSection(
//                             header: "loading",
//                             headerWidget: const CustomShimmerLoadingAnimation(width: 80, height: 20, radius: 6,),
//                             backgroundColor: Colors.transparent,
//                             verticalPadding: 0,
//                             child: SizedBox(
//                               width: Get.width,
//                               child: ListView.separated(
//                                 shrinkWrap: true,
//                                 itemCount: 6,
//                                 scrollDirection: Axis.vertical,
//                                 separatorBuilder: (context, index) => AppSpaces.vertical12,
//                                 padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 0),
//                                 itemBuilder: (context, index) => const CinemaCardSkeletion()
//                               ),
//                             ),
//                           );
//                         }

//                         if(cinemas == null || cinemas.isEmpty) {
//                           return SizedBox(
//                             width: Get.width,
//                             height: Get.height - sizes.safePaddingBottom - 56 - 50 - sizes.statusBarHeight,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset("assets/images/ic_icon-popcorn.png", width: 62, height: 62,),
//                                 AppSpaces.vertical16,
//                                 textStyled("Sinema bulunamadı", 14, AppColors.themeColor, fontWeight: FontWeight.w500),
//                                 AppSpaces.vertical2,
//                                 textStyled("Aktif bir sinema bulunmamaktadır.", 12, AppColors.greyTextColor, fontWeight: FontWeight.w400),
//                               ],
//                             ),
//                           );
//                         }
                    
//                         // return ScreenSection(
//                         //   header: "Cinemas",
//                         //   backgroundColor: Colors.transparent,
//                         //   verticalPadding: 0,
//                         //   child: SizedBox(
//                         //     width: Get.width,
//                         //     child: ListView.separated(
//                         //       shrinkWrap: true,
//                         //       itemCount: cinemas.length,
//                         //       scrollDirection: Axis.vertical,
//                         //       physics: const NeverScrollableScrollPhysics(),
//                         //       separatorBuilder: (context, index) => AppSpaces.vertical12,
//                         //       padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 0),
//                         //       itemBuilder: (context, index) => CinemaCard(
//                         //         cinema: cinemas[index],
//                         //       ),
//                         //     ),
//                         //   ),
//                         // );
//                         return Container(
//                           width: Get.width,
//                           height: Get.height,
//                           color: Colors.green,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// PreferredSize _appBar(double appBarHeight, double statusBarHeight) {
//   return PreferredSize(
//     preferredSize: Size.fromHeight(appBarHeight),
//     child: Container(
//       height: appBarHeight,
//       width: Get.width,
//       color: Colors.red,
//       // decoration: BoxDecoration(
//       //   // border: Border(
//       //   //   bottom: BorderSide(
//       //   //     color: AppColors.borderColor,
//       //   //     width: 1
//       //   //   )
//       //   // )
//       //   // color: AppColors.barColor,
//       //   // boxShadow: [
//       //   //   BoxShadow(
//       //   //     color: AppColors.shadowColorBlackSmooth,
//       //   //     offset: Offset(0, 0),
//       //   //     blurRadius: 5,
//       //   //     spreadRadius: 0
//       //   //   )
//       //   // ],
//       // ),
//       padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const SizedBox(
//             width: 42,
//             height: 42,
//           ),
//           // textStyled("Home", 16, AppColors.secondaryTextColor),
//           Image.asset(AppAssets.animationLogo, width: 36,),
//           const SizedBox(
//             width: 42,
//             height: 42,
//           )
//         ],
//       ),
//     ),
//   );
// }

// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final sizes = AppSizes(context);
// //     return Scaffold(
// //       backgroundColor: AppColors.scaffoldBackgroundColor,
// //       appBar: AppBar(),
// //       body: ScrollConfiguration(
// //         behavior: const ScrollBehavior(),
// //         child: GlowingOverscrollIndicator(
// //           showLeading: false,
// //           showTrailing: false,
// //           color: Colors.transparent,
// //           axisDirection: AxisDirection.down,
// //           child: SingleChildScrollView(
// //             physics: const ClampingScrollPhysics(),
// //             padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 20, top: 30),
// //             child: Column(
// //               children: [
// //                 AppSpaces.vertical20,
// //                 Obx(
// //                   () {
// //                     final homeController = HomeScreenController();
// //                     final cinemas = homeController.cinemas;
// //                     print("OBX_CINEMAS: $cinemas");
// //                     return SizedBox(
// //                       width: Get.width,
// //                       child: ListView.separated(
// //                         shrinkWrap: true,
// //                         itemCount: cinemas.length,
// //                         scrollDirection: Axis.vertical,
// //                         separatorBuilder: (context, index) => AppSpaces.vertical8,
// //                         padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 0),
// //                         itemBuilder: (context, index) => CinemaCard(
// //                           cinema: cinemas[index],
// //                         ),
// //                       ),
// //                     );
// //                   }
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       )
// //     );
// //   }
// // }