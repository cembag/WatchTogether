import 'package:ecinema_watch_together/services/route_service.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/views/chat/private/chats/private_chats_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/animations/custom_shimmer_loading_animation.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kChatDetailHeight = 72.0;
const _kChatDetailVerticalPadding = 14.0;

class PrivateChatsScreen extends StatelessWidget {
  const PrivateChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PrivateChatsScreenController(),
      builder: (controller) {
        final chats = controller.chats.value;
        final isLoading = controller.isLoading.value;

        if(isLoading) {
          return ListView.builder(
            itemCount: 20,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppConstants.bottomNavBarHeight), 
            itemBuilder: (context, index) {
              return chatDetailTileSkeletion();
            },
          );
        }

        if(chats.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/ic_icon-chat-bubble.png", width: 62, height: 62,),
              AppSpaces.vertical16,
              textStyled("Sohbet bulunamadı", 12, AppColors.themeColor, fontWeight: FontWeight.w500),
              AppSpaces.vertical4,
              textStyled("Daha önce sohbet edilmedi", 10, AppColors.greyTextColor, fontWeight: FontWeight.w400),
              AppSpaces.vertical12,
              OutlinedButton(
                onPressed: controller.sendMessage,
                child: textStyled("Mesaj gönder", 12, AppColors.themeColor),
              ),
            ],
          );
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return privateChatTile(context, controller, chat, index);
          },
        );
        
        // final chatDetail = controller.chatDetails.value;
        // final hasAnyChat = chatDetail.isNotEmpty;

        // if(!hasAnyChat) {
        //   return Center(
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Image.asset("assets/images/ic_icon-chat-bubble.png", width: 62, height: 62,),
        //         AppSpaces.vertical16,
        //         textStyled("Sohbet bulunamadı", 14, AppColors.themeColor, fontWeight: FontWeight.w500),
        //         AppSpaces.vertical4,
        //         textStyled("Daha önce sohbet edilmedi", 12, AppColors.greyTextColor, fontWeight: FontWeight.w400),
        //         AppSpaces.vertical12,
        //         OutlinedButton(
        //           onPressed: controller.sendMessage,
        //           child: textStyled("Mesaj gönder", 14, AppColors.themeColor),
        //         )
        //       ],
        //     ),
        //   );
        // }

        // return Column(
        //   children: [
        //     AppSpaces.vertical8,
        //     Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         color: AppColors.themeColor.withOpacity(.1)
        //       ),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           textStyled(controller.chatDetails.value.length.toString(), 14, AppColors.themeColor, fontWeight: FontWeight.w600),
        //           const SizedBox(width: 6,),
        //           const Icon(
        //             CupertinoIcons.person_2_fill,
        //             size: 14,
        //             color: AppColors.themeColor,
        //           )
        //         ],
        //       ),
        //     ),
        //     AppSpaces.vertical30,
        //     Expanded(
        //       child: ScrollConfiguration(
        //         behavior: const ScrollBehavior().copyWith(overscroll: false),
        //         child: ListView.builder(
        //           itemCount: controller.chatDetails.value.length,
        //           itemBuilder: (context, index) {
        //             return privateChatDetailTile(controller, controller.chatDetails.value[index], index);
        //           },
        //         ),
        //       ),
        //      )
        //   ],
        // );
      },
    );
  }
}

Widget chatDetailTileSkeletion() {
  const contentHeigth = _kChatDetailHeight - 2 * _kChatDetailVerticalPadding;
  return Container(
    width: Get.width,
    height: _kChatDetailHeight,
    padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: _kChatDetailVerticalPadding,),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.scaffoldSplashColor,
          width: 1
        )
      )
    ),
    child: Row(
      children: [
        const ClipOval(
          child: CustomShimmerLoadingAnimation(width: contentHeigth, height: contentHeigth),
        ),
        AppSpaces.horizontal12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomShimmerLoadingAnimation(width: 80, height: 16, radius: 4,),
              AppSpaces.vertical4,
              const CustomShimmerLoadingAnimation(width: double.infinity, height: 22, radius: 6,),
            ],
          ),
        ),
        AppSpaces.horizontal24
      ],
    ),
  );
}

