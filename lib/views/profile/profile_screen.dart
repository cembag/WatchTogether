import 'package:ecinema_watch_together/controlllers/auth_controller.dart';
import 'package:ecinema_watch_together/dal/auth_dal.dart';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/profile/profile_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/animations/custom_shimmer_loading_animation.dart';
import 'package:ecinema_watch_together/widgets/animations/tap_down_opacity_animation.dart';
import 'package:ecinema_watch_together/widgets/bottomsheets/accounts_bottom_sheet.dart';
import 'package:ecinema_watch_together/widgets/buttons/custom_button.dart';
import 'package:ecinema_watch_together/widgets/modals/animated_modal.dart';
import 'package:ecinema_watch_together/widgets/screen_section.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    
    return GetBuilder(
      init: ProfileScreenController(),
      builder: (controller) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              backgroundColor: AppColors.scaffoldBackgroundColor,
              appBar: _appBar(appBarHeight, sizes.statusBarHeight),
              body: Obx(() {
                final authController = Get.find<AuthController>();
                final appUser = authController.appUser.value;

                if(appUser == null) {
                  return SizedBox(
                    width: Get.width,
                    height: Get.height - sizes.safePaddingBottom - 56 - 50 - sizes.statusBarHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/ic_icon-popcorn.png", width: 62, height: 62,),
                        AppSpaces.vertical16,
                        textStyled("Kullanıcı bulunamadı", 14, AppColors.themeColor, fontWeight: FontWeight.w500),
                        AppSpaces.vertical2,
                        textStyled("Aktif bir oturum bulunmamaktadır.", 12, AppColors.greyTextColor, fontWeight: FontWeight.w400),
                      ],
                    ),
                  );
                }

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: GlowingOverscrollIndicator(
                          showLeading: false,
                          showTrailing: false,
                          color: AppColors.themeColor,
                          axisDirection: AxisDirection.down,
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: sizes.safePaddingBottom + 20, top: 8),
                            child: Column(
                              children: [
                                ScreenSection(
                                  showHeader: false,
                                  header: "Profil",
                                  verticalPadding: 0,
                                  child: Container(
                                    width: Get.width,
                                    height: 280,
                                    // color: Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Stack(
                                            children: [
                                              Hero(
                                                tag: 'user_photo', 
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  width: controller.avatarImageWidth,
                                                  height: controller.avatarImageWidth,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(60)
                                                  ),
                                                  child: avatar(controller, appUser),
                                                ),
                                              ),
                                              if(!appUser.useAvatar)
                                              Material(
                                                color: Colors.transparent,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                                                child: InkWell(
                                                  onTap: () => RouteService.toProfilePhoto(appUser),
                                                  highlightColor: Colors.transparent,
                                                  splashColor: Colors.black26,
                                                  splashFactory: InkRipple.splashFactory,
                                                  child: SizedBox(
                                                    width: controller.avatarImageWidth,
                                                    height: controller.avatarImageWidth,
                                                  )
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 2,
                                                right: 2,
                                                child: GestureDetector(
                                                  onTap: appUser.useAvatar ? () => openAvatarMenu(controller) : controller.updateUserPhoto,
                                                  child: Container(
                                                    width: 36,
                                                    height: 36,
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors.scaffoldBackgroundColor,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors.backgroundLight1,
                                                        border: Border.all(
                                                          color: AppColors.backgroundLight3,
                                                          width: 1,
                                                        )
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 14,
                                                          color: AppColors.textWhiteDark2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        AppSpaces.vertical16,
                                        Material(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.circular(6),
                                          color: AppColors.backgroundLight1,
                                          child: InkWell(
                                            onTap: () async => (appUser.useAvatar && appUser.profilePhotos == null && appUser.profilePhotos!.isEmpty) ? await controller.updateUserPhoto() : await controller.updateOrToggleUseAvatar(),
                                            splashColor: Colors.black26,
                                            splashFactory: InkRipple.splashFactory,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: AppColors.backgroundLight3,
                                                  width: 1
                                                )
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  textStyled(appUser.useAvatar ? "Fotoğrafımı kullan" : "Avatarımı kullan", 14, AppColors.textWhiteDark2, fontWeight: FontWeight.w500),
                                                ],
                                              )
                                            ),
                                          ),
                                        ),
                                        AppSpaces.vertical24,
                                        if(appUser.bio.isNotEmpty)
                                        Expanded(
                                          child: textStyled(appUser.bio.replaceAll(r'\n', '\n') * 3, 14, AppColors.secondaryTextColor, fontWeight: FontWeight.w600, textAlign: TextAlign.center, lineHeight: 1.4),
                                        ),
                                        if(appUser.bio.isEmpty)
                                         Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            textStyled("BJK\nKAAN ALTINTAŞ\nBURADAN HERKESE SELAM SÖYLÜYORUM 😄,\n birdaha benim adımı anmayın", 16, AppColors.textWhiteDark2, textAlign: TextAlign.center, fontWeight: FontWeight.w400, lineHeight: 1.2),
                                            // AppSpaces.horizontal8,
                                            // GestureDetector(
                                            //   onTap: () {},
                                            //   child: const Icon(
                                            //     Icons.edit,
                                            //     size: 16,
                                            //     color: AppColors.whiteGrey,
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        // if(appUser.bio.isEmpty)
                                        // Expanded(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding * 2),
                                        //     child: Container(
                                        //       width: double.infinity,
                                        //       padding: const EdgeInsets.all(12),
                                        //       decoration: BoxDecoration(
                                        //         color: AppColors.onScaffoldBackgroundColor,
                                        //         borderRadius: BorderRadius.circular(12),
                                        //         border: Border.all(
                                        //           color: AppColors.borderColor, 
                                        //           width: 1
                                        //         )
                                        //       ),
                                        //       child: Row(
                                        //         children: [
                                        //           textStyled("Bu kullanıcı hiçbir şey yapmamış...", 14, AppColors.whiteGrey2, fontWeight: FontWeight.w500),
                                        //           AppSpaces.horizontal8,
                                        //           GestureDetector(
                                        //             onTap: () {},
                                        //             child: const Icon(
                                        //               Icons.edit,
                                        //               size: 16,
                                        //               color: AppColors.whiteGrey,
                                        //             ),
                                        //           )
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
                                        
                                        // Expanded(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: 8),
                                        //     child: TextField(
                                        //       controller: controller.bioTextController,
                                        //       focusNode: controller.bioTextFocusNode,
                                        //       onChanged: controller.onBioTextChanged,
                                        //       keyboardType: TextInputType.multiline,
                                        //       textAlign: TextAlign.center,
                                        //       maxLines: 4,
                                        //       style: const TextStyle(
                                        //         color: AppColors.secondaryTextColor,
                                        //         fontWeight: FontWeight.w600,
                                        //       ),
                                        //       decoration: const InputDecoration(
                                        //         filled: true,
                                        //         enabledBorder: InputBorder.none,
                                        //         focusedBorder: OutlineInputBorder(
                                                  
                                        //         )
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   // textStyled(appUser.bio.replaceAll(r'\n', '\n') * 2, 14, AppColors.secondaryTextColor, fontWeight: FontWeight.w600, textAlign: TextAlign.center),
                                        // ),
                                        // Expanded(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.all(AppConstants.mHorizontalPadding),
                                        //     child: Container(
                                        //       width: Get.width,
                                        //       decoration: BoxDecoration(
                                        //         color: Colors.black,
                                        //         // color: Color.fromARGB(255, 15, 17, 17),
                                        //         borderRadius: BorderRadius.circular(8),
                                        //         border: Border.all(
                                        //           color: AppColors.borderColor,
                                        //           // color: Color.fromARGB(255, 26, 30, 34),
                                        //           width: 1
                                        //         )
                                        //       ),
                                        //       child: Stack(
                                        //         children: [
                                        //           Positioned.fill(
                                        //             child: Padding(
                                        //               padding: const EdgeInsets.all(12),
                                        //               child: Column(
                                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                                        //                 children: [
                                        //                   SizedBox(
                                        //                     width: double.infinity,
                                        //                     height: 20,
                                        //                     child: textStyled("Hakkımda", 13, AppColors.greyTextColor, fontWeight: FontWeight.w500,),
                                        //                   ),
                                        //                   Expanded(
                                        //                     child: textStyled(appUser.bio.replaceAll(r'\n', '\n') * 2, 14, AppColors.secondaryTextColor, fontWeight: FontWeight.w600,),
                                        //                   )
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           Positioned(
                                        //             top: 8,
                                        //             right: 8,
                                        //             child: Container(
                                        //               width: 24,
                                        //               height: 24,
                                        //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        //               decoration: BoxDecoration(
                                        //                 borderRadius: BorderRadius.circular(4),
                                        //                 color: Colors.blue.withOpacity(.2),
                                        //               ),
                                        //               child: const Center(
                                        //                 child: Icon(
                                        //                   Icons.edit,
                                        //                   size: 12,
                                        //                   color: Colors.blue,
                                        //                 ),
                                        //               )
                                        //             ),
                                        //           )
                                        //         ],
                                        //       )
                                        //     ),
                                        //   )
                                        // ),
                                      ],
                                    )
                                  ),
                                ),
                                
                                // color: const Color.fromARGB(255, 35, 40, 45),
                                // color: const Color.fromARGB(255, 16, 18, 22),
                                
                                // ScreenSection(
                                //   header: "Ayarlar",
                                //   verticalPadding: 0,
                                //   child: Column(
                                //     children: [
                                //       _setting(AppAssets.iconUser, "Bilgilerimi güncelle", () {}, hasBorder: true),
                                //       _setting(AppAssets.iconQuestion, "Sık sorulan sorular", () {}),
                                //       _quitButton(context)
                                //     ],
                                //   )
                                // ),
                                AppSpaces.vertical16,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
            ),
            // Container(
            //   width: Get.width,
            //   height: Get.height,
            //   color: const Color.fromRGBO(20, 20, 20, .5),
            //   child: const Center(
            //     child: LoadingAnimation(),
            //   ),
            // )
          ],
        );
      },
    );
  }
}

