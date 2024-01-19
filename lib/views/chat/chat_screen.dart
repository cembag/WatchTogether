import 'package:ecinema_watch_together/entities/firestore/chat_detail_entity.dart';
import 'package:ecinema_watch_together/utils/app/app_assets.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/views/chat/chat_screen_controller.dart';
import 'package:ecinema_watch_together/views/chat/global/global_chat_screen.dart';
import 'package:ecinema_watch_together/views/chat/private/chats/private_chats_screen.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kChatScreens = [
  PrivateChatsScreen(),
  GlobalChatScreen()
];

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    
    return GetBuilder(
      init: ChatScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackgroundColor,
          appBar: _appBar(controller, appBarHeight, sizes.statusBarHeight),
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: _kChatScreens.length,
              onPageChanged: controller.setScreen,
              itemBuilder: (context, index) {
                return _kChatScreens[index];
              },
            ),
          )
        );
      },
    );
  }
}

// Widget avatar(ChatScreenController controller, UserEntity user) {
//   if(user.useAvatar || user.photoUrl == null) {
//     return controller.avatarImage;
//   } else if(controller.profilePhotoInfo.value == null) {
//     return Container(
//       color: Colors.black,
//       child: Center(
//         child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 42, color: AppColors.blackGrey,)
//       ),
//     );
//   } else {
//     return Image.network(
//     user.photoUrl!,
//     fit: BoxFit.cover, 
//     width: controller.avatarImageWidth, 
//     height: controller.avatarImageWidth, 
//     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//       if (loadingProgress == null) return child;
//       return Center(
//         child: CircularProgressIndicator(
//           color: AppColors.themeColor.withOpacity(.5),
//           backgroundColor: AppColors.cardColor,
//           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
//         ),
//       );
//     });
//   }
// }

PreferredSize _appBar(ChatScreenController controller, double appBarHeight, double statusBarHeight) {
  final isGlobal = controller.currentScreen.value == 1;
  const screenPickerWidth = 100.0;
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight),
    child: Container(
      height: appBarHeight,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.barBorderColor,
            width: 1
          )
        )
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
            width: screenPickerWidth,
            height: 42,
          ),
          textStyled("Sohbet", 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w500),
          Container(
            width: screenPickerWidth,
            height: 36,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.backgroundLight1,
              // color: Colors.green
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.backgroundDark4Black,
              ),
              child:Stack(
                children: [
                  AnimatedPositioned(
                    bottom: 0,
                    left: isGlobal ? (screenPickerWidth/2 - 2) : 1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: (screenPickerWidth - 6)/2,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.themeColor,
                        // color: AppColors.themeColor.withOpacity(.5)
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.setScreen(0),
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Opacity(
                                  opacity: isGlobal ? .5 : 1,
                                  child: Image.asset(AppAssets.iconChatFriend, width: 22, height: 22),
                                ),
                              )
                            ),
                          ),
                        ),
                        Expanded(
                          child:  GestureDetector(
                            onTap: () => controller.setScreen(1),
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Opacity(
                                  opacity: isGlobal ? 1 : .5,
                                  child: Image.asset(AppAssets.iconChatWorld, width: 22, height: 22),
                                ),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget chatTile(ChatDetail detail) {
//   return Container(
    
//   );
// }