Widget privateChatTile(BuildContext context, PrivateChatsScreenController controller, PrivateChat privateChat, int index) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final friendId = privateChat.friend.id;
  final lastMessage = privateChat.chatDetail.lastMessage;
  final hasLastMessage = lastMessage != null;
  final friend = privateChat.friend;
  final message = lastMessage?.text;
  final multimedia = lastMessage?.multimedia;
  final isRead = lastMessage?.readDetail.isRead;
  final isSender = lastMessage?.sender != friendId;
  const contentHeight = _kChatDetailHeight - _kChatDetailVerticalPadding * 2;
  final hasPhoto = friend.profilePhotos != null && friend.profilePhotos!.isNotEmpty;
  // if(friend.photo != null) (NetworkImage(friend.photo!.url), context);
  return Material(
    // color: AppColors.onScaffoldBackgroundColor,
    color: Colors.transparent,
    child: InkWell(
      onTap: () => RouteService.toPrivateChat(friendId: friendId),
      splashColor: AppColors.backgroundLight2,
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      child: Container(
        width: Get.width,
        height: _kChatDetailHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.mHorizontalPadding, vertical: _kChatDetailVerticalPadding,),
        child: Row(
          children: [
            if(friend.useAvatar || !hasPhoto)
            ClipOval(
              child: Image.asset("assets/images/avatars/ic_icon-avatar${friend.avatar}.png", width: contentHeight, height: contentHeight, fit: BoxFit.cover,)
            ),
            if(!friend.useAvatar && hasPhoto)
            Container(
              width: contentHeight,
              height: contentHeight,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundDark4
              ),
              // child: Image.network(friend.profilePhotos!.first.normal, width: contentHeight, height: contentHeight, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              //   if (loadingProgress == null) return child;
              //   return Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Center(
              //       child: CircularProgressIndicator(
              //         backgroundColor: AppColors.scaffoldBackgroundColor,
              //         color: AppColors.themeColor.withOpacity(.8),
              //         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
              //       ),
              //     ),
              //   );
              // }),
            ),
            AppSpaces.horizontal12,
            if(hasLastMessage)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textStyled(friend.username, 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w500, lineHeight: 1),
                        Obx(() {
                          final currentDate = controller.currentDate.value;
                          return textStyled(controller.getTime(currentDate, lastMessage.createdAt), 11, const Color.fromRGBO(140, 142, 150, 1), fontWeight: FontWeight.w500);
                        })
                      ],
                    ),
                  ),
                  AppSpaces.vertical6,
                  Row(
                    children: [
                      if(message == null && multimedia != null)
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(multimedia.url!, width: 22, height: 22, fit: BoxFit.cover,),
                            ),
                            AppSpaces.horizontal8,
                            textStyled("Bir resim paylaşıldı", 13, const Color.fromRGBO(160, 162, 170, 1), fontWeight: FontWeight.w500, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        )
                      ),
                      if(message != null && multimedia == null)
                      Expanded(
                        child: Row(
                          children: [
                            if(isSender)
                            Row(
                              children: [
                                if(isRead!)
                                Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: const Color.fromRGBO(160, 162, 170, 1)),
                                if(!isRead)
                                Image.asset("assets/images/ic_icon-doubletick-filled.png", width: 16, height: 16, color: Colors.blue),
                                AppSpaces.horizontal4,
                              ],
                            ),
                            Expanded(
                              child: textStyled(message, 13, const Color.fromRGBO(160, 162, 170, 1), fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis)
                            ),
                          ],
                        )
                      ),
                      if(message != null && multimedia != null)
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(multimedia.url!, width: 22, height: 22, fit: BoxFit.cover,),
                            ),
                            AppSpaces.horizontal10,
                            Expanded(
                              child: textStyled(message, 13, const Color.fromRGBO(160, 162, 170, 1), fontWeight: FontWeight.w500, maxLines: 1, overflow: TextOverflow.ellipsis),
                            )
                          ],
                        )
                      ),
                      // AppSpaces.horizontal8,
                      // const SizedBox(
                      //   width: contentHeight - 16,
                      //   height: contentHeight - 16,
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Icon(
                      //       Icons.keyboard_arrow_right,
                      //       size: 26,
                      //       color: AppColors.greyTextColor,
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            )
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       textStyled(detail.username, 16, AppColors.secondaryTextColor, fontWeight: FontWeight.w600),
            //       AppSpaces.vertical4,
            //       textStyled("Seni almaya geleceğim biraz bekle beni " * 3, 13, AppColors.greyTextColor, fontWeight: FontWeight.w500, maxLines: 2, overflow: TextOverflow.ellipsis),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   width: contentHeight,
            //   height: contentHeight,
            //   child: Column(
            //     children: [
            //       textStyled("13:05", 14, AppColors.greySmoothTextColor, fontWeight: FontWeight.w600),
            //       AppSpaces.vertical4,
            //       const Expanded(
            //         child: SizedBox(),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    ),
  );
}