Widget _setting(String iconPath, String text, void Function() onTap, {bool hasBorder = false}) {
  return Material(
    color: AppColors.onScaffoldBackgroundColor,
    child: InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      splashColor: AppColors.scaffoldSplashColor,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.borderColor,
              width: 1
            ),
            top: BorderSide(
              color: hasBorder ? AppColors.borderColor : Colors.transparent,
              width: 1
            )
          )
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 18, color: AppColors.whiteGrey,),
            AppSpaces.horizontal20,
            textStyled(text, 14, AppColors.whiteGrey, fontWeight: FontWeight.w600)
          ],
        ),
      ),
    ),
  );
}

Widget _quitButton(BuildContext context) {
  return Material(
    color: AppColors.onScaffoldBackgroundColor,
    child: InkWell(
      onTap: AuthDal.instance.signOut,
      splashColor: const Color(0xFFFF8686).withOpacity(.2),
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1
          )
        )
      ),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding),
        child: Row(
          children: [
            const Icon(
              Icons.logout,
              color: Color(0xFFFF8686),
              size: 22,
            ),
            AppSpaces.horizontal20,
            textStyled("Çıkış yap", 14, const Color(0xFFFF8686), fontWeight: FontWeight.w600)
          ],
        ),
      ),
    ),
  );
}

