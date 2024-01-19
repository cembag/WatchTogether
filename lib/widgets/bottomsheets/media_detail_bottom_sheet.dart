import 'dart:ui';
import 'package:ecinema_watch_together/dal/auth_dal.dart';
import 'package:ecinema_watch_together/services/app_services.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/custom_curves.dart';
import 'package:ecinema_watch_together/widgets/modals/snackbar_modal.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

const _kPadding = 16.0;
const _kDragLeeway = 80.0;
const _kInitialHeight = 500.0;

class MediaDetailBottomSheet extends StatefulWidget {
  final MediaDetail mediaDetail;
  const MediaDetailBottomSheet({super.key, required this.mediaDetail});

  @override
  State<MediaDetailBottomSheet> createState() => _MediaDetailBottomSheetState();
}

class _MediaDetailBottomSheetState extends State<MediaDetailBottomSheet> {

  late final Offset imageOffset;
  double detailHeight = _kInitialHeight;
  final key = GlobalKey();

  var position = 0.0;
  var startPosition = 0.0;
  var screenShootEnabled = true;
  final detailsMaxHeight = Get.height - MediaQueryData.fromWindow(window).padding.top;

  @override
  void initState() {
    _calcImageSize();
    _setDetailHeight();
    super.initState();
  }

  _calcImageSize() {
    final mediaDetail = widget.mediaDetail;
    final mediaRatio = mediaDetail.width/mediaDetail.height;
    final limitX = Get.width - _kPadding * 2;
    const limitY = 320.0;

    imageOffset = AppServices.instance.limitImageSize(Offset(limitX, limitY), mediaRatio);
    setState(() {});
  }

