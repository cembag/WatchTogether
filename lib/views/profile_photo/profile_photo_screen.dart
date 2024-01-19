import 'dart:ui';
import 'package:ecinema_watch_together/entities/firestore/user_entity.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/profile_photo/profile_photo_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfilePhotoScreen extends StatelessWidget {
  final UserEntity user;
  const ProfilePhotoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    // final imageUrl = user.profilePhoto!.url;
    // final imageCreatedAt = user.profilePhoto!.createdAt;
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    final navigationBarHeight = 56.0 + sizes.safePaddingBottom;
    // void showActions() => showActionsBottomSheet(context, imageUrl, ContentType.image, user);
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
        return true;
      },
      child: GetBuilder(
        init: ProfilePhotoScreenController(user: user),
        builder: (controller) {
          final isBarVisible = controller.barVisibility.value;
          return GestureDetector(
            onTap: controller.toggleBar,
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'user_photo',
                      child: Container(
                        width: Get.width,
                        height: Get.height,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.zero
                        ),
                        // child: Image.network(imageUrl, fit: BoxFit.contain,),
                      )
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    top: isBarVisible ? 0 : -appBarHeight,
                    left: 0,
                    child: GestureDetector(
                      onTap: controller.showBar,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isBarVisible ? 1 : 0,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              width: Get.width,
                              height: appBarHeight,
                              padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, sizes.statusBarHeight, AppConstants.mHorizontalPadding, 0),
                              color: const Color.fromRGBO(2, 4, 8, .6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 24,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AppSpaces.horizontal16,
                                  Expanded(
                                    child: textStyled(user.username, 20, AppColors.secondaryTextColor, fontWeight: FontWeight.w500, maxLines: 2, overflow: TextOverflow.ellipsis)
                                  ),
                                  AppSpaces.horizontal16,
                                  GestureDetector(
                                    // onTap: showActions,
                                    child: const SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Icon(
                                          Icons.more_vert,
                                          size: 24,
                                          color: AppColors.secondaryTextColor,
                                        )
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    bottom: isBarVisible ? 0 : -navigationBarHeight,
                    left: 0,
                    child: GestureDetector(
                      onTap: controller.showBar,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isBarVisible ? 1 : 0,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              width: Get.width,
                              height: navigationBarHeight,
                              padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, 0, AppConstants.mHorizontalPadding, sizes.safePaddingBottom),
                              color: const Color.fromRGBO(2, 4, 8, .6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // textStyled("Son güncellenme tarihi: ${DateFormat('yyyy/MM/dd hh:mm:ss', AppServices.locale.languageCode).format(imageCreatedAt)}", 14, AppColors.whiteGrey2, fontWeight: FontWeight.w500),
                                ],
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
          );
        },
      ),
    );
  }
}
