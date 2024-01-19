import 'package:ecinema_watch_together/views/media_gallery/media_viewer/media_viewer_screen_controller.dart';
import 'package:ecinema_watch_together/views/media_gallery/media_viewer/photo_provider/photo_provider.dart';
import 'package:ecinema_watch_together/views/media_gallery/media_viewer/video_provider/video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecinema_watch_together/utils/app/app_colors.dart';
import 'package:ecinema_watch_together/utils/app/app_sizes.dart';
import 'package:ecinema_watch_together/utils/app/app_spaces.dart';
import 'package:ecinema_watch_together/widgets/text_styled.dart';
import 'package:photo_gallery/photo_gallery.dart';

class MediaViewerScreen extends StatelessWidget {
  final List<Medium> mediums;
  final List<String>? receivers;
  const MediaViewerScreen({super.key, required this.mediums, this.receivers});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final statusBarHeight = sizes.statusBarHeight;
    final safePaddingBottom = sizes.safePaddingBottom;
    final topSectionHeight = 56 + statusBarHeight;
    final bottomSectionHeight = 62 + safePaddingBottom;
    // final rec = ["Cem", "Executioner", "Admin", "Levo", "Kral", "Ceren20"];
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
        return true;
      },
      child: GetBuilder(
        init: MediaViewerScreenController(mediums: mediums, receivers: receivers),
        builder: (controller) {
          final mediumDetails = controller.mediumDetails;
          final selectedMedium = controller.currentPage.value > mediumDetails.length - 1 ? mediumDetails.last : mediumDetails[controller.currentPage.value];
          final selectedMediumType = selectedMedium.mediumType;
          return  Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: mediumDetails.length,
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (context, index) {
                        final medium = mediums[index];
                        if(medium.mediumType == MediumType.image) {
                          return PhotoProviderApp(medium: medium);
                        } else {
                          // return VideoProvider(medium: medium, receivers: receivers, topSectionHeight: topSectionHeight);
                          return VideoProvider(medium: medium, topSectionHeight: topSectionHeight);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: Get.width,
                      height: topSectionHeight,
                      padding: EdgeInsets.fromLTRB(16, statusBarHeight, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black.withOpacity(.6),
                            child: InkWell(
                              onTap: Get.back,
                              highlightColor: Colors.transparent,
                              splashFactory: InkRipple.splashFactory,
                              splashColor: Colors.black.withOpacity(.8),
                              child: const SizedBox(
                                width: 38,
                                height: 38,
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppSpaces.expandedSpace,
                          if(selectedMediumType == MediumType.image)
                          Material(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black.withOpacity(.6),
                            child: InkWell(
                              onTap: Get.back,
                              highlightColor: Colors.transparent,
                              splashFactory: InkRipple.splashFactory,
                              splashColor: Colors.black.withOpacity(.8),
                              child: const SizedBox(
                                width: 38,
                                height: 38,
                                child: Center(
                                  child: Icon(
                                    Icons.crop_rotate_rounded,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(mediums.length > 1)
                  Positioned(
                    bottom: 80 + safePaddingBottom,
                    left: 0,
                    child: SizedBox(
                      width: Get.width,
                      height: 46,
                      child: Center(
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: mediumDetails.length,
                              separatorBuilder: (context, index) => AppSpaces.horizontal2,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final medium = mediumDetails[index];
                                final isPhoto = medium.mediumType == MediumType.image;
                                final isSelected = controller.currentPage.value == index;
                                return SizedBox(
                                  width: 46,
                                  height: 46,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Center(
                                          child: Image.asset("assets/images/ic_ecinema-animation-logo.png", width: 24, height: 24, color: AppColors.scaffoldBackgroundColor,)
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: GestureDetector(
                                          onTap: () => controller.changePage(index),
                                          child: isPhoto ? Image(
                                            fit: BoxFit.cover,
                                            image: PhotoProvider(mediumId: medium.id),
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColors.themeColor.withOpacity(.5),
                                                  backgroundColor: AppColors.cardColor,
                                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! : null,
                                                ),
                                              );
                                            },
                                          ) : Image.memory(medium.thumbnail!, fit: BoxFit.cover,)
                                        )
                                      ),
                                      if(isSelected)
                                      Positioned(
                                        child: Container(
                                          width: 46,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.themeColor,
                                              width: 1
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () => controller.deleteMedium(index),
                                            child: AnimatedOpacity(
                                              opacity: controller.canDelete.value ? 1 : 0,
                                              duration: const Duration(milliseconds: 300),
                                              child: Container(
                                                color: Colors.black.withOpacity(.5),
                                                child: const Center(
                                                  child: Icon(
                                                    CupertinoIcons.trash,
                                                    size: 20,
                                                    color: AppColors.primaryTextColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Positioned(
                                      //   left: 0,
                                      //   top: isPhoto ? 0 : -2,
                                      //   child: Container(
                                      //     width: isPhoto ? 16 : 20,
                                      //     height: isPhoto ? 16 : 20,
                                      //     decoration: BoxDecoration(
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Colors.black.withOpacity(0.2),
                                      //           spreadRadius: 1,
                                      //           blurRadius: 8,
                                      //           offset: const Offset(0, 0),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     child: Icon(
                                      //       isPhoto ? Icons.photo : CupertinoIcons.video_camera_solid,
                                      //       size: isPhoto ? 12 : 16,
                                      //       color: AppColors.primaryTextColor,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(receivers != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: Get.width,
                      height: bottomSectionHeight,
                      padding: EdgeInsets.fromLTRB(0, 8, 16, safePaddingBottom + 8),
                      color: Colors.black.withOpacity(.6),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemCount: receivers!.length,
                              separatorBuilder: (context, index) => AppSpaces.horizontal4,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final receiver = receivers![index];
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppColors.backgroundLight2,
                                    ),
                                    child: textStyled(receiver, 14, AppColors.primaryTextColor),
                                  ),
                                );
                              },
                            ),
                          ),
                          AppSpaces.horizontal8,
                          Material(
                            clipBehavior: Clip.hardEdge,
                            color: AppColors.themeColor,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: controller.submit,
                              splashColor: Colors.black26,
                              highlightColor: Colors.transparent,
                              splashFactory: InkRipple.splashFactory,
                              child: SizedBox(
                                width: bottomSectionHeight - 16 - safePaddingBottom,
                                height: bottomSectionHeight - 16 - safePaddingBottom,
                                child: const Center(
                                  // child: textStyled(selectedImages.length.toString(), 32, AppColors.textWhiteBase, fontWeight: FontWeight.w600),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.send_rounded,
                                      size: 28,
                                      color: AppColors.textWhiteBase,
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(receivers == null)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      color: AppColors.themeColor,
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        onTap: controller.submit,
                        splashColor: Colors.black26,
                        highlightColor: Colors.transparent,
                        splashFactory: InkRipple.splashFactory,
                        child: SizedBox(
                          width: bottomSectionHeight - 16 - safePaddingBottom,
                          height: bottomSectionHeight - 16 - safePaddingBottom,
                          child: const Center(
                            // child: textStyled(selectedImages.length.toString(), 32, AppColors.textWhiteBase, fontWeight: FontWeight.w600),
                            child: Icon(
                              Icons.check_rounded,
                              size: 28,
                              color: AppColors.textWhiteBase,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }
}


class MediumDetail extends Medium {
  final Uint8List? thumbnail;
  MediumDetail.fromJson(super.json) : thumbnail = json['thumbnail'], super.fromJson();
  @override
  Map<String, dynamic> get toJson => {...super.toJson, "thumbnail": thumbnail};
}