Widget avatar(ProfileScreenController controller, UserEntity user) {
  // toggle the comment
  return const SizedBox();
  // if(user.useAvatar || user.profilePhoto == null) {
  //   return Image.asset('assets/images/avatars/ic_icon-avatar${user.avatar}.png', width: controller.avatarImageWidth, height: controller.avatarImageWidth, fit: BoxFit.cover);
  // } else {
  //   final photoUrl = user.profilePhoto!.url;
  //   return Image.network(
  //   photoUrl,
  //   fit: BoxFit.cover, 
  //   width: controller.avatarImageWidth, 
  //   height: controller.avatarImageWidth, 
  //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  //     if (loadingProgress == null) return child;
  //     return Center(
  //       child: CircularProgressIndicator(
  //         color: AppColors.themeColor.withOpacity(.5),
  //         backgroundColor: AppColors.cardColor,
  //         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
  //       ),
  //     );
  //   });
  // }
}

void openAvatarMenu(ProfileScreenController controller) {
  const avatarPickerMaxWidth = 320.0;
  const avatarMaxWidth = 60.0;
  const avatarMinWidth = 42.0;
  const avatarPickerRatio = 1;
  final avatarPickerWidth = Get.width - 2 * AppConstants.mHorizontalPadding > avatarPickerMaxWidth ? avatarPickerMaxWidth : Get.width - 2 * AppConstants.mHorizontalPadding;
  final avatarPickerHeight = avatarPickerWidth * avatarPickerRatio;

  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withOpacity(.2),
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 64,
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: controller.avatarImageWidth, 
              height: controller.avatarImageWidth,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.scaffoldBackgroundColor,
              ),
              child: Obx(() => Image.asset("assets/images/avatars/ic_icon-avatar${controller.selectedAvatar.value}.png", fit: BoxFit.cover,)),
            ),
          ),
          Positioned(
            top: 200,
            child: AnimatedModal(
              width: avatarPickerWidth,
              height: avatarPickerHeight,
              child: menuModal(controller, avatarPickerWidth, avatarPickerHeight),
            ),
          )
        ],
      );
    }
  );
}