  _setDetailHeight() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if(box == null) return;
      detailHeight = box.size.height;
      setState(() {});
    });
  }

  void onVerticalDragStart(DragStartDetails details) {
    startPosition = details.globalPosition.dy;
    setState(() {});
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    position = startPosition - details.globalPosition.dy;
    setState(() {});
  }

  void onVerticalDragEnd(DragEndDetails details, double bottom) {
    final visibleHeight = detailHeight + bottom;
    if(visibleHeight - _kInitialHeight >= 0) {
      position = detailHeight - _kInitialHeight;
    } else if(_kInitialHeight - visibleHeight >= _kDragLeeway) {
      position = -detailHeight;
      Navigator.of(context).pop();
      // Future.delayed(const Duration(milliseconds: 200), () => Navigator.of(context).pop());
    } else {
      position = 0;
    }
    setState(() {});
  }

  double _calcBottomPosition() {
    final initialPos = -detailHeight + _kInitialHeight;
    final pos = initialPos + position;
    final bottomPosition = pos > 0.0 ? 0.0 : pos <= -detailHeight ? -detailHeight : pos;
    return bottomPosition;
  }

  @override 
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final mediaDetail = widget.mediaDetail;
    final file = mediaDetail.file;
    final fileName = mediaDetail.fileName;
    final safePaddingBottom = sizes.safePaddingBottom;
    // final bottom = _calcBottomPosition(safePaddingBottom);
    final bottom = _calcBottomPosition();
    final opacity = bottom >= 0 ? 1.0 : (detailHeight+bottom)/detailHeight;
    print(opacity);
    // print(opacity);
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.black.withOpacity(opacity * .4),
      child: Stack(
        children: [
          AnimatedPositioned(
            left: 0,
            bottom: bottom,
            curve: const CustomEaseOutBackCurve(),
            duration: const Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: () => print(detailHeight),
              onVerticalDragEnd: (details) => onVerticalDragEnd(details, bottom),
              onVerticalDragStart: onVerticalDragStart,
              onVerticalDragUpdate: onVerticalDragUpdate,
              child: Container(
                key: key,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)
                  ),
                ),
                child: Column(
                  children: [
                    // GestureDetector(
                    //   onTap: () => print(detailHeight),
                    //   onVerticalDragEnd: (details) => onVerticalDragEnd(details, globalPosition),
                    //   onVerticalDragStart: onVerticalDragStart,
                    //   onVerticalDragUpdate: onVerticalDragUpdate,
                    //   child: SizedBox(
                    //     width: Get.width,
                    //     height: 60,
                    //     child: Column(
                    //       children: [
                            // const SizedBox(height: 5),
                            // Center(
                            //   child: Container(
                            //     width: 50,
                            //     height: 5,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(20),
                            //       color: AppColors.blackGrey
                            //     ),
                            //   ),
                            // ),
                    //         Container(
                    //           width: Get.width,
                    //           height: 50,
                    //           padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    //           decoration: BoxDecoration(
                    //             border: Border(
                    //               bottom: BorderSide(
                    //                 color: AppColors.borderColor,
                    //                 width: 1
                    //               )
                    //             )
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               textStyled("Medya bilgisi", 16, AppColors.whiteGrey2, fontWeight: FontWeight.w700),
                    //               Material(
                    //                 color: Colors.transparent,
                    //                 clipBehavior: Clip.hardEdge,
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(50),
                    //                 ),
                    //                 child: InkWell(
                    //                   highlightColor: Colors.transparent,
                    //                   splashFactory: InkRipple.splashFactory,
                    //                   splashColor: Colors.black26,
                    //                   onTap: () => Navigator.of(context).pop(),
                    //                   child: const SizedBox(
                    //                     width: 42,
                    //                     height: 42,
                    //                     child: Icon(
                    //                       Icons.close,
                    //                       color: AppColors.greyTextColor,
                    //                       size: 24,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 6),
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.blackGrey
                        ),
                      ),
                    ),
                    Padding(
                      // physics: bottomPosition < 0 ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(_kPadding, _kPadding, _kPadding, _kPadding + safePaddingBottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: imageOffset.dx,
                              height: imageOffset.dy,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Image.file(file),
                            ),
                          ),
                          AppSpaces.vertical16,
                          Text(fileName!, style: const TextStyle(fontSize: 13, color: Color.fromRGBO(180, 182, 192, 1), fontWeight: FontWeight.w500,), softWrap: true, maxLines: 3,),
                          AppSpaces.vertical6,
                          Container(
                            height: 92,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color.fromRGBO(20, 20, 20, 1),
                            ),
                            child: Column(
                              children: [
                                Material(
                                  color: const Color.fromRGBO(20, 20, 20, 1),
                                  child: InkWell(
                                    onTap: () {},
                                    highlightColor: Colors.transparent,
                                    splashColor: Color.fromRGBO(42, 42, 46, opacity),
                                    splashFactory: InkRipple.splashFactory,
                                    child: Container(
                                      height: 46,
                                      width: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(16, 0, 14, 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: textStyled("Medya detaylarına gözat", 14, AppColors.primaryTextColor, fontWeight: FontWeight.w500),
                                          ),
                                          const Icon(
                                            Icons.arrow_right_alt_rounded,
                                            size: 26,
                                            color: AppColors.textWhiteBase,
                                          )
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                                Material(
                                  color: const Color.fromRGBO(20, 20, 20, 1),
                                  child: InkWell(
                                    onTap: () {
                                      screenShootEnabled = !screenShootEnabled;
                                      setState(() {});
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Color.fromRGBO(42, 42, 46, opacity),
                                    splashFactory: InkRipple.splashFactory,
                                    child: Container(
                                      height: 46,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: textStyled("Ekran görüntüsü almayı engelle", 14, AppColors.primaryTextColor, fontWeight: FontWeight.w500)
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Checkbox(
                                              side: const BorderSide(
                                                color: Color.fromRGBO(220, 220, 220, 1),
                                                width: 2
                                              ),
                                              activeColor: AppColors.themeColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              value: screenShootEnabled,
                                              onChanged: (val) {
                                                screenShootEnabled = !screenShootEnabled;
                                                setState(() {});
                                              }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpaces.vertical16,
                          Material(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(4),
                            color: const Color.fromRGBO(20, 20, 20, 1),
                            child: InkWell(
                              onTap: () {},
                              highlightColor: Colors.transparent,
                              splashColor: Color.fromRGBO(42, 42, 46, opacity),
                              splashFactory: InkRipple.splashFactory,
                              child: Container(
                                height: 46,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: textStyled("Medyayı kaldır", 14, const Color.fromARGB(255, 252, 98, 98), fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          AppSpaces.customHeight(safePaddingBottom)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_showDeleteAccountModal(BuildContext context) {
  showSnackbarModal(
    context: context,
    title: "Hesap sil",
    message: "Şu anda bu özelliğimiz kullanılamamaktadır, hesabınızı silmek istiyorsanız bizimle iletişime geçebilirsiniz",
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mail,
                size: 14,
                color: AppColors.whiteGrey2,
              ),
              AppSpaces.horizontal6,
              textStyled("howtocenteradiv@gmail.com", 14, const Color.fromRGBO(160, 160, 160, 1), fontWeight: FontWeight.w500)
            ],
          ),
        ),
        AppSpaces.vertical4,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone,
                size: 14,
                color: AppColors.secondaryTextColor,
              ),
              AppSpaces.horizontal6,
              textStyled("905378688105", 14, const Color.fromRGBO(160, 160, 160, 1), fontWeight: FontWeight.w500)
            ],
          ),
        )
      ],
    )
  );
}

_showAreYouSureToQuitModal(BuildContext context) {
  showSnackbarModal(
    context: context, 
    title: "Çıkış yap",
    message: "Çıkış yapmak istediğinize emin misiniz?",
    actions: [
      SnackbarAction(
        onTap: AuthDal.instance.signOut,
        text: "Eminim, çıkış yap",
        backgroundColor: Colors.red,
      ),
      SnackbarAction(
        onTap: () => Navigator.of(context).pop(),
        text: "İptal",
        backgroundColor: AppColors.blackGrey
      ),
    ]
  );
}

void showMediaDetailBottomSheet(BuildContext context, MediaDetail mediaDetail) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    // showDragHandle: true,
    isScrollControlled: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(.2),
    backgroundColor: Colors.transparent,
    builder: (context) => MediaDetailBottomSheet(
      mediaDetail: mediaDetail,
    )
  );
}

