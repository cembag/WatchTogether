import 'package:ecinema_watch_together/entities/firestore/private_message_entity.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/utils/extensions/color_extension.dart';
import 'package:ecinema_watch_together/views/chat/private/chat/private_chat_screen_controller.dart';
import 'package:ecinema_watch_together/views/chat/private/chats/private_chats_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/animations/tap_down_opacity_animation.dart';
import 'package:ecinema_watch_together/widgets/bottomsheets/media_detail_bottom_sheet.dart';
import 'package:ecinema_watch_together/widgets/custom_curves.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:shimmer/shimmer.dart';

class PrivateChatScreen extends StatelessWidget {
  final String friendId;
  final List<PrivateMessage>? pendingMessages;
  const PrivateChatScreen({super.key, required this.friendId, this.pendingMessages});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final appBarHeight = AppConstants.appBarHeight + sizes.statusBarHeight;
    const bottomSectionItemHeight = 42.0;
    const bottomSectionMaxHeight = 146.0;
    const replyPreviewMaxHeight = 88.0;
    final textFieldAreaWidth = Get.width - bottomSectionItemHeight - 4 - 16;
    // const bottomSectionVerticalPadding = 10.0;
    // final bottomSectionHeight = bottomSectionItemHeight + sizes.safePaddingBottom + bottomSectionVerticalPadding * 2;
    return GetBuilder(
      init: PrivateChatScreenController(friendId: friendId, pendingMessages: pendingMessages),
      builder: (controller) {
        final messages = controller.messages.value;
        final selectedMedias = controller.selectedMedias.value;
        return Scaffold(
          appBar: _appBar(controller, appBarHeight, sizes.statusBarHeight),
          backgroundColor: AppColors.scaffoldBackgroundColor,
          // backgroundColor: const Color.fromRGBO(10, 11, 15, 1),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // if(controller.messages.value.isEmpty)
                    // Positioned.fill(
                    //   child: Center(
                    //     child: LoadingAnimationWidget.flickr(
                    //       leftDotColor: Colors.red.withOpacity(.6),
                    //       rightDotColor: Colors.blue.withOpacity(.6),
                    //       size: 24
                    //     ),
                    //   ),
                    // ),
                    if(controller.messages.value.isNotEmpty)
                    Positioned.fill(
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: NotificationListener<ScrollUpdateNotification>(
                          onNotification: controller.onScroll,
                          child: RawScrollbar(
                            thickness: 4,
                            controller: controller.scrollController,
                            thumbColor: AppColors.greySmoothTextColor,
                            child: ListView.separated(
                              reverse: true,
                              itemCount: messages.length,
                              controller: controller.scrollController,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              separatorBuilder: (context, index) => const SizedBox(),
                              itemBuilder: (context, index) {
                                // final reversedMessages = messages.reversed.toList();
                                // final message = reversedMessages[index];
                                final message = messages[index];
                                final isContinue = index == 0 ? true : messages[index - 1].sender == message.sender;
                                // return messageTile(context, controller, message, isContinue);
                                return MessageTile(
                                  // key: GlobalObjectKey(message.id),
                                  mainContext: context,
                                  controller: controller,
                                  message: message, 
                                  isContinue: isContinue
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // if(controller.selectedMessages.isNotEmpty)
                    // ...controller.selectedMessages.map((message) {
                    //   return Builder(
                    //     builder: (context) {
                    //       final key = GlobalObjectKey(message.id);
                    //       final box = key.currentContext!.findRenderObject() as RenderBox?;
                    //       if(box == null) return const SizedBox.shrink();
                    //       final boxHeight = box.size.height;
                    //       final position = box.localToGlobal(Offset.zero);
                    //       final actionsHeight = boxHeight < 80.0 ? 80.0 : boxHeight;
                    //       final actionBoxHeight = actionsHeight - 32;
                    //       print("POSITION: ${position.dy}");
                    //       final isCloseToBottom = position.dy > Get.height/2;
                    //       return Positioned(
                    //         top: isCloseToBottom ? position.dy - appBarHeight - actionsHeight + boxHeight : position.dy - appBarHeight,
                    //         // top: position.dy - appBarHeight
                    //         left: 0,
                    //         child: SizedBox(
                    //           width: Get.width,
                    //           height: actionsHeight,
                    //           child: Stack(
                    //             children: [
                    //               Positioned(
                    //                 top: isCloseToBottom ? actionsHeight - boxHeight : 0,
                    //                 right: 0,
                    //                 child: Container(
                    //                   width: Get.width,
                    //                   height: boxHeight,
                    //                   color: Colors.green.withOpacity(.4),
                    //                 ),
                    //               ),
                    //               Positioned(
                    //                 bottom: (actionsHeight - actionBoxHeight)/2,
                    //                 child: Container(
                    //                   width: Get.width,
                    //                   height: actionBoxHeight,
                    //                   // color: const Color.fromARGB(255, 96, 34, 12).withOpacity(.4),
                    //                   // color: AppColors.backgroundDark4.withOpacity(.6)
                    //                   color: Colors.black45,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }),
                    
                  ],
                ),
              ),
              Obx(() {
                final replySelected = controller.replySelected.value;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final replying = replySelected != null;
                    var replySelectedHeight = 0.0;
                    if(replying) {
                      final span = TextSpan(text: replySelected.text, style: const TextStyle(fontSize: 13));
                      final tp = TextPainter(text: span, textDirection: ui.TextDirection.ltr, maxLines: 3);
                      tp.layout(maxWidth: textFieldAreaWidth - 40);
                      final replyHeight = tp.height + 42;
                      replySelectedHeight = replyHeight > replyPreviewMaxHeight ? replyPreviewMaxHeight : replyHeight;
                    }
                    const imagesSectionHeight = 72.0;
                    const imagesSectionVerticalPadding = 8.0;
                    final hasSelectedAnyImage = selectedMedias.isNotEmpty;
                    var maxHeight = bottomSectionMaxHeight + replySelectedHeight;
                    if(hasSelectedAnyImage) {
                      maxHeight += imagesSectionHeight;
                    }
                    return Container(
                      width: Get.width,
                      constraints: BoxConstraints(
                        maxHeight: maxHeight,
                        // controller.replySelected.value != null ? bottomSectionMaxHeight + 60 : bottomSectionMaxHeight,
                      ),
                      padding: EdgeInsets.fromLTRB(8, 10.0, 8, sizes.safePaddingBottom + 10.0),
                      decoration: BoxDecoration(
                        // color: AppColors.backgroundDark2,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.backgroundDark4,
                            width: 1
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(hasSelectedAnyImage)
                          Container(
                            width: Get.width,
                            height: imagesSectionHeight,
                            padding: const EdgeInsets.only(bottom: imagesSectionVerticalPadding),
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedMedias.length,
                              separatorBuilder: (context, index) => AppSpaces.horizontal6, 
                              itemBuilder: (context, index) {
                                final mediaDetail = selectedMedias[index];
                                const imageSize = imagesSectionHeight - imagesSectionVerticalPadding;
                                final file = mediaDetail.file;
                                return SizedBox(
                                  width: imageSize,
                                  height: imageSize,
                                  child: OverflowBox(
                                    maxWidth: 76,
                                    maxHeight: 76,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: (76 - imageSize)/2,
                                          left: (76 - imageSize)/2,
                                          child: GestureDetector(
                                            onTap: () => showMediaDetailBottomSheet(context, mediaDetail),
                                            child: Container(
                                              width: imageSize,
                                              height: imageSize,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Image.file(file, fit: BoxFit.cover,),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => controller.removeMedia(index),
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: AppColors.backgroundDark2,
                                                shape: BoxShape.circle
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.greyTextColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.backgroundDark2,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        topLeft: Radius.circular(replying ? 14 : 20),
                                        topRight: Radius.circular(replying ? 14 : 20),
                                      ),
                                      color: AppColors.backgroundDark4
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: replying ? replySelectedHeight : 0, 
                                          color: AppColors.backgroundDark4,
                                          // duration: const Duration(milliseconds: 300),
                                          // padding: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                          child: Builder(
                                            builder: (context) {
                                              if(!replying) return const SizedBox.shrink();
                                              final isSender = replySelected.sender == controller.appUser!.id;
                                              final friend = controller.friend.value;
                                              final color = isSender ? AppColors.themeColor : const Color.fromARGB(255, 69, 173, 0);
                                              return Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: AppColors.backgroundDark2,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 4,
                                                            height: double.infinity,
                                                            color: color,
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(10,6,10,6),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  textStyled(isSender ? "Sen" : friend!.username, 15, color, overflow: TextOverflow.ellipsis),
                                                                  AppSpaces.vertical2,
                                                                  Expanded(
                                                                    child: Text(replySelected.text!, style: const TextStyle(color: Color.fromRGBO(160, 162, 170, 1), fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis,),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 4,
                                                      right: 4,
                                                      child: GestureDetector(
                                                        onTap: controller.unSelectReplySelected,
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: AppColors.backgroundDark2,
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 14,
                                                              color: AppColors.greyTextColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ),
                                        Flexible(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Material(
                                                clipBehavior: Clip.hardEdge,
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(50),
                                                child: InkWell(
                                                  onTap: controller.toggleEmojiMenu,
                                                  splashColor: AppColors.textGreyDark2,
                                                  highlightColor: Colors.transparent,
                                                  splashFactory: InkRipple.splashFactory,
                                                  child: const SizedBox(
                                                    width: bottomSectionItemHeight,
                                                    height: bottomSectionItemHeight,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.emoji_emotions_rounded,
                                                        size: 26,
                                                        color: AppColors.textWhiteDark3
                                                      )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: RawScrollbar(
                                                  thickness: 4,
                                                  thumbColor: AppColors.textGreyBase,
                                                  controller: controller.textFieldScrollController,
                                                  padding: const EdgeInsets.only(bottom: -12),
                                                  child: LayoutBuilder(
                                                    builder: (context, constraints) {
                                                      final span = TextSpan(text: controller.message.value, style: const TextStyle(fontSize: 16, height: 1.2));
                                                      final tp = TextPainter(text: span, textDirection: ui.TextDirection.ltr);
                                                      tp.layout(maxWidth: textFieldAreaWidth - bottomSectionItemHeight * 2 - 2);
                                                      final numLines = tp.computeLineMetrics().length;
                                                      final maxHeight = numLines > 1 ? bottomSectionMaxHeight : bottomSectionItemHeight;
                                                      return TextField(
                                                        maxLines: null,
                                                        scrollController: controller.textFieldScrollController,
                                                        onSubmitted: (value) => controller.sendMessage(),
                                                        focusNode: controller.focusNode,
                                                        controller: controller.textEditingController,
                                                        onChanged: controller.onTextChange,
                                                        keyboardType: TextInputType.multiline,
                                                        style: const TextStyle(
                                                          color: AppColors.secondaryTextColor,
                                                          fontSize: 16,
                                                          height: 1.2,
                                                          fontWeight: FontWeight.w400
                                                        ),
                                                        decoration: InputDecoration(
                                                          hintText: "Bir mesaj yazın",
                                                          hintStyle: const TextStyle(
                                                            color: AppColors.textGreyBase,
                                                            fontSize: 16
                                                          ),
                                                          constraints: BoxConstraints(
                                                            minHeight: bottomSectionItemHeight,
                                                            maxHeight: maxHeight
                                                          ),
                                                          // contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                                          // contentPadding: EdgeInsets.zero,
                                                          contentPadding: const EdgeInsets.only(right: 2, top: 12,),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            borderSide: const BorderSide(
                                                              width: 0,
                                                              color: Colors.transparent,
                                                            )
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            borderSide: const BorderSide(
                                                              width: 0,
                                                              color: Colors.transparent,
                                                            )
                                                          ),
                                                          filled: true,
                                                          fillColor: AppColors.backgroundDark4,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ),
                                              ),
                                              Material(
                                                clipBehavior: Clip.hardEdge,
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(50),
                                                child: InkWell(
                                                  onTap: controller.pickMedia,
                                                  // () => RouteService.toMediaGallery(),
                                                  splashColor: AppColors.textGreyDark2,
                                                  highlightColor: Colors.transparent,
                                                  splashFactory: InkRipple.splashFactory,
                                                  child: SizedBox(
                                                    width: bottomSectionItemHeight,
                                                    height: bottomSectionItemHeight,
                                                    child: Center(
                                                      child: Transform(
                                                        alignment: FractionalOffset.center,
                                                        transform: Matrix4.identity()..rotateZ(-45 * 3.1415927 / 180),
                                                        child: const Icon(
                                                          Icons.attach_file,
                                                          size: 26,
                                                          color: AppColors.textWhiteDark3
                                                        ),
                                                      )
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
                                ),
                                AppSpaces.horizontal4,
                                SizedBox(
                                  width: bottomSectionItemHeight,
                                  height: bottomSectionItemHeight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedScale(
                                        scale: controller.message.value.isEmpty ? 1 : 0,
                                        duration: const Duration(milliseconds: 300),
                                        curve: const CustomEaseOutBackCurve(),
                                        child: Material(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {},
                                            splashColor: AppColors.textGreyDark2,
                                            highlightColor: Colors.transparent,
                                            splashFactory: InkRipple.splashFactory,
                                            child: const SizedBox(
                                              width: bottomSectionItemHeight - 4,
                                              height: bottomSectionItemHeight - 4,
                                              child: Center(
                                                child: Icon(
                                                  Icons.mic,
                                                  size: 24,
                                                  color: AppColors.textWhiteDark3,
                                                )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // if(!controller.messageSending.value)
                                      AnimatedScale(
                                        scale: controller.message.value.isEmpty ? 0 : 1,
                                        duration: const Duration(milliseconds: 375),
                                        curve: const CustomEaseOutBackCurve(),
                                        child: Material(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.circular(50),
                                          color: AppColors.themeColor,
                                          child: InkWell(
                                            onTap: controller.sendMessage,
                                            splashColor: Colors.black26,
                                            highlightColor: Colors.transparent,
                                            splashFactory: InkRipple.splashFactory,
                                            child: const SizedBox(
                                              width: bottomSectionItemHeight - 4,
                                              height: bottomSectionItemHeight - 4,
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 4),
                                                  child: Icon(
                                                    Icons.send_rounded,
                                                    size: 22,
                                                    color: AppColors.primaryTextColor,
                                                  ),
                                                )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // if(controller.messageSending.value)
                                      // Container(
                                      //   width: bottomSectionItemHeight,
                                      //   height: bottomSectionItemHeight,
                                      //   padding: const EdgeInsets.all(12),
                                      //   decoration: const BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     color: AppColors.themeColor
                                      //   ),
                                      //   child: const Center(
                                      //     child: CircularProgressIndicator(
                                      //       color: AppColors.textWhiteBase,
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    );
                  }
                );
              })
            ],
          ),
        );
      },
    );
  }
}

// Widget messageTile(BuildContext context, PrivateChatScreenController controller, PrivateMessage message, bool isContinue) {
//   final isSender = message.sender == FirebaseAuth.instance.currentUser!.uid;
//   const emptySpaceMinWidth = 36.0;
//   const messageBoxPaddingHorizontal = 8.0;
//   const messageBoxPaddingVertical = 4.0;
//   const messageSpacing = 4.0;
//   const statusSpacing = 2.0;
//   final isSent = message.isSent == null || message.isSent!;
//   final backgroundColor =  isSender ? const Color.fromARGB(255, 126, 49, 23) : AppColors.backgroundDark2;
//   // final backgroundColor =  isSender ? Color.fromARGB(255, 120, 43, 20) : AppColors.backgroundDark2;
//   // const contentColor = Color.fromARGB(255, 160, 162, 170);
//   final contentColor = isSender ? const Color.fromARGB(255, 180, 182, 190) : const Color.fromARGB(255, 140,  142, 150);
//   // final messageBoxMaxWidth = Get.width - emptySpaceMinWidth > 500 ? 500.0 :  Get.width - emptySpaceMinWidth;
//   // final messageMaxWidth = messageBoxMaxWidth - messageBoxPadding * 2 - messageBoxPadding * 2 - messageSpacing - statusSpacing;
//   final messageKey = GlobalObjectKey(message.id);
//   final renderBox = messageKey.currentContext!.findRenderObject() as RenderBox?;
//   var isMessageVisible = false;
//   if(renderBox != null) {
//     print("object");
//     var position = renderBox.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
//     print(position);
//     isMessageVisible = position.dy > 0 && position.dy < MediaQuery.of(context).size.height;
//   }
//   return GestureDetector(
//     onTap: () => controller.scrollToMessage(context, message.id),
//     child: Container(
//       width: Get.width,
//       padding: EdgeInsets.only(
//         left: isSender ? 0 : 8.0,
//         right: isSender ? 8.0 : 0,
//         top: 1.0,
//         bottom: isContinue ? 2.0 : 10.0
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           children: [
//             if(isSender)
//             Expanded(
//               child: Container(
//                 constraints: const BoxConstraints(
//                   minWidth: emptySpaceMinWidth,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: messageBoxPaddingHorizontal, vertical: messageBoxPaddingVertical),
//               constraints: BoxConstraints(
//                 maxWidth: Get.width - emptySpaceMinWidth
//               ),
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isMessageVisible ? Colors.blue : isSender ? Colors.black.withOpacity(.6) : Colors.black.withOpacity(.8),
//                     offset: const Offset(0, 1),
//                     blurRadius: 0,
//                     spreadRadius: 0
//                   )
//                 ]
//               ),
//               child: IntrinsicWidth(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
//                         child: textStyled(message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
//                       ),
//                     ),
//                     AppSpaces.customWidth(messageSpacing),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         textStyled(DateFormat.jm(AppServices.locale.languageCode).format(message.createdAt), 11, contentColor),
//                         if(isSender)
//                         Row(
//                           children: [
//                             AppSpaces.customWidth(statusSpacing),
//                             if(!isSent)
//                             Padding(padding: const EdgeInsets.all(1), child: Image.asset("assets/images/ic_icon-clock.png", width: 14, height: 14, color: contentColor),),
//                             if(isSent && message.readDetail.isRead)
//                             Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: contentColor),
//                             if(isSent && !message.readDetail.isRead)
//                             Image.asset("assets/images/ic_icon-doubletick-filled2.png", width: 16, height: 16, color: Colors.blue,),
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if(!isSender)
//             Expanded(
//               child: Container(
//                 constraints: const BoxConstraints(
//                   minWidth: emptySpaceMinWidth
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//     ),
//   );
// }

class MessageTile extends StatefulWidget {
  final BuildContext mainContext;
  final PrivateChatScreenController controller;
  final PrivateMessage message;
  final bool isContinue;
  const MessageTile({super.key, required this.mainContext, required this.controller, required this.message, required this.isContinue});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  // late final GlobalObjectKey messageKey;
  late final Widget child;
  Offset? size;
  final activePositionPoint = 80.0;
  var dragStartPosition = 0.0;
  var dragPosition = 0.0;

  onTap() {
    // final box = messageKey.currentContext?.findRenderObject() as RenderBox?;
    // final height = box?.size.height; // Height değerini al
    // final width = box?.size.width;
    // print("WIDTH: $width, HEIGHT: $height");
    widget.controller.selectMessage(widget.message);
    // widget.controller.deleteMessageFromUsers(widget.message.id, [FirebaseAuth.instance.currentUser!.uid]);
  }

  onLongPress() {
    widget.controller.selectMessage(widget.message);
  }

  onPanStart(DragStartDetails details) {
    print("PAN START: ${details.localPosition.dx}");
    dragStartPosition = details.localPosition.dx;
    setState(() {});
  }

  onPanUpdate(DragUpdateDetails details) {
    final position = details.localPosition.dx;
    // final isSender = widget.message.sender == FirebaseAuth.instance.currentUser!.uid;
    // print("UPDATE POSITION: $position");
    if(position < dragStartPosition) {
      dragPosition = 0;
    } else {
      final pos = position - dragStartPosition;
      dragPosition = pos;
      // dragPosition = pos > maxPosition ? maxPosition : pos;
    }
    // if(isSender) {
    //   if(position > dragStartPosition) {
    //     dragPosition = 0;
    //   } else {
    //     dragPosition = position - dragStartPosition;
    //   }
    // } else {
    //   if(position < dragStartPosition) {
    //     dragPosition = 0;
    //   } else {
    //     dragPosition = position - dragStartPosition;
    //   }
    // }
    setState(() {});
  }

  onPanEnd(DragEndDetails details) {
    if(dragPosition >= activePositionPoint) {
      widget.controller.selectReplySelected(widget.message);
    } 
    dragPosition = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final isSelected = widget.controller.selectedMessage.value == widget.message.id;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final message = widget.message;
    final isSender = message.sender == userId;
    const paddingHorizontal = 10.0;
    const emptySpaceMinWidth = 36.0;
    const messageBoxPaddingHorizontal = 8.0;
    const messageBoxPaddingVertical = 4.0;
    const messageSpacing = 4.0;
    const statusSpacing = 4.0;
    final isSent = widget.message.isSent == null || widget.message.isSent!;
    final backgroundColor =  isSender ? const Color.fromARGB(255, 126, 49, 23) : AppColors.backgroundDark4;
    final contentColor = isSender ? const Color.fromARGB(255, 180, 182, 190) : const Color.fromARGB(255, 140,  142, 150);
    final key = GlobalObjectKey(widget.message.id);
    final overflowBoxWidth = Get.width * 3;
    const replyIconSize = 36.0;
    final viewers = message.viewers;
    final canView = viewers.contains(userId);
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isContinue ? 0 : 8.0),
      child: TapDownOpacityAnimation(
        opacity: .6,
        onTap: onTap,
        onLongPress: onLongPress,
        onHorizontalDragEnd: onPanEnd,
        onHorizontalDragStart: onPanStart,
        onHorizontalDragUpdate: onPanUpdate,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dateSpan = TextSpan(text: DateFormat.jm(AppServices.locale.languageCode).format(widget.message.createdAt), style: const TextStyle(fontSize: 10));
            final dateTp = TextPainter(text: dateSpan, textDirection: ui.TextDirection.ltr);
            dateTp.layout(maxWidth: Get.width);
            final span = TextSpan(text: canView ? message.text : "Bu mesaj silindi", style: const TextStyle(fontSize: 14));
            final tp = TextPainter(text: span, textDirection: ui.TextDirection.ltr, maxLines: 1000);
            tp.layout(maxWidth: Get.width - paddingHorizontal - emptySpaceMinWidth - messageBoxPaddingHorizontal * 2 - 8 - dateTp.width - statusSpacing - 16 - messageSpacing);
            final height = tp.height + 16 + (widget.isContinue ? 3 : 6);
            return Container(
              key: key,
              height: height,
              width: Get.width,
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Opacity(
                  //   opacity: 0,
                  //   child: IntrinsicHeight(
                  //     child: Padding(
                  //       padding: EdgeInsets.only(
                  //         left: isSender ? 0 : 10.0,
                  //         right: isSender ? 10.0 : 0,
                  //         top: 2.0,
                  //         bottom: widget.isContinue ? 1.0 : 4.0,
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           if(isSender)
                  //           Expanded(
                  //             child: Container(
                  //               color: Colors.red,
                  //               constraints: const BoxConstraints(
                  //                 minWidth: emptySpaceMinWidth,
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.symmetric(horizontal: messageBoxPaddingHorizontal, vertical: messageBoxPaddingVertical),
                  //             constraints: BoxConstraints(
                  //               maxWidth: Get.width - emptySpaceMinWidth - 20,
                  //             ),
                  //             decoration: BoxDecoration(
                  //               color: backgroundColor,
                  //               borderRadius: BorderRadius.circular(12),
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: isSender ? Colors.black.withOpacity(.4) : Colors.black.withOpacity(.6),
                  //                   offset: const Offset(0, 1),
                  //                   blurRadius: 0,
                  //                   spreadRadius: 0
                  //                 )
                  //               ]
                  //             ),
                  //             child: Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               crossAxisAlignment: CrossAxisAlignment.end,
                  //               children: [
                  //                 Flexible(
                  //                   child: Container(
                  //                     padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
                  //                     child: textStyled(widget.message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
                  //                   ),
                  //                 ),
                  //                 AppSpaces.customWidth(messageSpacing),
                  //                 Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     textStyled(DateFormat.jm(AppServices.locale.languageCode).format(widget.message.createdAt), 11, contentColor),
                  //                     if(isSender)
                  //                     Row(
                  //                       children: [
                  //                         AppSpaces.customWidth(statusSpacing),
                  //                         if(!isSent)
                  //                         Padding(padding: const EdgeInsets.all(1), child: Image.asset("assets/images/ic_icon-clock.png", width: 14, height: 14, color: contentColor),),
                  //                         if(isSent && widget.message.readDetail.isRead)
                  //                         Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: contentColor),
                  //                         if(isSent && !widget.message.readDetail.isRead)
                  //                         Image.asset("assets/images/ic_icon-doubletick-filled2.png", width: 16, height: 16, color: Colors.blue,),
                  //                       ],
                  //                     )
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           if(!isSender)
                  //           Expanded(
                  //             child: Container(
                  //               constraints: const BoxConstraints(
                  //                 minWidth: emptySpaceMinWidth
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned.fill(
                    child: OverflowBox(
                      maxWidth: overflowBoxWidth,
                      maxHeight: height + 160,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 80,
                            left: (overflowBoxWidth - Get.width)/2 + dragPosition,
                            child: Container(
                              width: Get.width,
                              height: height,
                              padding: EdgeInsets.only(
                                left: isSender ? 0 : paddingHorizontal,
                                right: isSender ? paddingHorizontal : 0,
                                top: 2.0,
                                bottom: widget.isContinue ? 1.0 : 4.0,
                              ),
                              child: Row(
                                children: [
                                  if(isSender)
                                  Expanded(
                                    child: Container(
                                      // color: Colors.red,
                                      // height: height,
                                      constraints: const BoxConstraints(
                                        minWidth: emptySpaceMinWidth,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: messageBoxPaddingHorizontal, vertical: messageBoxPaddingVertical),
                                    constraints: BoxConstraints(
                                      maxWidth: Get.width - emptySpaceMinWidth - 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSender ? Colors.black.withOpacity(.4) : Colors.black.withOpacity(.6),
                                          offset: const Offset(0, 1),
                                          blurRadius: 0,
                                          spreadRadius: 0
                                        )
                                      ]
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if(!canView)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 2),
                                              child: Icon(
                                                Icons.block_flipped,
                                                size: 22,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            AppSpaces.horizontal4,
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
                                              child: Text("Bu mesaj silindi", style: TextStyle(fontSize: 14, color: isSender ? AppColors.textWhiteDark3: AppColors.textGreyLight3)),
                                            )
                                            // Flexible(
                                            //   child: Container(
                                            //     padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
                                            //     child: Text("Bu mesaj silindi", style: TextStyle(fontSize: 14, color: isSender ? AppColors.textWhiteBase: AppColors.textWhiteDark3), softWrap: true,)
                                            //     // textStyled(widget.message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        if(canView)
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
                                            child: Text(widget.message.text!, style: TextStyle(fontSize: 14, color: isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase), softWrap: true,)
                                            // textStyled(widget.message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
                                          ),
                                        ),
                                        AppSpaces.customWidth(messageSpacing),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            textStyled(DateFormat.jm(AppServices.locale.languageCode).format(widget.message.createdAt), 10, contentColor),
                                            if(isSender)
                                            Row(
                                              children: [
                                                AppSpaces.customWidth(statusSpacing),
                                                if(!isSent)
                                                Padding(padding: const EdgeInsets.all(1), child: Image.asset("assets/images/ic_icon-clock.png", width: 14, height: 14, color: contentColor),),
                                                if(isSent && widget.message.readDetail.isRead)
                                                Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: contentColor),
                                                if(isSent && !widget.message.readDetail.isRead)
                                                Image.asset("assets/images/ic_icon-doubletick-filled2.png", width: 16, height: 16, color: Colors.blue,),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if(!isSender)
                                  Expanded(
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: emptySpaceMinWidth
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (height - replyIconSize)/2 + 80,
                            left: (overflowBoxWidth - Get.width)/2 - replyIconSize + (dragPosition > activePositionPoint ? activePositionPoint : dragPosition),
                            child: Opacity(
                              opacity: dragPosition/activePositionPoint >= 1 ? 1 : dragPosition/activePositionPoint,
                              child: Container(
                                width: replyIconSize,
                                height: replyIconSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundDark4,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.reply,
                                    size: 24,
                                    color: AppColors.textWhiteBase,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              )
            );
          },
        )
      ),
    );
  }
}

// class MessageTile extends StatefulWidget {
//   final BuildContext mainContext;
//   final PrivateChatScreenController controller;
//   final PrivateMessage message;
//   final bool isContinue;
//   const MessageTile({super.key, required this.mainContext, required this.controller, required this.message, required this.isContinue});

//   @override
//   State<MessageTile> createState() => _MessageTileState();
// }

// class _MessageTileState extends State<MessageTile> {

//   var dragStartPosition = 0.0;
//   var dragPosition = 0.0;

//   onTap() {

//   }

//   onLongPress() {

//   }

//   onPanStart(DragStartDetails details) {
//     print("PAN START: ${details.localPosition.dx}");
//     dragStartPosition = details.localPosition.dx;
//     setState(() {});
//   }

//   onPanUpdate(DragUpdateDetails details) {
//     final position = details.localPosition.dx;
//     print("UPDATE POSITION: $position");
//     if(position < dragStartPosition) {
//       dragPosition = dragStartPosition;
//     } else {
//       dragPosition = position - dragStartPosition;
//     }
//     setState(() {});
//   }

//   onPanEnd(DragEndDetails details) {
//     print(details.velocity);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSender = widget.message.sender == FirebaseAuth.instance.currentUser!.uid;
//     const emptySpaceMinWidth = 36.0;
//     const messageBoxPaddingHorizontal = 8.0;
//     const messageBoxPaddingVertical = 4.0;
//     const messageSpacing = 4.0;
//     const statusSpacing = 2.0;
//     final isSent = widget.message.isSent == null || widget.message.isSent!;
//     final backgroundColor =  isSender ? const Color.fromARGB(255, 126, 49, 23) : AppColors.backgroundDark4;
//     final contentColor = isSender ? const Color.fromARGB(255, 180, 182, 190) : const Color.fromARGB(255, 140,  142, 150);
//     // final messageBoxMaxWidth = Get.width - emptySpaceMinWidth > 500 ? 500.0 :  Get.width - emptySpaceMinWidth;
//     // final messageMaxWidth = messageBoxMaxWidth - messageBoxPadding * 2 - messageBoxPadding * 2 - messageSpacing - statusSpacing;
//     final messageKey = GlobalObjectKey(widget.message.id);
//     final renderBox = messageKey.currentContext?.findRenderObject() as RenderBox?;
//     var isMessageVisible = false;
//     if(renderBox != null) {
//       var position = renderBox.localToGlobal(Offset.zero, ancestor: widget.mainContext.findRenderObject());
//       print("Message position: $position");
//       isMessageVisible = position.dy > 0 && position.dy < MediaQuery.of(widget.mainContext).size.height;
//     }
//     return Padding(
//       padding: EdgeInsets.only(bottom: widget.isContinue ? 0 : 8.0),
//       child: TapDownOpacityAnimation(
//         opacity: .6,
//         onTap: onTap,
//         onLongPress: onLongPress,
//         onPanEnd: onPanEnd,
//         onPanStart: onPanStart,
//         onPanUpdate: onPanUpdate,
//         child: Container(
//           width: Get.width,
//           color: Colors.transparent,
//           child: IntrinsicHeight(
//             child: Stack(
//               children: [
//                 Container(
//                   color: Colors.transparent,
//                   padding: EdgeInsets.only(
//                     left: isSender ? 0 : 8.0,
//                     right: isSender ? 8.0 : 0,
//                     top: 2.0,
//                     bottom: widget.isContinue ? 1.0 : 4.0,
//                   ),
//                   child: Row(
//                     children: [
//                       if(isSender)
//                       Expanded(
//                         child: Container(
//                           constraints: const BoxConstraints(
//                             minWidth: emptySpaceMinWidth,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: messageBoxPaddingHorizontal, vertical: messageBoxPaddingVertical),
//                         constraints: BoxConstraints(
//                           maxWidth: Get.width - emptySpaceMinWidth
//                         ),
//                         decoration: BoxDecoration(
//                           color: backgroundColor,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: isSender ? Colors.black.withOpacity(.4) : Colors.black.withOpacity(.6),
//                               offset: const Offset(0, 1),
//                               blurRadius: 0,
//                               spreadRadius: 0
//                             )
//                           ]
//                         ),
//                         child: IntrinsicWidth(
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
//                                   child: textStyled(widget.message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
//                                 ),
//                               ),
//                               AppSpaces.customWidth(messageSpacing),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   textStyled(DateFormat.jm(AppServices.locale.languageCode).format(widget.message.createdAt), 11, contentColor),
//                                   if(isSender)
//                                   Row(
//                                     children: [
//                                       AppSpaces.customWidth(statusSpacing),
//                                       if(!isSent)
//                                       Padding(padding: const EdgeInsets.all(1), child: Image.asset("assets/images/ic_icon-clock.png", width: 14, height: 14, color: contentColor),),
//                                       if(isSent && widget.message.readDetail.isRead)
//                                       Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: contentColor),
//                                       if(isSent && !widget.message.readDetail.isRead)
//                                       Image.asset("assets/images/ic_icon-doubletick-filled2.png", width: 16, height: 16, color: Colors.blue,),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if(!isSender)
//                       Expanded(
//                         child: Container(
//                           constraints: const BoxConstraints(
//                             minWidth: emptySpaceMinWidth
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//               ],
//             ),
//           )
//         ),
//       ),
//     );
//   }
// }

  //   child: TapDownOpacityAnimation(
      //   onTap: () {},
      //   child: SizedBox(
      //     width: Get.width,
      //     child: IntrinsicHeight(
      //       child: Stack(
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(
      //               left: isSender ? 0 : 8.0,
      //               right: isSender ? 8.0 : 0,
      //               top: 2.0,
      //               bottom: isContinue ? 1.0 : 4.0,
      //             ),
      //             child: Row(
      //               children: [
      //                 if(isSender)
      //                 Expanded(
      //                   child: Container(
      //                     constraints: const BoxConstraints(
      //                       minWidth: emptySpaceMinWidth,
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //                   padding: const EdgeInsets.symmetric(horizontal: messageBoxPaddingHorizontal, vertical: messageBoxPaddingVertical),
      //                   constraints: BoxConstraints(
      //                     maxWidth: Get.width - emptySpaceMinWidth
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: backgroundColor,
      //                     borderRadius: BorderRadius.circular(12),
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: isSender ? Colors.black.withOpacity(.4) : Colors.black.withOpacity(.6),
      //                         offset: const Offset(0, 1),
      //                         blurRadius: 0,
      //                         spreadRadius: 0
      //                       )
      //                     ]
      //                   ),
      //                   child: IntrinsicWidth(
      //                     child: Row(
      //                       mainAxisSize: MainAxisSize.min,
      //                       crossAxisAlignment: CrossAxisAlignment.end,
      //                       children: [
      //                         Expanded(
      //                           child: Container(
      //                             padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
      //                             child: textStyled(message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
      //                           ),
      //                         ),
      //                         AppSpaces.customWidth(messageSpacing),
      //                         Row(
      //                           mainAxisSize: MainAxisSize.min,
      //                           children: [
      //                             textStyled(DateFormat.jm(AppServices.locale.languageCode).format(message.createdAt), 11, contentColor),
      //                             if(isSender)
      //                             Row(
      //                               children: [
      //                                 AppSpaces.customWidth(statusSpacing),
      //                                 if(!isSent)
      //                                 Padding(padding: const EdgeInsets.all(1), child: Image.asset("assets/images/ic_icon-clock.png", width: 14, height: 14, color: contentColor),),
      //                                 if(isSent && message.readDetail.isRead)
      //                                 Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: contentColor),
      //                                 if(isSent && !message.readDetail.isRead)
      //                                 Image.asset("assets/images/ic_icon-doubletick-filled2.png", width: 16, height: 16, color: Colors.blue,),
      //                               ],
      //                             )
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 if(!isSender)
      //                 Expanded(
      //                   child: Container(
      //                     constraints: const BoxConstraints(
      //                       minWidth: emptySpaceMinWidth
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           // Material(
      //           //   color: Colors.transparent,
      //           //   child: InkWell(
      //           //     onTap: () => controller.scrollToMessage(context, message.id),
      //           //     highlightColor: Colors.transparent,
      //           //     splashColor: Colors.black.withOpacity(.2),
      //           //     splashFactory: InkRipple.splashFactory,
      //           //   ),
      //           // ),
      //         ],
      //       )
      //     )
      //   ),
      // )
      
      // Material(
      //   color: Colors.transparent,
      //   child: InkWell(
      //     onTap: () => controller.scrollToMessage(context, message.id),
      //     highlightColor: Colors.transparent,
      //     splashColor: Colors.black.withOpacity(.2),
      //     splashFactory: InkRipple.splashFactory,
      //     child: Container(
      //       width: Get.width,
      //       padding: EdgeInsets.only(
      //         left: isSender ? 0 : 8.0,
      //         right: isSender ? 8.0 : 0,
      //         top: 2.0,
      //         bottom: isContinue ? 1.0 : 4.0,
      //       ),
      //       child: IntrinsicHeight(
      //         child: Row(
      //           children: [
      //             if(isSender)
      //             Expanded(
      //               child: Container(
      //                 constraints: const BoxConstraints(
      //                   minWidth: emptySpaceMinWidth,
      //                 ),
      //               ),
      //             ),
      //             Container(
      //               padding: const EdgeInsets.symmetric(horizontal: messageBoxPaddingHorizontal, vertical: messageBoxPaddingVertical),
      //               constraints: BoxConstraints(
      //                 maxWidth: Get.width - emptySpaceMinWidth
      //               ),
      //               decoration: BoxDecoration(
      //                 color: backgroundColor,
      //                 borderRadius: BorderRadius.circular(12),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: isSender ? Colors.black.withOpacity(.4) : Colors.black.withOpacity(.6),
      //                     offset: const Offset(0, 1),
      //                     blurRadius: 0,
      //                     spreadRadius: 0
      //                   )
      //                 ]
      //               ),
      //               child: IntrinsicWidth(
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   children: [
      //                     Expanded(
      //                       child: Container(
      //                         padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
      //                         child: textStyled(message.text!, 15, isSender ? AppColors.textWhiteLight3: AppColors.textWhiteBase, softWrap: true)
      //                       ),
      //                     ),
      //                     AppSpaces.customWidth(messageSpacing),
      //                     Row(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         textStyled(DateFormat.jm(AppServices.locale.languageCode).format(message.createdAt), 11, contentColor),
      //                         if(isSender)
      //                         Row(
      //                           children: [
      //                             AppSpaces.customWidth(statusSpacing),
      //                             if(!isSent)
      //                             Padding(padding: const EdgeInsets.all(1), child: Image.asset("assets/images/ic_icon-clock.png", width: 14, height: 14, color: contentColor),),
      //                             if(isSent && message.readDetail.isRead)
      //                             Image.asset("assets/images/ic_icon-tick-filled.png", width: 16, height: 16, color: contentColor),
      //                             if(isSent && !message.readDetail.isRead)
      //                             Image.asset("assets/images/ic_icon-doubletick-filled2.png", width: 16, height: 16, color: Colors.blue,),
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             if(!isSender)
      //             Expanded(
      //               child: Container(
      //                 constraints: const BoxConstraints(
      //                   minWidth: emptySpaceMinWidth
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       )
      //     ),
      //   ),
      // ),

// Widget _bottomSection(PrivateChatScreenController controller, double bottomSectionHeight, double safePaddingBottom) { 
//   return Container(
//     width: Get.width,
//     constraints: BoxConstraints(
//       minHeight: bottomSectionHeight,
//     ),
//     padding: EdgeInsets.fromLTRB(AppConstants.mHorizontalPadding, 12.0, AppConstants.mHorizontalPadding, safePaddingBottom + 12.0),
//     decoration: const BoxDecoration(
//       color: AppColors.scaffoldBackgroundColor,
//       border: Border(
//         top: BorderSide(
//           color: AppColors.borderColor,
//           width: 1
//         ),
//       ),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.camera_alt,
//           size: 24,
//           color: AppColors.greyTextColor,
//         ),
//         AppSpaces.horizontal16,
//         Expanded(
//           child: TextField(
//             maxLines: 1,
//             keyboardType: TextInputType.multiline,
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               filled: true,
//               fillColor: Colors.red
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

PreferredSize _appBar(PrivateChatScreenController controller, double appBarHeight, double statusBarHeight) {
  final friend = controller.friend.value;
  const contentHeight = 36.0;
  // final paddingVertical = (appBarHeight - statusBarHeight - contentHeight)/2;
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight),
    child: Container(
      height: appBarHeight,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, statusBarHeight, 8, 0),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.barBorderColor,
            width: 1,
          )
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () => Get.back(),
              highlightColor: Colors.transparent,
              splashFactory: InkRipple.splashFactory,
              splashColor: AppColors.scaffoldSplashColor,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    // color: AppColors.themeColor,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          AppSpaces.horizontal4,
          if(friend == null)
          Expanded(
            child: Shimmer.fromColors(
              baseColor: AppColors.appBarColor.changeColor(all: 4),
              highlightColor: AppColors.appBarColor.changeColor(all: 10),
              child: Row(
                children: [
                  Container(
                    width: contentHeight,
                    height: contentHeight,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                  ),
                  AppSpaces.horizontal10,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.red,
                          ),
                        ),
                        AppSpaces.vertical2,
                        Container(
                          width: 120,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if(friend != null)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: contentHeight,
                    child: Row(
                      children: [
                        if(friend.useAvatar || friend.profilePhotos == null || friend.profilePhotos!.isEmpty)
                        ClipOval(
                          child: Image.asset("assets/images/avatars/ic_icon-avatar${friend.avatar}.png", width: contentHeight, height: contentHeight, fit: BoxFit.cover,)
                        ),
                        if(!friend.useAvatar && friend.profilePhotos != null && friend.profilePhotos!.isNotEmpty)
                        Container(
                          width: contentHeight,
                          height: contentHeight,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.backgroundDark4
                          ),
                          // child: Image.network(friend.profilePhotos!.first.normal, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return Padding(
                          //     padding: const EdgeInsets.all(8),
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
                        AppSpaces.horizontal10,
                        SizedBox(
                          height: contentHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textStyled(controller.friend.value!.username, 18, AppColors.primaryTextColor, fontWeight: FontWeight.w500, lineHeight: 1),
                              AppSpaces.vertical2,
                              Obx(() {
                                final privateChatsController = Get.find<PrivateChatsScreenController>();
                                final chat = controller.chat.value;
                                final now = privateChatsController.currentDate.value;
                                final isWriting = chat != null && chat.writers.contains(friend.id);
                                final isOnline = friend.isOnline;
                                var statusText = "";
                                if(isWriting) {
                                  statusText = "yazıyor...";
                                } else {
                                  if(isOnline) {
                                    statusText = "çevrimiçi";
                                  } else {
                                    final lastSeenTime = controller.getLastSeenTime(now, friend.lastLoggedOutAt!);
                                    statusText = "son görülme $lastSeenTime";
                                  }
                                }
                                return textStyled(statusText, 12, const Color.fromRGBO(160, 162, 170, 1), lineHeight: 1);
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AppSpaces.horizontal10,
                Material(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: () => Get.back(),
                    highlightColor: Colors.transparent,
                    splashFactory: InkRipple.splashFactory,
                    splashColor: AppColors.scaffoldSplashColor,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(
                          Icons.more_vert_rounded,
                          // color: AppColors.themeColor,
                          color: Color.fromRGBO(160, 162, 170, 1),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}