Widget menuModal(ProfileScreenController controller, double width, double height) {
  return Obx(() {
    final authController = Get.find<AuthController>();
    final user = authController.appUser.value!;
    final canSubmit = controller.selectedAvatar.value != user.avatar && !controller.loading.value; 
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 35, 40, 45),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity ,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 16, 18, 22),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              color: const Color.fromARGB(255, 0, 0, 0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(controller.avatarMenuTitles.length, (index) {
                  final title = controller.avatarMenuTitles[index];
                  final isSelected = controller.selectedTitle.value == title.value;
                  return GestureDetector(
                    onTap: () => controller.setSelectedTitle(title.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      // width: isSelected ? ((width - 2)/controller.avatarMenuTitles.length) + 20 : ((width - 2)/controller.avatarMenuTitles.length) - 20/(controller.avatarMenuTitles.length - 1),
                      width: ((width - 2)/controller.avatarMenuTitles.length) < 62 ? 62 : ((width - 2)/controller.avatarMenuTitles.length),
                      height: 40,
                      decoration: BoxDecoration(
                        border: !isSelected ? const Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 35, 40, 45),
                            width: 1
                          )
                        ) : index == 0
                        ? const Border(
                          right: BorderSide(
                            color: Color.fromARGB(255, 35, 40, 45),
                            width: 1
                          )
                        ) : index == controller.avatarMenuTitles.length - 1
                        ? const Border(
                          left: BorderSide(
                            color: Color.fromARGB(255, 35, 40, 45),
                            width: 1
                          ),
                        ) : const Border(
                          left: BorderSide(
                            color: Color.fromARGB(255, 35, 40, 45),
                            width: 1
                          ),
                          right: BorderSide(
                            color: Color.fromARGB(255, 35, 40, 45),
                            width: 1
                          )
                        ),
                        color: isSelected ? const Color.fromARGB(255, 16, 18, 22) : null,
                      ),
                      child: Center(
                        child: textStyled(title.title, 13, isSelected ? AppColors.secondaryTextColor : AppColors.greyTextColor, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
                      ),
                    ),
                  );
                })
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.menuAvatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, mainAxisSpacing: 4, crossAxisSpacing: 4),
                  itemBuilder: (context, index) {
  
                    final avatar = controller.menuAvatars[index];
                    final isSelected = controller.selectedAvatar.value == avatar;
                    final isSelectable = controller.isAvatarSelectable(user.gender, avatar);
                    
                    return GestureDetector(
                      onTap: isSelectable ? () => controller.setSelectedAvatar(avatar) : null,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.themeColor : const Color.fromARGB(255, 31, 33, 40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Opacity(
                          opacity: isSelectable ? 1 : .2,
                          child: Image.asset('assets/images/avatars/ic_icon-avatar$avatar.png'),
                        )
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 46,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 35, 40, 45),
                    width: 1
                  )
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: canSubmit ? controller.updateUserAvatar : null,
                      radius: 6,
                      fontSize: 16,
                      backgroundColor: canSubmit ? AppColors.themeColor : AppColors.blackGrey,
                      textColor: canSubmit ? AppColors.primaryButtonTextColor : AppColors.greyTextColor,
                      text:  "Avatarı kullan",
                    )
                  ),
                  AppSpaces.horizontal8,
                  GestureDetector(
                    onTap: !controller.loading.value ? () => Navigator.of(Get.context!).pop() : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.blackGrey,
                      ),
                      width: 30,
                      height: 30,
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  });
}

PreferredSize _appBar(double appBarHeight, double statusBarHeight) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight),
    child: Container(
      height: appBarHeight,
      width: Get.width,
      decoration: const BoxDecoration(
        // color: AppColors.barColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.shadowColorBlackSmooth,
        //     offset: Offset(0, 0),
        //     blurRadius: 5,
        //     spreadRadius: 0
        //   )
        // ],
      ),
      padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, statusBarHeight, AppConstants.mHorizontalPadding, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
          ),
          Obx(
            () {
              final authController = Get.find<AuthController>();
              final appUser = authController.appUser.value;

              if(appUser == null) {
                return const CustomShimmerLoadingAnimation(
                  radius: 6,
                  width: 100,
                  height: 24,
                );
              }

              return TapDownOpacityAnimation(
                onTap: () => showAccountsBottomSheet(Get.context!, appUser),
                child: Row(
                  children: [
                    textStyled(appUser.username, 18, AppColors.primaryTextColor, fontWeight: FontWeight.w700),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSpaces.vertical2,
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColors.primaryTextColor,
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          ),
          const SizedBox(
            width: 42,
            height: 42,
          )
        ],
      ),
    ),
  );
}

